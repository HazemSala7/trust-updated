import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final Function(String)? onChanged;
  final FormFieldValidator<String>? validator; // Changed to FormFieldValidator
  final Color? borderColor;
  final Color? backgroundColor;
  final double? height;
  final double? borderRadius;

  CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.validator,
    this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.focusNode,
    this.onChanged,
    this.borderColor,
    this.backgroundColor,
    this.height,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: height, // Use specified height
      duration: const Duration(milliseconds: 500), // Adjust duration as needed
      curve: Curves.easeInOut,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius!),
        child: TextFormField(
          validator: validator,
          controller: controller,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            prefixIcon: icon != null ? Icon(icon) : null,
            filled: true,
            fillColor: backgroundColor ?? Colors.white,
          ),
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          focusNode: focusNode,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
