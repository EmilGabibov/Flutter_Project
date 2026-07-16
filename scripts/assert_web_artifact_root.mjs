#!/usr/bin/env node
import { existsSync } from 'node:fs';
import { resolve } from 'node:path';

const root = resolve(process.argv[2] ?? '');
const expected = resolve('build/web');
const stale = resolve('backend/public');
if (root !== expected) {
  console.error(`Refusing deployment root ${root}; only ${expected} is allowed.`);
  process.exit(1);
}
if (root === stale || root.startsWith(`${stale}/`)) {
  console.error('Refusing stale backend/public deployment assets.');
  process.exit(1);
}
if (!existsSync(`${root}/index.html`)) {
  console.error(`Flutter web artifact is missing index.html: ${root}`);
  process.exit(1);
}
console.log(`Verified canonical web artifact root: ${root}`);
