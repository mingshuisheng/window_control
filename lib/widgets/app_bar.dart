import 'package:fluent_ui/fluent_ui.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:window_control/styled/index.dart';
import 'package:window_manager/window_manager.dart';

class AppBar extends StatelessWidget {
  const AppBar({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    return Row(
      children: [
        Text(title)
            .centerStart()
            .padding(left: 10)
            .dragToMoveArea()
            .height(50)
            .expanded(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            WindowCaption(
              brightness: theme.brightness,
              backgroundColor: Colors.transparent,
            ).width(138).height(50),
          ],
        ),
      ],
    );
  }
}
