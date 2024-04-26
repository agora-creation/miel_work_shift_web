import 'package:fluent_ui/fluent_ui.dart';

class CustomButtonSm extends StatelessWidget {
  final IconData? icon;
  final String labelText;
  final Color labelColor;
  final Color backgroundColor;
  final Function()? onPressed;

  const CustomButtonSm({
    this.icon,
    required this.labelText,
    required this.labelColor,
    required this.backgroundColor,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: ButtonState.all(backgroundColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: icon != null
            ? Row(
                children: [
                  Icon(
                    icon,
                    color: labelColor,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    labelText,
                    style: TextStyle(
                      color: labelColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              )
            : Text(
                labelText,
                style: TextStyle(
                  color: labelColor,
                  fontSize: 14,
                ),
              ),
      ),
    );
  }
}
