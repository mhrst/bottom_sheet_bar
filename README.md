# bottom_sheet_bar

```dart
import 'package:bottom_sheet_bar/bottom_sheet_bar.dart';

BottomSheetBar(
    expandedBuilder: (scrollController) => ListView.builder(
        controller: scrollController, 
        itemBuilder: (context, index) => ListTile(title: index.toString()),
        itemCount: 50,
    ),
    collapsed: Text('Collapsed toolbar widget'),
    body: Text('Content overlayed by toolbar and bottom sheet'),
);
```

## `BottomSheetBar` constructor parameters

#### __Required__
- `Widget body`
- `Function(ScrollController) expandedBuilder`

#### Optional
- `Widget collapsed`
- `BottomSheetBarController controller`
- `Color color` default: __Colors.white__
- `Color backdropColor` default: __Colors.transparent__
- `BorderRadius borderRadius`
- `double height` default: __kToolbarHeight__
- `bool isDismissable` default: __true__
- `bool locked` default: __true__
- `Key key`

## `BottomSheetBarController`

A `BottomSheetBarController` can be used to expand and collapse the bottom sheet programatically, listen for changes, and query the current state of the `BottomSheetBar`

- `bool get isCollapsed` - Returns true if bottom sheet is fully collapsed
- `bool get isExpanded` - Returns true if bottom sheet is fully expanded
- `TickerFuture collapse()` - Collapse the bottom sheet widget defined by `expandedBuilder`
- `TickerFuture expand()` - Expand the bottom sheet widget defined by `expandedBuilder`
- `void addListener(Function listener)` - Add a listener that is called on every frame of animation
- `void removeListener(Function listener)` - Removes a previously added listener
- `void dispose()`

#### Advanced
- `void attach(AnimationController animationController)` - Used internally to assign the `AnimationController` created by `BottomSheetBar` to the controller. Unless you're using advanced animation techniques, you probably won't ever need to use this method.

## Example

A quick demonstration can be found in the `example` directory. To run the example:

`flutter run example/main.dart`