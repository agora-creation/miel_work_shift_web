import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_shift_web/common/style.dart';

class CustomDateTimePicker {
  Future picker({
    required BuildContext context,
    required DateTime init,
    required String title,
    required Function(DateTime) onChanged,
  }) async {
    await showBoardDateTimePicker(
      context: context,
      pickerType: DateTimePickerType.datetime,
      initialDate: init,
      minimumDate: kFirstDate,
      maximumDate: kLastDate,
      options: BoardDateTimeOptions(
        languages: const BoardPickerLanguages.ja(),
        showDateButton: false,
        boardTitle: title,
      ),
      radius: 8,
      onChanged: onChanged,
    );
  }
}
