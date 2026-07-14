import 'package:flutter/material.dart';

enum MenuIntent {
  primary,
  edit,
  share,
  destructive,
}

class HableMenuItem<T> {
  final String label;
  final T value;
  final IconData? icon;
  final MenuIntent intent;
  final bool withDividerBefore;

  const HableMenuItem({
    required this.label,
    required this.value,
    this.icon,
    this.intent = MenuIntent.primary,
    this.withDividerBefore = false,
  });
}
