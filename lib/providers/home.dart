import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_shift_web/models/organization_group.dart';
import 'package:miel_work_shift_web/services/organization_group.dart';

class HomeProvider with ChangeNotifier {
  final OrganizationGroupService _groupService = OrganizationGroupService();
  List<OrganizationGroupModel> groups = [];
  OrganizationGroupModel? currentGroup;

  void setGroups({
    required String organizationId,
    OrganizationGroupModel? group,
    bool isAllGroup = false,
  }) async {
    groups = await _groupService.selectList(organizationId: organizationId);
    if (isAllGroup) {
      currentGroup = null;
    } else {
      currentGroup = group;
    }
    notifyListeners();
  }

  void currentGroupChange(OrganizationGroupModel? value) {
    currentGroup = value;
    notifyListeners();
  }

  void currentGroupClear() {
    currentGroup = null;
    notifyListeners();
  }
}
