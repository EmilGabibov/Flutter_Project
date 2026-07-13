import AxeBuilder from '@axe-core/playwright';
import { expect, test } from '@playwright/test';
import fs from 'node:fs/promises';
import path from 'node:path';

import accessibilityConfig from '../accessibility.config';

type AxeResults = Awaited<ReturnType<ReturnType<typeof buildAxeRunner>['analyze']>>;

function buildAxeRunner(page: Parameters<typeof AxeBuilder>[0]['page']) {
  let runner = new AxeBuilder({ page }).withTags(
    accessibilityConfig.axe.runOnlyTags,
  );

  for (const rule of accessibilityConfig.axe.disableRules) {
    runner = runner.disableRules(rule);
  }

  return runner;
}

function sanitizeSegment(value: string) {
  return value.replace(/[^a-z0-9_-]+/gi, '-').replace(/^-+|-+$/g, '').toLowerCase();
}

async function ensureParentDir(filePath: string) {
  await fs.mkdir(path.dirname(filePath), { recursive: true });
}

test.describe('accessibility smoke', () => {
  const aggregatedResults: Array<{
    route: string;
    viewport: string;
    violations: AxeResults['violations'];
  }> = [];

  test.afterAll(async () => {
    const violationsOnly = aggregatedResults.filter(
      (entry) => entry.violations.length > 0,
    );
    const summary = {
      baseURL: accessibilityConfig.baseURL,
      generatedAt: new Date().toISOString(),
      routes: aggregatedResults,
      totalAudits: aggregatedResults.length,
      totalViolations: violationsOnly.reduce(
        (sum, entry) => sum + entry.violations.length,
        0,
      ),
    };

    for (const outputPath of Object.values(accessibilityConfig.output)) {
      await ensureParentDir(outputPath);
    }

    await fs.writeFile(
      accessibilityConfig.output.json,
      JSON.stringify(summary, null, 2),
      'utf8',
    );

    const html = `<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <title>Hable Accessibility Smoke Report</title>
    <style>
      body { font-family: Arial, sans-serif; margin: 24px; line-height: 1.5; }
      h1, h2 { margin-bottom: 0.4rem; }
      .ok { color: #1f7a1f; }
      .fail { color: #a32020; }
      .audit { border: 1px solid #ddd; border-radius: 8px; padding: 16px; margin: 16px 0; }
      code { background: #f4f4f4; padding: 2px 6px; border-radius: 4px; }
      ul { margin-top: 0.5rem; }
    </style>
  </head>
  <body>
    <h1>Hable Accessibility Smoke Report</h1>
    <p><strong>Base URL:</strong> <code>${summary.baseURL}</code></p>
    <p><strong>Generated:</strong> ${summary.generatedAt}</p>
    <p class="${summary.totalViolations === 0 ? 'ok' : 'fail'}">
      <strong>Total audits:</strong> ${summary.totalAudits}
      <br />
      <strong>Total violations:</strong> ${summary.totalViolations}
    </p>
    ${aggregatedResults
      .map((entry) => {
        const heading = `${entry.route} @ ${entry.viewport}`;
        if (entry.violations.length === 0) {
          return `<section class="audit"><h2>${heading}</h2><p class="ok">No violations found.</p></section>`;
        }
        const items = entry.violations
          .map(
            (violation) =>
              `<li><strong>${violation.id}</strong> (${violation.impact ?? 'unknown'}): ${violation.help}</li>`,
          )
          .join('');
        return `<section class="audit"><h2>${heading}</h2><p class="fail">${entry.violations.length} violation(s)</p><ul>${items}</ul></section>`;
      })
      .join('\n')}
  </body>
</html>`;

    await fs.writeFile(accessibilityConfig.output.html, html, 'utf8');

    const junit = `<?xml version="1.0" encoding="UTF-8"?>
<testsuite name="hable-accessibility-smoke" tests="${aggregatedResults.length}" failures="${violationsOnly.length}">
${aggregatedResults
  .map((entry) => {
    const testName = `${entry.route} @ ${entry.viewport}`;
    if (entry.violations.length === 0) {
      return `  <testcase classname="accessibility" name="${testName}" />`;
    }
    const message = entry.violations
      .map(
        (violation) =>
          `${violation.id} (${violation.impact ?? 'unknown'}): ${violation.help}`,
      )
      .join(' | ')
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;');
    return `  <testcase classname="accessibility" name="${testName}"><failure message="${message}" /></testcase>`;
  })
  .join('\n')}
</testsuite>`;

    await fs.writeFile(accessibilityConfig.output.junit, junit, 'utf8');
  });

  for (const route of accessibilityConfig.routes) {
    for (const viewport of accessibilityConfig.viewports) {
      test(`${route.name} @ ${viewport.name}`, async ({ page }) => {
        await page.setViewportSize({
          width: viewport.width,
          height: viewport.height,
        });

        await page.goto(route.path);

        if (route.waitFor?.selector) {
          await page.waitForSelector(route.waitFor.selector, {
            timeout: route.waitFor.timeoutMs ?? 15000,
          });
        }

        if (route.waitFor?.networkIdleMs) {
          await page.waitForLoadState('networkidle', {
            timeout: Math.max(route.waitFor.networkIdleMs, 1000),
          });
        }

        const results = await buildAxeRunner(page).analyze();
        const filteredViolations = results.violations.filter((violation) => {
          if (accessibilityConfig.axe.includedImpacts.length === 0) {
            return true;
          }
          return (
            violation.impact !== null &&
            accessibilityConfig.axe.includedImpacts.includes(violation.impact)
          );
        });

        aggregatedResults.push({
          route: route.name,
          viewport: viewport.name,
          violations: filteredViolations,
        });

        const attachmentName = `${sanitizeSegment(route.name)}-${sanitizeSegment(
          viewport.name,
        )}-axe.json`;
        await test.info().attach(attachmentName, {
          body: Buffer.from(
            JSON.stringify(
              {
                url: page.url(),
                violations: filteredViolations,
              },
              null,
              2,
            ),
          ),
          contentType: 'application/json',
        });

        expect(
          filteredViolations,
          `${route.name} @ ${viewport.name} should have no ${accessibilityConfig.axe.includedImpacts.join(
            ', ',
          )} accessibility violations`,
        ).toHaveLength(0);
      });
    }
  }
});
