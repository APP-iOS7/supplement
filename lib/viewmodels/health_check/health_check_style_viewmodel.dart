import 'package:flutter/material.dart';

class HealthCheckStyleViewModel {
  // Button text style with black color for both light and dark mode
  TextStyle get buttonTextStyle => const TextStyle(
    color: Colors.black,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  // Option text style that adapts based on selection
  TextStyle getOptionTextStyle(bool isSelected, bool isDarkMode) {
    return TextStyle(
      color: isSelected ? Colors.white : Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    );
  }

  // Simple getter for option text style with default values
  TextStyle get optionTextStyle => const TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
}