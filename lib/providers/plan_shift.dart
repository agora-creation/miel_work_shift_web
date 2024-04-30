import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_shift_web/models/organization.dart';
import 'package:miel_work_shift_web/models/organization_group.dart';
import 'package:miel_work_shift_web/models/plan_shift.dart';
import 'package:miel_work_shift_web/services/plan_shift.dart';

class PlanShiftProvider with ChangeNotifier {
  final PlanShiftService _planShiftService = PlanShiftService();

  Future<String?> create({
    required OrganizationModel? organization,
    required OrganizationGroupModel? group,
    required List<String> userIds,
    required DateTime startedAt,
    required DateTime endedAt,
    required bool allDay,
    required bool repeat,
    required String repeatInterval,
    required List<String> repeatWeeks,
    required int alertMinute,
  }) async {
    String? error;
    if (organization == null) return '勤務予定の追加に失敗しました';
    if (userIds.isEmpty) return '勤務予定の追加に失敗しました';
    if (startedAt.millisecondsSinceEpoch > endedAt.millisecondsSinceEpoch) {
      return '日時を正しく選択してください';
    }
    try {
      for (String userId in userIds) {
        String id = _planShiftService.id();
        _planShiftService.create({
          'id': id,
          'organizationId': organization.id,
          'groupId': group?.id ?? '',
          'userId': userId,
          'startedAt': startedAt,
          'endedAt': endedAt,
          'allDay': allDay,
          'repeat': repeat,
          'repeatInterval': repeatInterval,
          'repeatEvery': 1,
          'repeatWeeks': repeatWeeks,
          'repeatUntil': null,
          'alertMinute': alertMinute,
          'alertedAt': startedAt.subtract(Duration(minutes: alertMinute)),
          'createdAt': DateTime.now(),
          'expirationAt': startedAt.add(const Duration(days: 365)),
        });
      }
    } catch (e) {
      error = '勤務予定の追加に失敗しました';
    }
    return error;
  }

  Future<String?> update({
    required String planShiftId,
    required DateTime startedAt,
    required DateTime endedAt,
    required bool allDay,
    required bool repeat,
    required String repeatInterval,
    required List<String> repeatWeeks,
    required int alertMinute,
  }) async {
    String? error;
    if (startedAt.millisecondsSinceEpoch > endedAt.millisecondsSinceEpoch) {
      return '日時を正しく選択してください';
    }
    try {
      _planShiftService.update({
        'id': planShiftId,
        'startedAt': startedAt,
        'endedAt': endedAt,
        'allDay': allDay,
        'repeat': repeat,
        'repeatInterval': repeatInterval,
        'repeatEvery': 1,
        'repeatWeeks': repeatWeeks,
        'repeatUntil': null,
        'alertMinute': alertMinute,
        'alertedAt': startedAt.subtract(Duration(minutes: alertMinute)),
        'expirationAt': startedAt.add(const Duration(days: 365)),
      });
    } catch (e) {
      error = '勤務予定の編集に失敗しました';
    }
    return error;
  }

  Future<String?> delete({
    required PlanShiftModel? planShift,
    required bool isAllDelete,
    required DateTime date,
  }) async {
    String? error;
    if (planShift == null) return '勤務予定の削除に失敗しました';
    try {
      if (planShift.repeat) {
        if (isAllDelete) {
          _planShiftService.delete({
            'id': planShift.id,
          });
        } else {
          //一旦区切り更新
          DateTime repeatUntil = DateTime(
            date.year,
            date.month,
            date.day,
            23,
            59,
            59,
          ).subtract(const Duration(days: 1));
          _planShiftService.update({
            'id': planShift.id,
            'repeatUntil': repeatUntil,
          });
          //一旦区切り登録
          String id = _planShiftService.id();
          DateTime startedAt = DateTime(
            date.year,
            date.month,
            date.day,
            planShift.startedAt.hour,
            planShift.startedAt.minute,
            planShift.startedAt.second,
          ).add(const Duration(days: 1));
          DateTime endedAt = DateTime(
            date.year,
            date.month,
            date.day,
            planShift.endedAt.hour,
            planShift.endedAt.minute,
            planShift.endedAt.second,
          ).add(const Duration(days: 1));
          _planShiftService.create({
            'id': id,
            'organizationId': planShift.organizationId,
            'groupId': planShift.groupId,
            'userId': planShift.userId,
            'startedAt': startedAt,
            'endedAt': endedAt,
            'allDay': planShift.allDay,
            'repeat': planShift.repeat,
            'repeatInterval': planShift.repeatInterval,
            'repeatEvery': planShift.repeatEvery,
            'repeatWeeks': planShift.repeatWeeks,
            'repeatUntil': null,
            'alertMinute': planShift.alertMinute,
            'alertedAt': startedAt.subtract(
              Duration(minutes: planShift.alertMinute),
            ),
            'createdAt': planShift.createdAt,
            'expirationAt': planShift.expirationAt,
          });
        }
      } else {
        _planShiftService.delete({
          'id': planShift.id,
        });
      }
    } catch (e) {
      error = '勤務予定の削除に失敗しました';
    }
    return error;
  }
}
