#!/usr/bin/env node
import { createHash } from 'node:crypto';
import { execFileSync } from 'node:child_process';
import { existsSync, readFileSync, writeFileSync } from 'node:fs';
import { resolve } from 'node:path';

function value(name) {
  const index = process.argv.indexOf(`--${name}`);
  if (index < 0 || !process.argv[index + 1]) throw new Error(`Missing --${name}`);
  return process.argv[index + 1];
}

function command(name, args) {
  try { return execFileSync(name, args, { encoding: 'utf8' }).trim(); }
  catch { return 'unavailable'; }
}

const artifact = resolve(value('artifact'));
const artifactLabel = value('artifact');
const output = resolve(value('output'));
const pubspec = readFileSync('pubspec.yaml', 'utf8');
const version = pubspec.match(/^version:\s*(\S+)/m)?.[1] ?? 'unknown';
const sha256 = existsSync(artifact)
  ? createHash('sha256').update(readFileSync(artifact)).digest('hex')
  : 'not-produced';
let flutter = command('flutter', ['--version', '--machine']);
try {
  const parsed = JSON.parse(flutter);
  flutter = {
    version: parsed.flutterVersion ?? 'unknown',
    channel: parsed.channel ?? 'unknown',
    framework_revision: parsed.frameworkRevision ?? 'unknown',
    dart: parsed.dartSdkVersion ?? 'unknown',
  };
} catch {
  flutter = { version: flutter };
}
const record = {
  commit: command('git', ['rev-parse', 'HEAD']),
  target: value('target'),
  flavor: process.argv.includes('--flavor') ? value('flavor') : null,
  environment: value('environment'),
  version,
  artifact: artifactLabel,
  artifact_sha256: sha256,
  node: process.version,
  flutter,
  generated_at_utc: new Date().toISOString(),
};
writeFileSync(output, `${JSON.stringify(record, null, 2)}\n`);
console.log(`Wrote bounded build provenance: ${output}`);
