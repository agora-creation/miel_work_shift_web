import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_shift_web/common/style.dart';

class CustomTextBox extends StatelessWidget {
  final TextEditingController? controller;
  final String? placeholder;
  final TextInputType? keyboardType;
  final int? maxLines;
  final bool? obscureText;
  final Function(String)? onChanged;
  final bool enabled;
  final bool expands;

  const CustomTextBox({
    this.controller,
    this.placeholder,
    this.keyboardType,
    this.maxLines,
    this.obscureText,
    this.onChanged,
    this.enabled = true,
    this.expands = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextBox(
      controller: controller,
      placeholder: placeholder,
      keyboardType: keyboardType,
      expands: expands,
      maxLines: maxLines,
      obscureText: obscureText ?? false,
      onChanged: onChanged,
      enabled: enabled,
      decoration: BoxDecoration(
        color: kGrey100Color,
        border: Border.all(color: kGrey300Color),
      ),
    );
  }
}
