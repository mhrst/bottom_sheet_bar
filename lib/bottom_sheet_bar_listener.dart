import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class BottomSheetBarListener extends StatelessWidget {
  final bool locked;
  final Widget child;
  final void Function(double dy) onScroll;
  final void Function(Duration timestamp, Offset position) onPosition;
  final void Function() onEnd;

  const BottomSheetBarListener({
    Key? key,
    required this.locked,
    required this.child,
    required this.onScroll,
    required this.onPosition,
    required this.onEnd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Listener(
        onPointerSignal: (ps) {
          if (!locked && ps is PointerScrollEvent) {
            onScroll(ps.delta.dy);
          }
        },
        onPointerDown: locked
            ? null
            : (event) => onPosition(event.timeStamp, event.position),
        onPointerMove: locked
            ? null
            : (event) {
                onPosition(event.timeStamp, event.position);
                onScroll(event.delta.dy);
              },
        onPointerUp: locked ? null : (_) => onEnd(),
        onPointerCancel: locked ? null : (_) => onEnd(),
        child: child,
      );
}
