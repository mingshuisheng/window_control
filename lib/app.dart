import 'package:fluent_ui/fluent_ui.dart';

import './theme.dart';
import 'widgets/home_page.dart';

final appTheme = AppTheme();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: "窗口控制",
      themeMode: appTheme.mode,
      debugShowCheckedModeBanner: false,
      color: appTheme.color,
      darkTheme: FluentThemeData(
        brightness: Brightness.dark,
        accentColor: appTheme.color,
        visualDensity: VisualDensity.standard,
        dialogTheme: appTheme.dialogTheme,
        focusTheme:
            FocusThemeData(glowFactor: is10footScreen(context) ? 2.0 : 0.0),
      ),
      theme: FluentThemeData(
        accentColor: appTheme.color,
        visualDensity: VisualDensity.standard,
        dialogTheme: appTheme.dialogTheme,
        focusTheme:
            FocusThemeData(glowFactor: is10footScreen(context) ? 2.0 : 0.0),
      ),
      locale: appTheme.locale,
      home: const HomePage(),
    );
  }
}
