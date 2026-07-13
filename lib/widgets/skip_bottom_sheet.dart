import 'dart:ui';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';

/// Glassmorphic bottom sheet requiring a journal entry to process a skip.
/// Per spec 03 §2: "Mandatory Friction".
class SkipBottomSheet extends StatefulWidget {
  final String habitTitle;
  final void Function(String journalEntry) onSkipConfirmed;

  const SkipBottomSheet({
    super.key,
    required this.habitTitle,
    required this.onSkipConfirmed,
  });

  /// Show as a modal bottom sheet.
  static Future<void> show(
    BuildContext context, {
    required String habitTitle,
    required void Function(String journalEntry) onSkipConfirmed,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SkipBottomSheet(
        habitTitle: habitTitle,
        onSkipConfirmed: onSkipConfirmed,
      ),
    );
  }

  @override
  State<SkipBottomSheet> createState() => _SkipBottomSheetState();
}

class _SkipBottomSheetState extends State<SkipBottomSheet> {
  final _controller = TextEditingController();
  bool _isValid = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.85),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
              border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
            ),
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppTheme.warmGray.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                Text(
                  loc.skipSheetTitle(widget.habitTitle),
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: AppTheme.overdueRose),
                ),
                const SizedBox(height: 8),
                Text(
                  loc.skipSheetBody,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),

                // Journal input
                TextField(
                  controller: _controller,
                  maxLines: 3,
                  autofocus: true,
                  decoration: InputDecoration(hintText: loc.skipSheetHint),
                  onChanged: (value) {
                    setState(() {
                      _isValid = value.trim().isNotEmpty;
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Confirm button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isValid
                        ? () {
                            widget.onSkipConfirmed(_controller.text.trim());
                            Navigator.of(context).pop();
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isValid
                          ? AppTheme.skipAmber
                          : AppTheme.warmGray,
                    ),
                    child: Text(loc.skipSheetConfirm),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
