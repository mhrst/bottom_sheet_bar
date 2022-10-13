import 'package:bottom_sheet_bar/bottom_sheet_bar_listener.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:measure_size/measure_size.dart';

/// A toolbar that aligns to the bottom of a widget and expands into a bottom
/// sheet.
class BottomSheetBar extends StatefulWidget {
  /// The minimum vertical speed (measured in pixels-per-second) required to
  /// collapse or expand the bottom-sheet with a fling gesture
  final double velocityMin;

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
  /// [Theme.of(context).bottomAppBarColor]
  final Color? color;

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
    this.color,
    this.backdropColor = Colors.transparent,
    this.borderRadius,
    this.borderRadiusExpanded,
    this.boxShadows,
    this.height = kToolbarHeight,
    this.isDismissable = true,
    this.locked = true,
    this.velocityMin = 320.0,
    Key? key,
  }) : super(key: key);

  @override
  State<BottomSheetBar> createState() => _BottomSheetBarState();
}

/// A controller used to expand or collapse the bottom sheet of a
/// [BottomSheetBar]. Listeners can be added to respond to expand and collapse
/// events. The expanded or collapsed state can also be determined through this
/// controller.
class BottomSheetBarController {
  AnimationController? _animationController;
  final _listeners = <Function()>[];

  /// Only returns [true] if the bottom sheet is fully collapsed
  bool get isCollapsed => _animationController?.value == 0.0;

  /// Only returns [true] if the bottom sheet is fully expanded
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
  Future? collapse() => _animationController
      ?.fling(velocity: -1.0)
      .then((_) => _animationController?.animateTo(0.0));

  /// Removes all previously added listeners
  void dispose() {
    for (var listener in _listeners) {
      removeListener(listener);
      _animationController?.removeListener(listener);
    }
  }

  /// Expand the bottom sheet built by [BottomSheetBar.expandedBuilder]
  Future? expand() => _animationController
      ?.fling(velocity: 1.0)
      .then((_) => _animationController?.animateTo(1.0));

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

  bool _isScrolled = false;
  Size _expandedSize = Size.zero;

  late AnimationController _animationController;
  late BottomSheetBarController _controller;

  double get _heightDiff => _expandedSize.height - widget.height;

  @override
  Widget build(BuildContext context) => BackButtonListener(
        onBackButtonPressed: () {
          if (_controller.isExpanded) {
            _controller.collapse();
            return Future.value(true);
          }

          return Future.value(false);
        },
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            // Body widget
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
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: widget.backdropColor,
              ),
              builder: (context, child) => IgnorePointer(
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
                    child: child,
                  ),
                ),
              ),
            ),

            /// Collapsed widget
            BottomSheetBarListener(
              locked: widget.locked,
              onEnd: () => _eventEnd(_velocityTracker.getVelocity()),
              onPosition: _velocityTracker.addPosition,
              onScroll: _eventMove,
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) => Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: IgnorePointer(
                        ignoring: !_controller.isCollapsed,
                        child: Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            color: widget.color ??
                                Theme.of(context).bottomAppBarColor,
                            boxShadow: widget.boxShadows,
                            borderRadius: BorderRadius.lerp(
                              widget.borderRadius,
                              widget.borderRadiusExpanded ??
                                  widget.borderRadius,
                              _animationController.value,
                            ),
                          ),
                          child: SafeArea(
                            child: SizedBox(
                              height: _animationController.value * _heightDiff +
                                  widget.height,
                              width: double.infinity,
                              child: FadeTransition(
                                opacity: Tween(begin: 1.0, end: 0.0)
                                    .animate(_animationController),
                                child: widget.collapsed,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    /// Expanded widget
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: IgnorePointer(
                        ignoring: _controller.isCollapsed,
                        child: SafeArea(
                          child: FadeTransition(
                            opacity: Tween(begin: -13.0, end: 1.0)
                                .animate(_animationController),
                            child: MeasureSize(
                              onChange: (size) =>
                                  setState(() => _expandedSize = size),
                              child: widget.expandedBuilder(_scrollController),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
      if (widget.locked || _isScrolled) return;
      _jumpToZero();
    });

    _controller = widget.controller ?? BottomSheetBarController();
    _controller.attach(_animationController);
  }

  void _eventEnd(Velocity velocity) {
    if (_animationController.isAnimating ||
        (_controller.isExpanded && _isScrolled)) {
      return;
    } else if (velocity.pixelsPerSecond.dy.abs() >= widget.velocityMin) {
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
    if (!_isScrolled) {
      _animationController.value -= dy / _heightDiff;
    }

    if (_controller.isExpanded && _scrollController.offset <= 0) {
      setState(() => _isScrolled = dy <= 0);
    } else if (_controller.isCollapsed) {
      _jumpToZero();
      setState(() => _isScrolled = false);
    }
  }

  void _jumpToZero() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }
}
