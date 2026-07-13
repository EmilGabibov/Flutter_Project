import fs from 'fs'
import os from 'os'
import path from 'path'
import { spawnSync } from 'child_process'

const project = process.env.DOPPLER_PROJECT || 'hable'
const config = process.env.DOPPLER_CONFIG || 'dev'
const pagesProject = process.env.PAGES_PROJECT || 'hable'
const requiredKeys = [
  'CLOUDFLARE_ACCOUNT_ID',
  'PRIVATE_CLOUDFLARE_EMAIL_API_TOKEN',
  'PRIVATE_EMAIL_SENDER_HABLE',
]

const tempDir = fs.mkdtempSync(path.join(os.tmpdir(), 'hable-pages-secrets-'))
const secretsFile = path.join(tempDir, 'pages-secrets.env')

const download = spawnSync(
  'doppler',
  [
    'secrets',
    'download',
    secretsFile,
    '--format=env-no-quotes',
    '--project',
    project,
    '--config',
    config,
    '--no-cache',
  ],
  {
    stdio: 'inherit',
    encoding: 'utf8',
  },
)

if ((download.status ?? 1) !== 0) {
  process.exit(download.status ?? 1)
}

const contents = fs.readFileSync(secretsFile, 'utf8')
const missing = requiredKeys.filter((key) => !new RegExp(`^${key}=`, 'm').test(contents))
if (missing.length > 0) {
  console.error(`Missing required secrets in Doppler ${project}/${config}: ${missing.join(', ')}`)
  process.exit(1)
}

const upload = spawnSync(
  'npx',
  ['wrangler', 'pages', 'secret', 'bulk', secretsFile, '--project-name', pagesProject],
  {
    stdio: 'inherit',
    encoding: 'utf8',
  },
)

try {
  fs.rmSync(tempDir, { recursive: true, force: true })
} catch {}

process.exit(upload.status ?? 1)
