import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_shift_web/common/style.dart';

class CustomCheckbox extends StatelessWidget {
  final String label;
  final Color labelColor;
  final Color backgroundColor;
  final bool checked;
  final void Function(bool?) onChanged;

  const CustomCheckbox({
    required this.label,
    this.labelColor = kBlackColor,
    this.backgroundColor = Colors.transparent,
    required this.checked,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: const Border(bottom: BorderSide(color: kGrey300Color)),
        color: backgroundColor,
      ),
      padding: const EdgeInsets.all(8),
      child: Checkbox(
        checked: checked,
        onChanged: onChanged,
        content: Text(
          label,
          style: TextStyle(color: labelColor),
        ),
      ),
    );
  }
}
