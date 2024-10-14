import "window.dart";

abstract mixin class Win32EventListener {
  void onSelectChange(String title) {}

  void onLockWindow(Window window) {}
}
