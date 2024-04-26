import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_shift_web/common/style.dart';
import 'package:miel_work_shift_web/models/organization_group.dart';
import 'package:miel_work_shift_web/providers/home.dart';
import 'package:miel_work_shift_web/providers/login.dart';
import 'package:miel_work_shift_web/screens/login.dart';
import 'package:miel_work_shift_web/widgets/custom_button_sm.dart';

class CustomHeader extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const CustomHeader({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<CustomHeader> createState() => _CustomHeaderState();
}

class _CustomHeaderState extends State<CustomHeader> {
  @override
  void initState() {
    super.initState();
    widget.homeProvider.setGroups(
      organizationId: widget.loginProvider.organization?.id ?? 'error',
    );
  }

  @override
  Widget build(BuildContext context) {
    String organizationName = widget.loginProvider.organization?.name ?? '';
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
    return Container(
      color: kWhiteColor,
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                organizationName,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 8),
              Row(
                children: [
                  ComboBox<OrganizationGroupModel>(
                    value: widget.homeProvider.currentGroup,
                    items: groupItems,
                    onChanged: (value) {
                      widget.homeProvider.currentGroupChange(value);
                    },
                    placeholder: const Text(
                      'グループの指定なし',
                      style: TextStyle(color: kGreyColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              const Text(
                'シフト表専用画面',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          Row(
            children: [
              CustomButtonSm(
                icon: FluentIcons.password_field,
                labelText: 'パスワード変更',
                labelColor: kWhiteColor,
                backgroundColor: kGreyColor,
                onPressed: () {},
              ),
              const SizedBox(width: 4),
              CustomButtonSm(
                icon: FluentIcons.sign_out,
                labelText: 'ログイン中',
                labelColor: kWhiteColor,
                backgroundColor: kGreyColor,
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => LogoutDialog(
                    loginProvider: widget.loginProvider,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LogoutDialog extends StatefulWidget {
  final LoginProvider loginProvider;

  const LogoutDialog({
    required this.loginProvider,
    super.key,
  });

  @override
  State<LogoutDialog> createState() => _LogoutDialogState();
}

class _LogoutDialogState extends State<LogoutDialog> {
  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text(
        'ログアウト',
        style: TextStyle(fontSize: 18),
      ),
      content: const SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('本当にログアウトしますか？'),
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
          labelText: 'ログアウト',
          labelColor: kWhiteColor,
          backgroundColor: kRedColor,
          onPressed: () async {
            await widget.loginProvider.logout();
            if (!mounted) return;
            Navigator.pushReplacement(
              context,
              FluentPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          },
        ),
      ],
    );
  }
}
