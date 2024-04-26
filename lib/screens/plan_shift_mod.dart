import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_shift_web/common/custom_date_time_picker.dart';
import 'package:miel_work_shift_web/common/functions.dart';
import 'package:miel_work_shift_web/common/style.dart';
import 'package:miel_work_shift_web/models/organization_group.dart';
import 'package:miel_work_shift_web/models/plan_shift.dart';
import 'package:miel_work_shift_web/models/user.dart';
import 'package:miel_work_shift_web/providers/home.dart';
import 'package:miel_work_shift_web/providers/login.dart';
import 'package:miel_work_shift_web/providers/plan_shift.dart';
import 'package:miel_work_shift_web/services/plan_shift.dart';
import 'package:miel_work_shift_web/services/user.dart';
import 'package:miel_work_shift_web/widgets/custom_button_sm.dart';
import 'package:miel_work_shift_web/widgets/custom_checkbox.dart';
import 'package:miel_work_shift_web/widgets/datetime_range_form.dart';
import 'package:miel_work_shift_web/widgets/link_text.dart';
import 'package:miel_work_shift_web/widgets/repeat_select_form.dart';
import 'package:provider/provider.dart';

class PlanShiftModScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final String planShiftId;

  const PlanShiftModScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.planShiftId,
    super.key,
  });

  @override
  State<PlanShiftModScreen> createState() => _PlanShiftModScreenState();
}

class _PlanShiftModScreenState extends State<PlanShiftModScreen> {
  PlanShiftService planShiftService = PlanShiftService();
  UserService userService = UserService();
  OrganizationGroupModel? selectedGroup;
  List<UserModel> users = [];
  List<String> selectedUserIds = [];
  DateTime startedAt = DateTime.now();
  DateTime endedAt = DateTime.now();
  bool allDay = false;
  bool repeat = false;
  String repeatInterval = kRepeatIntervals.first;
  TextEditingController repeatEveryController = TextEditingController(
    text: '1',
  );
  List<String> repeatWeeks = [];
  int alertMinute = 0;

  void _init() async {
    PlanShiftModel? planShift = await planShiftService.selectData(
      id: widget.planShiftId,
    );
    if (planShift == null) {
      if (!mounted) return;
      showMessage(context, '勤務予定データの取得に失敗しました', false);
      Navigator.of(context, rootNavigator: true).pop();
      return;
    }
    for (OrganizationGroupModel group in widget.homeProvider.groups) {
      if (group.id == planShift.groupId) {
        selectedGroup = group;
      }
    }
    _groupChange(selectedGroup);
    selectedUserIds = planShift.userIds;
    startedAt = planShift.startedAt;
    endedAt = planShift.endedAt;
    allDay = planShift.allDay;
    repeat = planShift.repeat;
    repeatInterval = planShift.repeatInterval;
    repeatEveryController.text = planShift.repeatEvery.toString();
    repeatWeeks = planShift.repeatWeeks;
    alertMinute = planShift.alertMinute;
    setState(() {});
  }

  void _groupChange(OrganizationGroupModel? value) async {
    selectedGroup = value;
    if (selectedGroup != null) {
      users = await userService.selectList(
        userIds: selectedGroup?.userIds ?? [],
      );
    } else {
      users = await userService.selectList(
        userIds: widget.loginProvider.organization?.userIds ?? [],
      );
    }
    setState(() {});
  }

  void _allDayChange(bool? value) {
    allDay = value ?? false;
    if (allDay) {
      startedAt = DateTime(
        startedAt.year,
        startedAt.month,
        startedAt.day,
        0,
        0,
        0,
      );
      endedAt = DateTime(
        endedAt.year,
        endedAt.month,
        endedAt.day,
        23,
        59,
        59,
      );
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    final planShiftProvider = Provider.of<PlanShiftProvider>(context);
    List<ComboBoxItem<OrganizationGroupModel>> groupItems = [];
    if (widget.homeProvider.groups.isNotEmpty) {
      groupItems.add(const ComboBoxItem(
        value: null,
        child: Text(
          'グループの指定なし',
          style: TextStyle(color: kGreyColor),
        ),
      ));
      for (OrganizationGroupModel group in widget.homeProvider.groups) {
        groupItems.add(ComboBoxItem(
          value: group,
          child: Text(group.name),
        ));
      }
    }
    return ScaffoldPage(
      padding: EdgeInsets.zero,
      header: Container(
        decoration: kHeaderDecoration,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(FluentIcons.chevron_left),
                onPressed: () => Navigator.pop(context),
              ),
              const Text(
                '勤務予定を編集',
                style: TextStyle(fontSize: 16),
              ),
              CustomButtonSm(
                labelText: '入力内容を保存',
                labelColor: kWhiteColor,
                backgroundColor: kBlueColor,
                onPressed: () async {
                  String? error = await planShiftProvider.update(
                    planShiftId: widget.planShiftId,
                    organization: widget.loginProvider.organization,
                    group: selectedGroup,
                    userIds: selectedUserIds,
                    startedAt: startedAt,
                    endedAt: endedAt,
                    allDay: allDay,
                    repeat: repeat,
                    repeatInterval: repeatInterval,
                    repeatEvery: int.parse(repeatEveryController.text),
                    repeatWeeks: repeatWeeks,
                    alertMinute: alertMinute,
                  );
                  if (error != null) {
                    if (!mounted) return;
                    showMessage(context, error, false);
                    return;
                  }
                  if (!mounted) return;
                  showMessage(context, '勤務予定を編集しました', true);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
      content: Container(
        color: kWhiteColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 200,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InfoLabel(
                  label: '働くスタッフを選択',
                  child: Column(
                    children: [
                      ComboBox<OrganizationGroupModel>(
                        isExpanded: true,
                        value: selectedGroup,
                        items: groupItems,
                        onChanged: (value) {
                          selectedUserIds.clear();
                          _groupChange(value);
                        },
                        placeholder: const Text(
                          'グループの指定なし',
                          style: TextStyle(color: kGreyColor),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: kGrey300Color),
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            UserModel user = users[index];
                            return CustomCheckbox(
                              label: user.name,
                              checked: selectedUserIds.contains(user.id),
                              onChanged: (value) {
                                if (selectedUserIds.contains(user.id)) {
                                  selectedUserIds.remove(user.id);
                                } else {
                                  selectedUserIds.add(user.id);
                                }
                                setState(() {});
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                InfoLabel(
                  label: '働く時間帯を設定',
                  child: DatetimeRangeForm(
                    startedAt: startedAt,
                    startedOnTap: () async =>
                        await CustomDateTimePicker().picker(
                      context: context,
                      init: startedAt,
                      title: '勤務予定開始日時を選択',
                      onChanged: (value) {
                        setState(() {
                          startedAt = value;
                          endedAt = startedAt.add(const Duration(hours: 8));
                        });
                      },
                    ),
                    endedAt: endedAt,
                    endedOnTap: () async => await CustomDateTimePicker().picker(
                      context: context,
                      init: endedAt,
                      title: '勤務予定終了日時を選択',
                      onChanged: (value) {
                        setState(() {
                          endedAt = value;
                        });
                      },
                    ),
                    allDay: allDay,
                    allDayOnChanged: _allDayChange,
                  ),
                ),
                const SizedBox(height: 8),
                InfoLabel(
                  label: '繰り返し設定',
                  child: RepeatSelectForm(
                    repeat: repeat,
                    repeatOnChanged: (value) {
                      setState(() {
                        repeat = value!;
                      });
                    },
                    interval: repeatInterval,
                    intervalOnChanged: (value) {
                      setState(() {
                        repeatInterval = value;
                      });
                    },
                    everyController: repeatEveryController,
                    weeks: repeatWeeks,
                    weeksOnChanged: (value) {
                      if (repeatWeeks.contains(value)) {
                        repeatWeeks.remove(value);
                      } else {
                        repeatWeeks.add(value);
                      }
                      setState(() {});
                    },
                  ),
                ),
                const SizedBox(height: 8),
                InfoLabel(
                  label: '事前アラート通知',
                  child: ComboBox<int>(
                    isExpanded: true,
                    value: alertMinute,
                    items: kAlertMinutes.map((value) {
                      return ComboBoxItem(
                        value: value,
                        child: value == 0 ? const Text('無効') : Text('$value分前'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        alertMinute = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                LinkText(
                  label: 'この勤務予定を削除',
                  color: kRedColor,
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => DelPlanShiftDialog(
                      loginProvider: widget.loginProvider,
                      homeProvider: widget.homeProvider,
                      planShiftId: widget.planShiftId,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DelPlanShiftDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final String planShiftId;

  const DelPlanShiftDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.planShiftId,
    super.key,
  });

  @override
  State<DelPlanShiftDialog> createState() => _DelPlanShiftDialogState();
}

class _DelPlanShiftDialogState extends State<DelPlanShiftDialog> {
  @override
  Widget build(BuildContext context) {
    final planShiftProvider = Provider.of<PlanShiftProvider>(context);
    return ContentDialog(
      title: const Text(
        '勤務予定を削除',
        style: TextStyle(fontSize: 18),
      ),
      content: const SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Text('本当に削除しますか？')),
          ],
        ),
      ),
      actions: [
        CustomButtonSm(
          labelText: 'キャンセル',
          labelColor: kWhiteColor,
          backgroundColor: kGreyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButtonSm(
          labelText: '削除する',
          labelColor: kWhiteColor,
          backgroundColor: kRedColor,
          onPressed: () async {
            String? error = await planShiftProvider.delete(
              planShiftId: widget.planShiftId,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, '勤務予定を削除しました', true);
            Navigator.pop(context);
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
      ],
    );
  }
}
