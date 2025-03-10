import 'package:flutter/material.dart';

class NextButton extends StatelessWidget {
  const NextButton({
    super.key,
    required this.canProceed,
    required this.nextPage,
    required this.onTap,
  });
  final Function() onTap;
  final bool canProceed;
  final Widget nextPage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed:
            canProceed
                ? () {
                  onTap();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => nextPage,
                    ),
                  );
                }
                : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          '다음',
          style:
              canProceed
                  ? Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(color: Colors.white)
                  : Theme.of(context).textTheme.labelLarge,
        ),
      ),
    );
  }
}
