import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_shift_web/common/functions.dart';
import 'package:miel_work_shift_web/common/style.dart';

class CustomDateBox extends StatelessWidget {
  final DateTime? value;
  final Function()? onTap;

  const CustomDateBox({
    this.value,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String text = '';
    if (value != null) {
      text = dateText('yyyy/MM/dd', value);
    }
    return TextBox(
      controller: TextEditingController(text: text),
      placeholder: '年/月/日',
      suffix: const Padding(
        padding: EdgeInsets.all(8),
        child: Icon(
          FluentIcons.calendar,
          color: kGreyColor,
        ),
      ),
      readOnly: true,
      onTap: onTap,
    );
  }
}
