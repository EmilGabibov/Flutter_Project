/*
 * This is the only app-scope worker. The release preparation script replaces
 * the generated asset block with the exact finite build/web file list.
 */
const HABLE_SHELL_ASSETS = [
  './',
  './index.html',
  './flutter_bootstrap.js',
  './flutter.js',
  './main.dart.js',
  './assets/AssetManifest.bin',
  './assets/AssetManifest.bin.json',
  './assets/FontManifest.json',
  './assets/NOTICES',
  './manifest.json',
  './version.json',
  './icons/Icon-192.png',
  './sql-wasm.js',
  './sql-wasm.wasm',
];

const workerVersion = new URL(self.location.href).searchParams.get('v') || 'dev';
const cacheName = `hable-shell-${workerVersion}`;
const scopeUrl = new URL(self.registration.scope);

function absoluteAssetUrl(path) {
  return new URL(path, scopeUrl).toString();
}

function isCacheableAsset(request) {
  const url = new URL(request.url);
  return url.origin === self.location.origin &&
    !url.pathname.includes('/api/') &&
    (['document', 'font', 'image', 'manifest', 'script', 'style'].includes(request.destination) ||
      url.pathname.endsWith('.wasm') ||
      url.pathname.endsWith('.frag'));
}

function isSameOriginNonApi(request) {
  const url = new URL(request.url);
  return url.origin === self.location.origin && !url.pathname.includes('/api/');
}

self.addEventListener('install', (event) => {
  event.waitUntil((async () => {
    const cache = await caches.open(cacheName);
    await Promise.allSettled(
      HABLE_SHELL_ASSETS.map((asset) => cache.add(absoluteAssetUrl(asset))),
    );
    await self.skipWaiting();
  })());
});

self.addEventListener('activate', (event) => {
  event.waitUntil((async () => {
    const cacheKeys = await caches.keys();
    await Promise.all(
      cacheKeys
        .filter((key) => key.startsWith('hable-shell-') && key !== cacheName)
        .map((key) => caches.delete(key)),
    );
    await self.clients.claim();
  })());
});

self.addEventListener('fetch', (event) => {
  const { request } = event;
  if (request.method !== 'GET' || !isSameOriginNonApi(request)) return;

  event.respondWith((async () => {
    const cache = await caches.open(cacheName);
    const cached = await cache.match(request);
    if (cached) return cached;
    try {
      const response = await fetch(request);
      if (response.ok && isCacheableAsset(request)) {
        await cache.put(request, response.clone());
      }
      return response;
    } catch (_) {
      if (request.mode === 'navigate') {
        return cache.match(absoluteAssetUrl('./index.html')) || Response.error();
      }
      return Response.error();
    }
  })());
});

self.addEventListener('push', (event) => {
  let data = {};
  try {
    data = event.data ? event.data.json() : {};
  } catch (_) {
    data = { body: event.data ? event.data.text() : 'Your Hable habits are waiting.' };
  }
  const title = String(data.title || 'Hable reminder').slice(0, 80);
  const body = String(data.body || 'Your Hable habits are waiting.').slice(0, 180);
  const route = data.route === '/social' ? '/social' : '/';
  event.waitUntil(self.registration.showNotification(title, {
    body,
    icon: absoluteAssetUrl('./icons/Icon-192.png'),
    badge: absoluteAssetUrl('./icons/Icon-192.png'),
    tag: 'hable-reminder',
    data: { route },
  }));
});

self.addEventListener('notificationclick', (event) => {
  event.notification.close();
  const route = event.notification.data && event.notification.data.route || '/';
  const target = new URL(
    route === '/' ? './' : route.slice(1),
    self.registration.scope,
  ).toString();
  event.waitUntil(
    self.clients.matchAll({ type: 'window', includeUncontrolled: true }).then((clients) => {
      const existing = clients.find((client) => 'focus' in client);
      if (existing) {
        existing.navigate(target);
        return existing.focus();
      }
      return self.clients.openWindow(target);
    }),
  );
});
