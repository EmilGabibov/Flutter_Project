// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter

import 'dart:html' as html;

String? getCurrentWebOrigin() {
  final origin = html.window.location.origin.trim();
  return origin.isEmpty ? null : origin;
}
