import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_shift_web/common/style.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart' as sfc;

class CustomCalendarShift extends StatelessWidget {
  final sfc.CalendarDataSource<Object?>? dataSource;
  final Function(sfc.CalendarTapDetails)? onTap;

  const CustomCalendarShift({
    required this.dataSource,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return sfc.SfCalendar(
      dataSource: dataSource,
      view: sfc.CalendarView.timelineMonth,
      showNavigationArrow: true,
      showDatePickerButton: true,
      headerDateFormat: 'yyyy年MM月',
      onTap: onTap,
      resourceViewSettings: const sfc.ResourceViewSettings(
        visibleResourceCount: 3,
        showAvatar: false,
        displayNameTextStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      cellBorderColor: kGrey600Color,
    );
  }
}
