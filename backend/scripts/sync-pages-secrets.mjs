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
const optionalKeys = [
  'VAPID_PUBLIC_KEY',
  'VAPID_PRIVATE_KEY',
  'VAPID_SUBJECT',
  'PUSH_DISPATCH_TOKEN',
]
const allowedKeys = new Set([...requiredKeys, ...optionalKeys])

const tempDir = fs.mkdtempSync(path.join(os.tmpdir(), 'hable-pages-secrets-'))
const secretsFile = path.join(tempDir, 'pages-secrets.env')

const download = spawnSync(
  'doppler',
  [
    'secrets',
    'download',
    '--format=env-no-quotes',
    '--no-file',
    '--project',
    project,
    '--config',
    config,
    '--no-cache',
  ],
  { encoding: 'utf8' },
)

if ((download.status ?? 1) !== 0) {
  process.exit(download.status ?? 1)
}

const contents = (download.stdout ?? '').toString()
fs.writeFileSync(secretsFile, contents)
const entries = contents
  .split(/\r?\n/)
  .map((line) => line.trim())
  .filter(Boolean)
  .map((line) => {
    const separatorIndex = line.indexOf('=')
    if (separatorIndex === -1) return null
    return {
      key: line.slice(0, separatorIndex),
      value: line.slice(separatorIndex + 1),
    }
  })
  .filter((entry) => entry && allowedKeys.has(entry.key))

const missing = requiredKeys.filter((key) => !entries.some((entry) => entry?.key === key))
if (missing.length > 0) {
  console.error(`Missing required secrets in Doppler ${project}/${config}: ${missing.join(', ')}`)
  process.exit(1)
}

const filteredSecretsFile = path.join(tempDir, 'pages-secrets.filtered.env')
fs.writeFileSync(
  filteredSecretsFile,
  entries.map((entry) => `${entry.key}=${entry.value}`).join('\n'),
)

const upload = spawnSync(
  'npx',
  ['wrangler', 'pages', 'secret', 'bulk', filteredSecretsFile, '--project-name', pagesProject],
  {
    stdio: 'inherit',
    encoding: 'utf8',
  },
)

try {
  fs.rmSync(tempDir, { recursive: true, force: true })
} catch {}

process.exit(upload.status ?? 1)
