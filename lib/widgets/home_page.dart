import 'package:fluent_ui/fluent_ui.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:window_control/styled/index.dart';
import 'package:window_control/widgets/app_bar.dart';
import 'package:window_control/widgets/content.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AppBar(title: "窗口控制"),
        const Content().expanded(),
      ],
    ).mica();
  }
}
