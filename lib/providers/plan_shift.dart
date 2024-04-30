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
          //更新
          //登録
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
