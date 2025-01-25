import 'package:flutter/material.dart';
import 'package:todo/utils/utils.dart';
import 'package:gap/gap.dart';

class CommonTextField extends StatelessWidget {
  const CommonTextField({
    super.key,
    this.controller,
    required this.hintText,
    required this.title,
    this.maxLines,
    this.suffixIcon,
    this.readOnly = false,
  });
  final TextEditingController? controller;
  final String hintText;
  final String title;
  final int? maxLines;
  final Widget? suffixIcon;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: context.textTheme.titleLarge
              ?.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const Gap(10),
        TextField(
          readOnly: readOnly,
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          autocorrect: false,
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            hintText: hintText,
            suffixIcon: suffixIcon,
          ),
          maxLines: maxLines,
        ),
      ],
    );
  }
}
