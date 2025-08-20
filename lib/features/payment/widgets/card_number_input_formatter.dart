import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class _CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var digitsOnly = newValue.text.replaceAll(' ', '');
    var newText = '';
    for (int i = 0; i < digitsOnly.length; i++) {
      if (i % 4 == 0 && i != 0) newText += ' ';
      newText += digitsOnly[i];
    }
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
