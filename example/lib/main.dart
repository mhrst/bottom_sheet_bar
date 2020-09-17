import 'package:bottom_sheet_bar/bottom_sheet_bar.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(ExampleApp());
}

class BottomSheetBarPage extends StatefulWidget {
  final String title;

  BottomSheetBarPage({Key key, this.title}) : super(key: key);

  @override
  _BottomSheetBarPageState createState() => _BottomSheetBarPageState();
}

class ExampleApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BottomSheetBar Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BottomSheetBarPage(title: 'BottomSheetBar Demo Home Page'),
    );
  }
}

class _BottomSheetBarPageState extends State<BottomSheetBarPage> {
  bool _isLocked = false;
  final _bsbController = BottomSheetBarController();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: BottomSheetBar(
          locked: _isLocked,
          color: Colors.lightBlueAccent,
          controller: _bsbController,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32.0),
            topRight: Radius.circular(32.0),
          ),
          expandedBuilder: _isLocked
              ? (scrollController) => CustomScrollView(
                    shrinkWrap: true,
                    slivers: [
                      SliverToBoxAdapter(
                        child: Container(
                          height: 256.0,
                          child: Text('Locked+Expanded Bottom Sheet'),
                        ),
                      ),
                    ],
                  )
              : (scrollController) => CustomScrollView(
                    shrinkWrap: true,
                    slivers: [
                      SliverToBoxAdapter(
                        child: Container(
                          height: 512.0,
                          child: Text('Expanded Bottom Sheet'),
                        ),
                      ),
                    ],
                  ),
          collapsed: Container(
            height: kToolbarHeight + 12.0,
            child: FlatButton(
              onPressed: () => _bsbController.expand(),
              child: Text('Click to expand'),
            ),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'BottomSheetBar is',
                ),
                Text(
                  _isLocked ? 'Locked' : 'Unlocked',
                  style: Theme.of(context).textTheme.headline4,
                ),
                Text(
                  _isLocked
                      ? 'Bottom sheet cannot be expanded or collapsed by swiping'
                      : 'Swipe it to expand or collapse the bottom sheet',
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _toggleLock,
          tooltip: 'Toggle Lock',
          child: _isLocked ? Icon(Icons.lock) : Icon(Icons.lock_open),
        ),
      );

  void _toggleLock() {
    setState(() {
      _isLocked = !_isLocked;
    });
  }
}
