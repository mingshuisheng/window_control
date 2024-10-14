import 'dart:async';
import 'dart:ffi';
import 'dart:isolate';
import 'dart:ui' as ui;

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

import 'win32_event_listener.dart';
import 'window.dart';

final Win32Tools win32tools = Win32Tools();

class SelectingWindow {
  final String title;

  SelectingWindow({required this.title});
}

class LockWindow {
  final String title;
  final int window;

  LockWindow({required this.title, required this.window});
}

class Win32Tools {
  bool _selecting = false;
  Timer? _selectingTimer;
  final ReceivePort _receive = ReceivePort();
  final Set<Win32EventListener> _listeners = {};
  int? _mouseHook;

  void init() {
    Isolate.spawn((sendPort) {
      int hook = 0;
      int mouseProc(int nCode, int wParam, int lParam) {
        if (nCode >= 0 && wParam == WM_LBUTTONDOWN) {
          final point = Pointer<MOUSEHOOKSTRUCTEX>.fromAddress(lParam);
          final cursorPoint = ui.Offset(
              point.ref.Base.pt.x.toDouble(), point.ref.Base.pt.y.toDouble());
          sendPort.send(cursorPoint);
        }

        return CallNextHookEx(hook, nCode, wParam, lParam);
      }

      final lpfn = NativeCallable<HOOKPROC>.isolateLocal(mouseProc,
          exceptionalReturn: 0);

      hook = SetWindowsHookEx(
          WINDOWS_HOOK_ID.WH_MOUSE_LL, lpfn.nativeFunction, NULL, 0);
      sendPort.send(hook);

      final msg = calloc<MSG>();
      while (GetMessage(msg, NULL, 0, 0) != 0) {
        TranslateMessage(msg);
        DispatchMessage(msg);
      }
      lpfn.close();
    }, _receive.sendPort);

    final point = calloc<POINT>();
    _receive.listen((data) {
      if (_selecting && data is ui.Offset) {
        point.ref.x = data.dx.toInt();
        point.ref.y = data.dy.toInt();
        final window = WindowFromPoint(point.ref);
        final topWindow = getNonChildParentWindow(window);
        stopSelect();
        for (var listener in _listeners) {
          listener.onLockWindow(Window(topWindow));
        }
      } else if (data is int) {
        _mouseHook = data;
      }
    });
  }

  Future<void> destroy() async {
    if (_mouseHook != null) {
      UnhookWindowsHookEx(_mouseHook!);
      _mouseHook = null;
    }
    _receive.close();
  }

  var currentPoint = calloc<POINT>();

  void startSelect() {
    _selecting = true;
    _selectingTimer = Timer.periodic(const Duration(milliseconds: 250), (_) {
      GetCursorPos(currentPoint);
      final window = WindowFromPoint(currentPoint.ref);
      final topWindow = getNonChildParentWindow(window);
      final title = getWindowTitle(topWindow);
      for (var listener in _listeners) {
        listener.onSelectChange(title);
      }
    });
  }

  void stopSelect() {
    _selecting = false;
    _selectingTimer?.cancel();
    _selectingTimer = null;
  }

  void addListener(Win32EventListener listener) {
    _listeners.add(listener);
  }

  void removeListener(Win32EventListener listener) {
    _listeners.remove(listener);
  }
}

String getWindowTitle(int window) {
  final len = GetWindowTextLength(window);
  final buff = wsalloc(len + 1);
  GetWindowText(window, buff, len + 1);
  return buff.toDartString();
}

int getNonChildParentWindow(int window) {
  if (window == 0) {
    return window;
  }
  int parent_prev = window;

  while (true) {
    final data = GetWindowLongPtr(parent_prev, WINDOW_LONG_PTR_INDEX.GWL_STYLE);
    if (data & WINDOW_STYLE.WS_CHILD == 0) {
      return parent_prev;
    }
    final parent = GetParent(parent_prev);
    if (parent == 0) {
      return parent_prev;
    }
    parent_prev = parent;
  }
}
