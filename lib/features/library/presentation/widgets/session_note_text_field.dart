import 'package:flutter/material.dart';

class NoteTextField extends StatelessWidget {
  const NoteTextField({
    required this.controller,
    required this.label,
    required this.hintText,
    this.scrollPadding = const EdgeInsets.all(20),
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final String hintText;
  final EdgeInsets scrollPadding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      scrollPadding: scrollPadding,
      style: theme.textTheme.bodyMedium!.copyWith(
        color: theme.colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        labelText: label,
        fillColor: theme.colorScheme.surface,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: const EdgeInsets.all(8),
        hintText: hintText,
        hintStyle: theme.textTheme.bodyMedium!.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
        ),
      ),
      minLines: 4,
      maxLines: 4,
    );
  }
}
