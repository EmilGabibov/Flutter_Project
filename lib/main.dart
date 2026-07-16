import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/hable_app.dart';
import 'services/background_sync_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await BackgroundSyncService().initialize();

  runApp(const ProviderScope(child: HableApp()));
}
