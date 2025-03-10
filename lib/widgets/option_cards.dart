import 'package:flutter/material.dart';

class OptionCard<T> extends StatelessWidget {
  final String title;
  final T value;
  final T? selectedValue;
  final Function(T) onTap;

  const OptionCard({
    required this.title,
    required this.value,
    required this.selectedValue,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSelected = selectedValue == value;

    return GestureDetector(
      onTap: () => onTap(value),
      child: Container(
        width: double.infinity,
        height: 80,
        decoration: BoxDecoration(
          color:
              isSelected
                  ? theme.colorScheme.primaryContainer
                  : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border:
              isSelected
                  ? Border.all(color: theme.colorScheme.primary, width: 2)
                  : Border.all(
                    color: theme.colorScheme.outline.withAlpha(51),
                    width: 1,
                  ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              if (isSelected)
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    color: theme.colorScheme.onPrimary,
                    size: 16,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
