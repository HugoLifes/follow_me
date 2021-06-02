import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextField extends StatelessWidget {
  final FormFieldSetter<String> onSaved;
  final Icon icon;
  final String hint;
  final bool obscure;
  final FormFieldValidator<String> validator;
  TextEditingController controller = TextEditingController();
  CustomTextField(
      {this.icon,
      this.controller,
      this.hint,
      this.obscure = false,
      this.validator,
      this.onSaved});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: TextFormField(
          controller: controller,
          obscureText: obscure,
          onSaved: onSaved,
          decoration: InputDecoration(
            fillColor: Colors.white,
            hintStyle: TextStyle(color: Color(0xFF444444)),
            hintText: hint,
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF444444), width: 2)),
            prefixIcon: icon,
            suffixIcon: Icon(Icons.error, color: Color(0xFF444444)),
            border: OutlineInputBorder(),
          ),
          validator: validator),
    );
  }
}
