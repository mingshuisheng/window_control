import 'dart:ffi';
import 'dart:ui' as ui;

import 'package:ffi/ffi.dart';
import 'package:flutter/painting.dart';
import 'package:win32/win32.dart';

import '../uiUtil.dart';
import '../utils/calc_window_position.dart';

class Window {
  Window(this.window);

  final int window;

  String getTitle() {
    final len = GetWindowTextLength(window);
    final buff = wsalloc(len + 1);
    GetWindowText(window, buff, len + 1);
    return buff.toDartString();
  }

  final rect = calloc<RECT>();

  ui.Rect getBounds() {
    GetWindowRect(window, rect);
    final devicePixelRatio = getDevicePixelRatio();

    double x = rect.ref.left / devicePixelRatio * 1.0;
    double y = rect.ref.top / devicePixelRatio * 1.0;
    double width = (rect.ref.right - rect.ref.left) / devicePixelRatio * 1.0;
    double height = (rect.ref.bottom - rect.ref.top) / devicePixelRatio * 1.0;

    final result = ui.Rect.fromLTWH(
      x,
      y,
      width,
      height,
    );

    return result;
  }

  void setBounds(ui.Rect bounds) {
    final devicePixelRatio = getDevicePixelRatio();
    final x = bounds.left * devicePixelRatio;
    final y = bounds.top * devicePixelRatio;
    final width = bounds.size.width * devicePixelRatio;
    final height = bounds.size.height * devicePixelRatio;
    MoveWindow(
        window, x.toInt(), y.toInt(), width.toInt(), height.toInt(), TRUE);
  }

  ui.Size getSize() {
    final bounds = getBounds();
    return bounds.size;
  }

  void setSize(ui.Size size) {
    final bounds = getBounds();
    setBounds(bounds.topLeft & size);
  }

  ui.Offset getPosition() {
    final bounds = getBounds();
    return bounds.topLeft;
  }

  void setPosition(ui.Offset position) {
    final bounds = getBounds();
    setBounds(position & bounds.size);
  }

  final clientRect = calloc<RECT>();

  ui.Rect getClientBounds() {
    GetClientRect(window, clientRect);
    final clientToScreenPoint = calloc<POINT>();
    clientToScreenPoint.ref.x = clientRect.ref.left;
    clientToScreenPoint.ref.y = clientRect.ref.top;
    ClientToScreen(window, clientToScreenPoint);

    final devicePixelRatio = getDevicePixelRatio();
    double x = clientToScreenPoint.ref.x / devicePixelRatio * 1.0;
    double y = clientToScreenPoint.ref.y / devicePixelRatio * 1.0;
    double width =
        (clientRect.ref.right - clientRect.ref.left) / devicePixelRatio * 1.0;
    double height =
        (clientRect.ref.bottom - clientRect.ref.top) / devicePixelRatio * 1.0;

    free(clientToScreenPoint);
    return ui.Rect.fromLTWH(
      x,
      y,
      width,
      height,
    );
  }

  ui.Size getClientSize() {
    final clientBounds = getClientBounds();
    return clientBounds.size;
  }

  void setClientSize(ui.Size size) {
    final windowSize = getSize();
    final clientSize = getClientSize();
    final borderWidth = windowSize.width - clientSize.width;
    final borderHeight = windowSize.height - clientSize.height;
    final newSize =
        ui.Size(borderWidth + size.width, borderHeight + size.height);
    setSize(newSize);
  }

  void moveToCenter() async {
    final windowSize = getSize();
    final position = await calcWindowPosition(windowSize, Alignment.center);
    setPosition(position);
  }

  void moveClientToCenter() async {
    final bounds = getBounds();
    final clientBounds = getClientBounds();
    final dx = clientBounds.left - bounds.left;
    final dy = clientBounds.top - bounds.top;
    final clientPosition =
        await calcWindowPosition(clientBounds.size, Alignment.center);
    final position = clientPosition - ui.Offset(dx, dy);
    setPosition(position);
  }
}
