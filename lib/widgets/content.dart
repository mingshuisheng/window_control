import 'package:fluent_ui/fluent_ui.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:window_control/styled/index.dart';
import 'package:window_control/win32_tools/win32_event_listener.dart';
import 'package:window_control/win32_tools/win32_tools.dart';

import '../win32_tools/window.dart';

class Content extends StatefulWidget {
  const Content({super.key});

  @override
  State<Content> createState() => _ContentState();
}

class _ContentState extends State<Content> with Win32EventListener {
  final windowTitleController = TextEditingController();
  Window? window;
  int? width;
  int? height;
  int? x;
  int? y;
  int? clientWidth;
  int? clientHeight;

  @override
  void initState() {
    super.initState();
    win32tools.addListener(this);
  }

  @override
  void dispose() {
    super.dispose();
    windowTitleController.dispose();
  }

  void _reloadWindowState() {
    if (window != null) {
      final bounds = window!.getBounds();
      final clientBounds = window!.getClientBounds();
      setState(() {
        x = bounds.left.toInt();
        y = bounds.top.toInt();
        width = bounds.width.toInt();
        height = bounds.height.toInt();
        clientWidth = clientBounds.width.toInt();
        clientHeight = clientBounds.height.toInt();
      });
    } else {
      setState(() {
        x = null;
        y = null;
        width = null;
        height = null;
        clientWidth = null;
        clientHeight = null;
      });
    }
  }

  @override
  void onSelectChange(String title) {
    windowTitleController.text = title;
  }

  @override
  void onLockWindow(Window w) {
    window = w;
    setState(() {
      windowTitleController.text = window!.getTitle();
    });
    _reloadWindowState();
  }

  void _startSelect() {
    window = null;
    win32tools.startSelect();
    _reloadWindowState();
  }

  void _moveWindow() {
    if (window != null) {
      window!.setPosition(Offset(x!.toDouble(), y!.toDouble()));
      _reloadWindowState();
    }
  }

  void _setWindowSize() {
    if (window != null) {
      window!.setSize(Size(width!.toDouble(), height!.toDouble()));
    }
  }

  void _setWindowClientSize() {
    if (window != null) {
      window!.setClientSize(
          Size(clientWidth!.toDouble(), clientHeight!.toDouble()));
    }
  }

  void _windowToCenter() {
    if (window != null) {
      window!.moveToCenter();
    }
  }

  void _clientToCenter() {
    if (window != null) {
      window!.moveClientToCenter();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InfoLabel(
          label: "窗口名称",
          child: TextBox(
            controller: windowTitleController,
            placeholder: "点击这里选取需要控制的窗口",
            expands: false,
            enabled: false,
            // readOnly: true,
          ),
        ).cursor(SystemMouseCursors.click).gestures(onTap: _startSelect),
        const SizedBox(height: 20),
        InfoLabel(
          label: "窗口位置",
          child: Row(
            children: [
              NumberBox(
                value: x,
                textAlign: TextAlign.center,
                mode: SpinButtonPlacementMode.none,
                onChanged: (v) => x = v,
              ).expanded(),
              const SizedBox(
                width: 10,
              ),
              NumberBox(
                value: y,
                textAlign: TextAlign.center,
                mode: SpinButtonPlacementMode.none,
                onChanged: (v) => y = v,
              ).expanded(),
            ],
          ).center(),
        ),
        const SizedBox(height: 10),
        FilledButton(onPressed: _moveWindow, child: const Text("修改"))
            .widthPercent(0.6)
            .center(),
        const SizedBox(height: 20),
        InfoLabel(
          label: "窗口大小",
          child: Row(
            children: [
              NumberBox(
                value: width,
                textAlign: TextAlign.center,
                mode: SpinButtonPlacementMode.none,
                onChanged: (v) => width = v,
              ).expanded(),
              const SizedBox(
                width: 10,
              ),
              NumberBox(
                value: height,
                textAlign: TextAlign.center,
                mode: SpinButtonPlacementMode.none,
                onChanged: (v) => height = v,
              ).expanded(),
            ],
          ).center(),
        ),
        const SizedBox(height: 10),
        FilledButton(onPressed: _setWindowSize, child: const Text("修改"))
            .widthPercent(0.6)
            .center(),
        const SizedBox(height: 20),
        InfoLabel(
          label: "窗口客户大小",
          child: Row(
            children: [
              NumberBox(
                value: clientWidth,
                textAlign: TextAlign.center,
                mode: SpinButtonPlacementMode.none,
                onChanged: (v) => clientWidth = v,
              ).expanded(),
              const SizedBox(
                width: 10,
              ),
              NumberBox(
                value: clientHeight,
                textAlign: TextAlign.center,
                mode: SpinButtonPlacementMode.none,
                onChanged: (v) => clientHeight = v,
              ).expanded(),
            ],
          ).center(),
        ),
        const SizedBox(height: 10),
        FilledButton(onPressed: _setWindowClientSize, child: const Text("修改"))
            .widthPercent(0.6)
            .center(),
        Container().expanded(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton(onPressed: _windowToCenter, child: const Text("居中"))
                .expanded(),
            const SizedBox(width: 10),
            FilledButton(
                    onPressed: _clientToCenter, child: const Text("居中（客户区域）"))
                .expanded(),
          ],
        )
      ],
    )
        .topStart()
        .padding(all: 10)
        .backgroundColor(theme.scaffoldBackgroundColor);
  }
}
