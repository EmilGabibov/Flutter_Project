{{flutter_js}}
{{flutter_build_config}}

window.localStorage.setItem(
  'hable_loaded_service_worker_version',
  String({{flutter_service_worker_version}})
);

_flutter.loader.load({
  serviceWorkerSettings: {
    serviceWorkerVersion: {{flutter_service_worker_version}},
    serviceWorkerUrl: 'push_service_worker.js?v=' + {{flutter_service_worker_version}}
  }
});
