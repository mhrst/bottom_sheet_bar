import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Creates a [Listener] to track swipe gestures used to expand or collapse
/// a [BottomSheetBar]
///
/// - Tracks scolling and vertical-pan gestures
/// - Can be [locked] to stop listening to gestures
///
/// There's nothing specific to [BottomSheetBar] in here. This widget just
/// exposes a version of a [Listener] widget that is easier to use and read.
class BottomSheetBarListener extends StatelessWidget {
  final Widget child;

  /// Disables bottom-sheet from being expanded or collapsed with a swipe
  final bool locked;

  /// Triggered on [Listener.onPointerMove] and [Listener.onPointerSignal] (when
  ///  the [PointerSignalEvent] is a [PointerScrollEvent])
  final void Function(double dy) onScroll;

  /// Triggered on [Listener.onPointerDown] and [Listener.onPointerMove]
  final void Function(Duration timestamp, Offset position) onPosition;

  /// Trigger on [Listener.onPointerUp] and [Listener.onPointerCancel]
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
