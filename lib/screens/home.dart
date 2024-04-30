import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_shift_web/providers/home.dart';
import 'package:miel_work_shift_web/providers/login.dart';
import 'package:miel_work_shift_web/screens/plan_shift.dart';
import 'package:miel_work_shift_web/widgets/custom_header.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    final homeProvider = Provider.of<HomeProvider>(context);
    return ScaffoldPage(
      padding: EdgeInsets.zero,
      header: CustomHeader(
        loginProvider: loginProvider,
        homeProvider: homeProvider,
      ),
      content: PlanShiftScreen(
        loginProvider: loginProvider,
        homeProvider: homeProvider,
      ),
    );
  }
}
