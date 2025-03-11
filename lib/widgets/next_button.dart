import 'package:flutter/material.dart';

class NextButton extends StatelessWidget {
  final bool canProceed;
  final Widget nextPage;
  final VoidCallback onTap;

  const NextButton({
    super.key,
    required this.canProceed,
    required this.nextPage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ElevatedButton(
      onPressed:
          canProceed
              ? () {
                onTap();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => nextPage),
                );
              }
              : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Text(
        '확인',
        style: theme.textTheme.titleLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
