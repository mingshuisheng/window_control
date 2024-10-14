import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:window_manager/window_manager.dart';

extension WindowManagerWidget on Widget {
  Widget dragToMoveArea({
    Key? key,
  }) =>
      DragToMoveArea(
        key: key,
        child: this,
      );
}

extension FluentStyle on Widget {
  Widget mica() => Mica(child: this);
}

extension MyStyleUtils on Widget {
  Widget full() =>
      SizedBox(width: double.infinity, height: double.infinity, child: this);

  Widget fullWidth() => SizedBox(width: double.infinity, child: this);

  Widget fullHeight() => SizedBox(height: double.infinity, child: this);

  Widget ignorePointer() => IgnorePointer(child: this);

  Widget centerStart() =>
      Align(alignment: AlignmentDirectional.centerStart, child: this);

  Widget topStart() =>
      Align(alignment: AlignmentDirectional.topStart, child: this);

  Widget cursor(MouseCursor cursor) => MouseRegion(
        cursor: cursor,
        child: this,
      );

  Widget positionedFill() => Positioned.fill(child: this);

  Widget widthPercent(double widthFactor) => FractionallySizedBox(
        widthFactor: widthFactor,
        child: this,
      );

  Widget heightPercent(double heightFactor) => FractionallySizedBox(
        heightFactor: heightFactor,
        child: this,
      );
}

extension MyStyleFlexUtils on Flex {
  Widget gap(double gap) {
    final List<Widget> newChildren = [];
    for (final oldChild in children) {
      newChildren.add(oldChild);
      newChildren.add(SizedBox(width: gap, height: gap));
    }
    return Flex(
      key: key,
      direction: direction,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      clipBehavior: clipBehavior,
      children: newChildren,
    );
  }
}

extension MyEventListener on Widget {
  Widget keyboard() {
    return KeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      child: this,
      onKeyEvent: (e) {
        debugPrint("keyboard ${e.logicalKey}");
      },
    );
  }

  Widget listener({
    Key? key,
    PointerDownEventListener? onPointerDown,
    PointerMoveEventListener? onPointerMove,
    PointerUpEventListener? onPointerUp,
    PointerHoverEventListener? onPointerHover,
    PointerCancelEventListener? onPointerCancel,
    PointerPanZoomStartEventListener? onPointerPanZoomStart,
    PointerPanZoomUpdateEventListener? onPointerPanZoomUpdate,
    PointerPanZoomEndEventListener? onPointerPanZoomEnd,
    PointerSignalEventListener? onPointerSignal,
    behavior = HitTestBehavior.deferToChild,
  }) =>
      Listener(
        key: key,
        onPointerDown: onPointerDown,
        onPointerMove: onPointerMove,
        onPointerUp: onPointerUp,
        onPointerHover: onPointerHover,
        onPointerCancel: onPointerCancel,
        onPointerPanZoomStart: onPointerPanZoomStart,
        onPointerPanZoomUpdate: onPointerPanZoomUpdate,
        onPointerPanZoomEnd: onPointerPanZoomEnd,
        onPointerSignal: onPointerSignal,
        behavior: behavior,
        child: this,
      );

  Widget mouseRegion({
    Key? key,
    PointerEnterEventListener? onEnter,
    PointerExitEventListener? onExit,
    PointerHoverEventListener? onHover,
    MouseCursor cursor = MouseCursor.defer,
    bool opaque = true,
    HitTestBehavior? hitTestBehavior,
  }) =>
      MouseRegion(
        key: key,
        onEnter: onEnter,
        onExit: onExit,
        onHover: onHover,
        cursor: cursor,
        opaque: opaque,
        hitTestBehavior: hitTestBehavior,
        child: this,
      );
}
