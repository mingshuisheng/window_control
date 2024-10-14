import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart' as flutter_acrylic;
import 'package:system_theme/system_theme.dart';
import 'package:window_manager/window_manager.dart';

import 'app.dart';
import 'win32_tools/win32_tools.dart';

class MyWindowListener with WindowListener {
  @override
  void onWindowClose() {
    win32tools.destroy();
    exit(0);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemTheme.accentColor.load();
  await flutter_acrylic.Window.initialize();
  await flutter_acrylic.Window.hideWindowControls();
  await windowManager.ensureInitialized();
  await windowManager.waitUntilReadyToShow(
    WindowOptions(
        size: const Size(320, 600),
        minimumSize: const Size(320, 600),
        maximumSize: const Size(320, 600),
        center: true),
    () async {
      win32tools.init();
      windowManager.addListener(MyWindowListener());
      await windowManager.setTitleBarStyle(
        TitleBarStyle.hidden,
        windowButtonVisibility: false,
      );
      await windowManager.setResizable(false);
    },
  );
  runApp(const MyApp());
}
