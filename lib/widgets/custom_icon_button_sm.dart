import 'package:fluent_ui/fluent_ui.dart';

class CustomIconButtonSm extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final Function()? onPressed;

  const CustomIconButtonSm({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        icon,
        color: iconColor,
      ),
      style: ButtonStyle(
        backgroundColor: ButtonState.all(backgroundColor),
        padding: ButtonState.all(const EdgeInsets.all(12)),
      ),
      onPressed: onPressed,
    );
  }
}
