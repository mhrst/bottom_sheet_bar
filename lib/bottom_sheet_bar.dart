import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

const VELOCITY_MIN = 320.0;

class BottomSheetBar extends StatefulWidget {
  final Widget body;
  final Widget Function(ScrollController) expandedBuilder;
  final Widget collapsed;

  final BottomSheetBarController controller;

  final Color color;
  final Color backdropColor;

  final BorderRadiusGeometry borderRadius;

  final bool isDismissable;
  final bool locked;

  BottomSheetBar(
      {@required this.body,
      @required this.expandedBuilder,
      this.collapsed,
      this.controller,
      this.color = Colors.white,
      this.backdropColor = Colors.transparent,
      this.borderRadius,
      this.isDismissable = true,
      this.locked = true,
      Key key})
      : assert(body != null),
        assert(expandedBuilder != null),
        super(key: key);

  @override
  _BottomSheetBarState createState() => _BottomSheetBarState();
}

class BottomSheetBarController {
  AnimationController _animationController;
  final _listeners = <Function>[];

  bool get isCollapsed => _animationController?.value == 0.0;

  bool get isExpanded => _animationController?.value == 1.0;

  void addListener(Function listener) => _listeners.add(listener);

  void attach(AnimationController animationController) {
    _animationController?.removeListener(_listener);
    _animationController = animationController;
    _animationController?.addListener(_listener);
  }

  TickerFuture collapse() => _animationController?.fling(velocity: -1.0);

  void dispose() {
    _animationController?.removeListener(_listener);
  }

  TickerFuture expand() => _animationController?.fling(velocity: 1.0);

  void removeListener(Function listener) => _listeners.remove(listener);

  void _listener() => _listeners.forEach((f) => f?.call());
}

class _BottomSheetBarState extends State<BottomSheetBar>
    with SingleTickerProviderStateMixin {
  final _keyCollapsed = GlobalKey();
  final _keyExpanded = GlobalKey();
  final _scrollController = ScrollController();
  final _velocityTracker = VelocityTracker(PointerDeviceKind.touch);

  AnimationController _animationController;
  BottomSheetBarController _controller;
  bool _isScrollable = false;

  double _expandedHeight = 0;
  double _collapsedHeight = 0;

  double get _heightDiff => _expandedHeight - _collapsedHeight;

  @override
  Widget build(BuildContext context) => Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          // Body
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) => Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: widget.body,
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
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: widget.backdropColor.withOpacity(
                      _animationController.value *
                          widget.backdropColor.opacity),
                ),
              ),
            ),
          ),

          // Bottom Sheet Bar
          Listener(
            onPointerDown: widget.locked
                ? null
                : (event) => _velocityTracker.addPosition(
                    event.timeStamp, event.position),
            onPointerMove: widget.locked
                ? null
                : (event) {
                    _velocityTracker.addPosition(
                        event.timeStamp, event.position);
                    _eventMove(event.delta.dy);
                  },
            onPointerUp: widget.locked
                ? null
                : (_) => _eventEnd(_velocityTracker.getVelocity()),
            onPointerCancel: widget.locked
                ? null
                : (_) => _eventEnd(_velocityTracker.getVelocity()),
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) => Material(
                color: widget.color,
                borderRadius: widget.borderRadius,
                elevation: 0,
                child: SafeArea(
                  child: Ink(
                    height: _expandedHeight == 0 && _collapsedHeight == 0
                        ? double.infinity
                        : _animationController.value * _heightDiff +
                            _collapsedHeight,
                    child: Stack(
                      children: [
                        if (widget.collapsed != null)
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: FadeTransition(
                              opacity: Tween(begin: 1.0, end: 0.0)
                                  .animate(_animationController),
                              child: IgnorePointer(
                                ignoring: !_controller.isCollapsed,
                                child: Container(
                                  key: _keyCollapsed,
                                  child: widget.collapsed,
                                ),
                              ),
                            ),
                          ),
                        if (widget.expandedBuilder != null)
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: FadeTransition(
                              opacity: Tween(begin: 0.0, end: 1.0)
                                  .animate(_animationController),
                              child: IgnorePointer(
                                ignoring: _controller.isCollapsed,
                                child: Container(
                                  key: _keyExpanded,
                                  child:
                                      widget.expandedBuilder(_scrollController),
                                ),
                              ),
                            ),
                          ),
                      ],
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
    WidgetsBinding.instance.addPostFrameCallback(_setHeights);
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
      value: 0.0,
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
    } else if (velocity.pixelsPerSecond.dy.abs() >= VELOCITY_MIN) {
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
      setState(() => _isScrollable = dy < 0);
    }
  }

  void _setHeights(_) {
    final RenderBox collapsedBox =
        _keyCollapsed.currentContext.findRenderObject();
    setState(() => _collapsedHeight = collapsedBox.size.height);

    final RenderBox exapndedBox =
        _keyExpanded.currentContext.findRenderObject();
    setState(() => _expandedHeight = exapndedBox.size.height);
  }
}
