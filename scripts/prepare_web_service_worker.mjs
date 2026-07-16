import { readdir, readFile, writeFile } from 'node:fs/promises';
import { join, relative } from 'node:path';

const root = join(process.cwd(), 'build', 'web');
const workerPath = join(root, 'push_service_worker.js');
const start = 'const HABLE_SHELL_ASSETS = [';
const end = '];\n\nconst workerVersion';

async function filesUnder(directory) {
  const entries = await readdir(directory, { withFileTypes: true });
  const files = [];
  for (const entry of entries) {
    const path = join(directory, entry.name);
    if (entry.isDirectory()) {
      files.push(...await filesUnder(path));
    } else {
      files.push(path);
    }
  }
  return files;
}

const files = (await filesUnder(root))
  .map((path) => `./${relative(root, path).split('\\').join('/')}`)
  .filter((path) => !path.endsWith('push_service_worker.js'))
  .filter((path) => !path.endsWith('flutter_service_worker.js'))
  .filter((path) => !path.endsWith('.DS_Store'))
  .filter((path) => !path.endsWith('.map'))
  .filter((path) => !path.endsWith('.symbols'))
  .sort();

const worker = await readFile(workerPath, 'utf8');
const startIndex = worker.indexOf(start);
const endIndex = worker.indexOf(end, startIndex);
if (startIndex < 0 || endIndex < 0) {
  throw new Error(`Could not find Hable shell asset block in ${workerPath}`);
}

const replacement = `${start}\n${files.map((path) => `  ${JSON.stringify(path)},`).join('\n')}\n`;
await writeFile(workerPath, worker.slice(0, startIndex) + replacement + worker.slice(endIndex));
console.log(`Prepared Hable service worker with ${files.length} finite shell assets.`);
