import 'package:flutter/material.dart';

import '../disables/disable_component.dart';

class ButtonPrimary extends StatefulWidget {
  const ButtonPrimary({
    Key? key,
    required this.isActive,
    required this.onPressed,
    required this.width,
    required this.height,
    this.color,
    this.text,
    this.borderRadius,
    this.textStyle,
    this.border,
    this.icon,
    this.gradient,
    this.rightIcon,
    this.onLongPressed,
  }) : super(key: key);

  final bool isActive;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final String? text;
  final Color? color;
  final BorderRadius? borderRadius;
  final TextStyle? textStyle;
  final Border? border;
  final Widget? icon;
  final Gradient? gradient;
  final Widget? rightIcon;
  final VoidCallback? onLongPressed;

  @override
  State<ButtonPrimary> createState() => _ButtonPrimaryState();
}

class _ButtonPrimaryState extends State<ButtonPrimary> {
  @override
  Widget build(BuildContext context) {
    return DisableWrapper(
      disable: !widget.isActive,
      child: InkWell(
        onTap: widget.onPressed,
        onLongPress: widget.onLongPressed,
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(20),
              gradient: widget.gradient,
              color: widget.color ?? const Color(0xFFE18274),
              border: widget.border),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.icon ?? Container(),
                  widget.icon != null
                      ? const SizedBox(
                          width: 10.0,
                        )
                      : Container(),
                  Text(
                    widget.text ?? 'Continuar',
                    textAlign: TextAlign.center,
                    style: widget.textStyle ??
                        const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                  ),
                  widget.rightIcon != null
                      ? const SizedBox(
                          width: 10.0,
                        )
                      : Container(),
                  widget.rightIcon ?? Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
