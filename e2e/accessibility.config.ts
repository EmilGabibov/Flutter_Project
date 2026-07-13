export type AccessibilityViewport = {
  height: number;
  name: string;
  width: number;
};

export type AccessibilityRoute = {
  name: string;
  path: string;
  waitFor?: {
    networkIdleMs?: number;
    selector?: string;
    timeoutMs?: number;
  };
};

export type AccessibilityAuditConfig = {
  axe: {
    disableRules: string[];
    includedImpacts: Array<'critical' | 'serious' | 'moderate' | 'minor'>;
    runOnlyTags: string[];
  };
  baseURL: string;
  output: {
    json: string;
    junit: string;
    html: string;
  };
  routes: AccessibilityRoute[];
  viewports: AccessibilityViewport[];
};

const config: AccessibilityAuditConfig = {
  // Reuse the same local Flutter web default as the Playwright harness.
  baseURL: process.env.BASE_URL || 'http://localhost:8080',
  axe: {
    // Keep the first pass focused on broadly actionable WCAG failures.
    runOnlyTags: ['wcag2a', 'wcag2aa', 'wcag21aa', 'best-practice'],
    includedImpacts: ['critical', 'serious', 'moderate'],
    // Leave this empty until the app has explicit documented exceptions.
    disableRules: [],
  },
  output: {
    html: 'playwright-report/accessibility-report.html',
    json: 'playwright-report/accessibility-report.json',
    junit: 'playwright-report/accessibility-report.xml',
  },
  viewports: [
    {
      name: 'mobile',
      width: 390,
      height: 844,
    },
    {
      name: 'desktop',
      width: 1440,
      height: 1080,
    },
  ],
  routes: [
    {
      name: 'app-shell',
      path: '/',
      waitFor: {
        selector: 'body',
        timeoutMs: 15000,
        networkIdleMs: 750,
      },
    },
  ],
};

export default config;
