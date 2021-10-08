import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:measure_size/measure_size.dart';

const kVelocityMin = 320.0;

/// A toolbar that aligns to the bottom of a widget and expands into a bottom
/// sheet.
class BottomSheetBar extends StatefulWidget {
  /// The toolbar will be aligned to the bottom of the body [Widget]. Padding
  /// equal to [height] is added to the bottom of this widget.
  final Widget body;

  /// A function to build the widget displayed when the bottom sheet is
  /// expanded. If the expanded content is scrollable, pass the provided
  /// [ScrollController] to the scrollable widget.
  final Widget Function(ScrollController) expandedBuilder;

  /// A [Widget] to be displayed on the toolbar in its collapsed state. When
  /// null, the toolbar will be empty.
  final Widget? collapsed;

  /// The height of the collapsed toolbar. Defaults to [kToolbarHeight] (56.0)
  final double height;

  /// A controller can be used to listen to events, and expand and collapse the
  /// bottom sheet.
  final BottomSheetBarController? controller;

  /// The background color of the toolbar and bottom sheet. Defaults to
  /// [Colors.white]
  final Color color;

  /// The backdrop color that overlays the [body] widget when the bottom sheet
  /// is expanded. Defaults to [Colors.transparent] (no backdrop)
  final Color backdropColor;

  /// Provide a border-radius to adjust the shape of the toolbar
  final BorderRadius? borderRadius;

  /// Provide a border-radius to adjust the shape of the bottom-sheet
  /// when expanded
  final BorderRadius? borderRadiusExpanded;

  /// Provide a box-shadow list to add to [Ink] widget
  final List<BoxShadow>? boxShadows;

  /// If [true], the bottom sheet can be dismissed by tapping elsewhere. Defaults
  /// to [true]
  final bool isDismissable;

  /// If [true], the bottom sheet cannot be opened or closed with a swipe gesture.
  /// Defaults to [true]
  final bool locked;

  const BottomSheetBar({
    required this.body,
    required this.expandedBuilder,
    this.collapsed,
    this.controller,
    this.color = Colors.white,
    this.backdropColor = Colors.transparent,
    this.borderRadius,
    this.borderRadiusExpanded,
    this.boxShadows,
    this.height = kToolbarHeight,
    this.isDismissable = true,
    this.locked = true,
    Key? key,
  }) : super(key: key);

  @override
  _BottomSheetBarState createState() => _BottomSheetBarState();
}

/// A controller used to expand or collapse the bottom sheet of a
/// [BottomSheetBar]. Listeners can be added to respond to expand and collapse
/// events. The expanded or collapsed state can also be determined through this
/// controller.
class BottomSheetBarController {
  AnimationController? _animationController;
  final _listeners = <Function()>[];

  /// Only returns [true] if the bottom sheet if fully collapsed
  bool get isCollapsed => _animationController?.value == 0.0;

  /// Only returns [true] if the bottom sheet if fully expanded
  bool get isExpanded => _animationController?.value == 1.0;

  /// Adds a function to be called on every animation frame
  void addListener(Function() listener) => _listeners.add(listener);

  /// Used internally to assign the [AnimationController] created by a
  /// [BottomSheetBar] to this controller. Unless you're using advanced
  /// animation techniques, you probably won't ever need to use this method.
  void attach(AnimationController animationController) {
    _animationController?.removeListener(_listener);
    _animationController = animationController;
    _animationController?.addListener(_listener);
  }

  /// Collapse the bottom sheet built by [BottomSheetBar.expandedBuilder]
  TickerFuture? collapse() => _animationController?.fling(velocity: -1.0);

  /// Removes all previously added listeners
  void dispose() {
    for (var listener in _listeners) {
      removeListener(listener);
      _animationController?.removeListener(listener);
    }
  }

  /// Expand the bottom sheet built by [BottomSheetBar.expandedBuilder]
  TickerFuture? expand() => _animationController?.fling(velocity: 1.0);

  /// Remove a previously added listener
  void removeListener(Function listener) => _listeners.remove(listener);

  void _listener() {
    for (var listener in _listeners) {
      listener.call();
    }
  }
}

class _BottomSheetBarState extends State<BottomSheetBar>
    with SingleTickerProviderStateMixin {
  final _scrollController = ScrollController();
  final _velocityTracker = VelocityTracker.withKind(PointerDeviceKind.unknown);

  bool _isScrollable = false;
  Size _expandedSize = Size.zero;

  late AnimationController _animationController;
  late BottomSheetBarController _controller;

  double get _heightDiff => _expandedSize.height - widget.height;

  @override
  Widget build(BuildContext context) => Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          // Body
          Positioned.fill(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(bottom: widget.height),
                child: widget.body,
              ),
            ),
          ),

          // Backdrop
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, _) => IgnorePointer(
              ignoring: !widget.isDismissable || _controller.isCollapsed,
              child: GestureDetector(
                onVerticalDragEnd: (DragEndDetails details) {
                  if (details.velocity.pixelsPerSecond.dy > 0) {
                    _controller.collapse();
                  }
                },
                onTap: _controller.collapse,
                child: FadeTransition(
                  opacity: _animationController,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: widget.backdropColor,
                  ),
                ),
              ),
            ),
          ),

          // Bottom Sheet Bar
          _listenerWrap(
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) => IgnorePointer(
                ignoring: !_controller.isCollapsed,
                child: AnimatedContainer(
                  clipBehavior: Clip.hardEdge,
                  duration: Duration.zero,
                  decoration: BoxDecoration(
                    boxShadow: widget.boxShadows,
                    borderRadius: BorderRadius.lerp(
                      widget.borderRadius,
                      widget.borderRadiusExpanded ?? widget.borderRadius,
                      _animationController.value,
                    ),
                  ),
                  height:
                      _animationController.value * _heightDiff + widget.height,
                  width: double.infinity,
                  child: Material(
                    color: widget.color,
                    child: SafeArea(
                      child: FadeTransition(
                        opacity: Tween(begin: 1.0, end: 0.0)
                            .animate(_animationController),
                        child: child,
                      ),
                    ),
                  ),
                ),
              ),
              child: widget.collapsed,
            ),
          ),

          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) => IgnorePointer(
              ignoring: _controller.isCollapsed,
              child: SafeArea(
                child: FadeTransition(
                  opacity: Tween(begin: -13.0, end: 1.0)
                      .animate(_animationController),
                  child: _listenerWrap(
                    MeasureSize(
                      onChange: (size) => setState(() => _expandedSize = size),
                      child: widget.expandedBuilder(_scrollController),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _scrollController.addListener(() {
      if (widget.locked || _isScrollable) return;
      _scrollController.jumpTo(0);
    });

    _controller = widget.controller ?? BottomSheetBarController();
    _controller.attach(_animationController);
  }

  void _eventEnd(Velocity velocity) {
    if (_animationController.isAnimating ||
        (_controller.isExpanded && _isScrollable)) {
      return;
    } else if (velocity.pixelsPerSecond.dy.abs() >= kVelocityMin) {
      _animationController.fling(
        velocity: -1 * (velocity.pixelsPerSecond.dy / _heightDiff),
      );
    } else if ((1 - _animationController.value) > _animationController.value) {
      _controller.collapse();
    } else {
      _controller.expand();
    }
  }

  void _eventMove(double dy) {
    if (!_isScrollable) {
      _animationController.value -= dy / _heightDiff;
    }

    if (_controller.isExpanded &&
        _scrollController.hasClients &&
        _scrollController.offset <= 0) {
      setState(() => _isScrollable = dy <= 0);
    }
  }

  Listener _listenerWrap(Widget child) => Listener(
        onPointerSignal: widget.locked
            ? null
            : (ps) {
                if (ps is PointerScrollEvent) {
                  _eventMove(ps.delta.dy);
                }
              },
        onPointerDown: widget.locked
            ? null
            : (event) =>
                _velocityTracker.addPosition(event.timeStamp, event.position),
        onPointerMove: widget.locked
            ? null
            : (event) {
                _velocityTracker.addPosition(event.timeStamp, event.position);
                _eventMove(event.delta.dy);
              },
        onPointerUp: widget.locked
            ? null
            : (_) => _eventEnd(_velocityTracker.getVelocity()),
        onPointerCancel: widget.locked
            ? null
            : (_) => _eventEnd(_velocityTracker.getVelocity()),
        child: child,
      );
}
