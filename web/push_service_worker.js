/* Lightweight return-to-app worker. Flutter's generated worker remains separate. */
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
    icon: '/icons/Icon-192.png',
    badge: '/icons/Icon-192.png',
    tag: 'hable-reminder',
    data: { route },
  }));
});

self.addEventListener('notificationclick', (event) => {
  event.notification.close();
  const route = event.notification.data && event.notification.data.route || '/';
  event.waitUntil(
    self.clients.matchAll({ type: 'window', includeUncontrolled: true }).then((clients) => {
      const existing = clients.find((client) => 'focus' in client);
      if (existing) {
        existing.navigate(new URL(route, self.location.origin).toString());
        return existing.focus();
      }
      return self.clients.openWindow(new URL(route, self.location.origin).toString());
    }),
  );
});
