import 'package:flutter/material.dart';

class CustomTextArea extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final String initValue;

  const CustomTextArea(
      {required this.hint, required this.controller, this.initValue = ""});

  @override
  Widget build(BuildContext context) {
    if (initValue.isNotEmpty) {
      controller.text = initValue;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: controller,
        maxLines: 10,
        decoration: InputDecoration(
          hintText: "Enter $hint",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
