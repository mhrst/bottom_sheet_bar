import 'package:bottom_sheet_bar/bottom_sheet_bar.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ExampleApp());
}

class BottomSheetBarPage extends StatefulWidget {
  final String title;

  const BottomSheetBarPage({Key? key, this.title = ''}) : super(key: key);

  @override
  _BottomSheetBarPageState createState() => _BottomSheetBarPageState();
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BottomSheetBar Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const BottomSheetBarPage(title: 'BottomSheetBar'),
    );
  }
}

class _BottomSheetBarPageState extends State<BottomSheetBarPage> {
  bool _isLocked = false;
  final itemList = List<int>.generate(300, (index) => index * index);
  final _bsbController = BottomSheetBarController();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            if (!_bsbController.isExpanded)
              IconButton(
                icon: Icon(Icons.open_in_full),
                onPressed: _bsbController.expand,
              ),
            if (!_bsbController.isCollapsed)
              IconButton(
                icon: Icon(Icons.close),
                onPressed: _bsbController.collapse,
              ),
          ],
        ),
        body: BottomSheetBar(
          backdropColor: Colors.green,
          locked: _isLocked,
          color: Colors.lightBlueAccent,
          controller: _bsbController,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32.0),
            topRight: Radius.circular(32.0),
          ),
          borderRadiusExpanded: const BorderRadius.only(
            topLeft: Radius.circular(0.0),
            topRight: Radius.circular(0.0),
          ),
          boxShadows: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5.0,
              blurRadius: 32.0,
              offset: const Offset(0, 0), // changes position of shadow
            ),
          ],
          expandedBuilder: (scrollController) => CustomScrollView(
            controller: scrollController,
            shrinkWrap: true,
            slivers: [
              SliverFixedExtentList(
                itemExtent: 56.0, // I'm forcing item heights
                delegate: SliverChildBuilderDelegate(
                  (context, index) => ListTile(
                    title: Text(
                      itemList[index].toString(),
                      style: const TextStyle(fontSize: 20.0),
                    ),
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(
                          itemList[index].toString(),
                        ),
                      ),
                    ),
                  ),
                  childCount: itemList.length,
                ),
              ),
            ],
          ),
          collapsed: TextButton(
            onPressed: () => _bsbController.expand(),
            child: Text('Click${_isLocked ? "" : " or swipe"} to expand'),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('BottomSheetBar is'),
                Text(
                  _isLocked ? 'Locked' : 'Unlocked',
                  style: Theme.of(context).textTheme.headline4,
                ),
                Text(
                  _isLocked
                      ? 'Bottom sheet cannot be expanded or collapsed by swiping'
                      : 'Swipe it to expand or collapse the bottom sheet',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _toggleLock,
          tooltip: 'Toggle Lock',
          child:
              _isLocked ? const Icon(Icons.lock) : const Icon(Icons.lock_open),
        ),
      );

  void _toggleLock() {
    setState(() {
      _isLocked = !_isLocked;
    });
  }
}
