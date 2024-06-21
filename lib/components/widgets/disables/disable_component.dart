import 'package:flutter/material.dart';

class DisableWrapper extends StatelessWidget {
  const DisableWrapper(
      {Key? key,
      this.disable = true,
      this.preserveGestures = false,
      this.preserveColor = false,
      @required this.child,
      this.replaceOnTap})
      : super(key: key);

  final bool disable;
  final bool preserveGestures;
  final bool preserveColor;
  final VoidCallback? replaceOnTap;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      excludeFromSemantics: true,
      onTap: !preserveGestures && disable && replaceOnTap != null
          ? replaceOnTap
          : null,
      child: IgnorePointer(
        ignoring: disable && !preserveGestures,
        child: Opacity(
          opacity: preserveColor
              ? 1.0
              : disable
                  ? 0.5
                  : 1.0,
          child: child,
        ),
      ),
    );
  }
}
