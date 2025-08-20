import 'package:flutter/services.dart';

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {

    var digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');


    var newText = '';
    for (var i = 0; i < digitsOnly.length; i++) {
      if (i % 4 == 0 && i != 0) newText += ' ';
      newText += digitsOnly[i];
    }


    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
