// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:multitext/chunk_list/chunk_text_editing_controller.dart';
// import 'package:multitext/multitext.dart';

// const line0 = 'Line 0 lorem ipsum';
// const line1 = 'Line 1 lorem ipsum';
// const line2 = 'Line 2 lorem ipsum';
// const lineNew = 'Line NEW lorem ipsum';

// const controllerTextLine1 = '$kInvisibleCharacter$line1';
// const controllerTextLine2 = '$kInvisibleCharacter$line2';
// const controllerTextLineNew = '$kInvisibleCharacter$lineNew';

// final testContent = [
//   line0,
//   line1,
//   line2,
// ].join('\n');

// /// Build our app and trigger a frame.
// Future<void> testPlainText(WidgetTester tester) =>
//     tester.pumpWidget(MaterialApp(
//       home: Scaffold(
//         body: MultiTextScrollView(
//             showSelectionSlider: true,
//             controller: MultiTextController(
//               testContent,
//               markdownEnabled: false,
//             )),
//       ),
//     ));

// // Returns the first RenderEditable.
// RenderEditable findRenderEditable(WidgetTester tester) {
//   final RenderObject root =
//       tester.renderObject(find.byType(EditableText).first);
//   expect(root, isNotNull);

//   late RenderEditable renderEditable;
//   void recursiveFinder(RenderObject child) {
//     if (child is RenderEditable) {
//       renderEditable = child;
//       return;
//     }
//     child.visitChildren(recursiveFinder);
//   }

//   root.visitChildren(recursiveFinder);
//   expect(renderEditable, isNotNull);
//   return renderEditable;
// }

// List<TextSelectionPoint> globalize(
//     Iterable<TextSelectionPoint> points, RenderBox box) {
//   return points.map<TextSelectionPoint>((TextSelectionPoint point) {
//     return TextSelectionPoint(
//       box.localToGlobal(point.point),
//       point.direction,
//     );
//   }).toList();
// }

// Offset textOffsetToPosition(WidgetTester tester, int offset) {
//   final RenderEditable renderEditable = findRenderEditable(tester);
//   final List<TextSelectionPoint> endpoints = globalize(
//     renderEditable.getEndpointsForSelection(
//       TextSelection.collapsed(offset: offset),
//     ),
//     renderEditable,
//   );
//   expect(endpoints.length, 1);
//   return endpoints[0].point + const Offset(0.0, -2.0);
// }

// /// Tap end of [line0]
// Future<void> line0TapEnd(WidgetTester tester) async {
//   final Offset offset = textOffsetToPosition(tester, line0.length);
//   final TestGesture gesture = await tester.startGesture(offset);
//   await tester.pump();
//   await gesture.up();
//   await tester.pumpAndSettle();
// }
