// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:multitext/chunk_list/chunk_text_editing_controller.dart';

// import '_util.dart';

// void main() {
//   testWidgets('MultiText smoke test', (WidgetTester tester) async {
//     await testPlainText(tester);

//     /// Verify that a widget appears for each line, and an empty new-line
//     {
//       // Leading newlines appear as [kInvisibleCharacter]
//       expect(find.text(line0), findsOneWidget);
//       expect(find.text(controllerTextLine1), findsOneWidget);
//       expect(find.text(controllerTextLine2), findsOneWidget);
//       expect(find.text(kInvisibleCharacter), findsOneWidget);
//     }

//     /// Add a new line of text
//     {
//       await tester.enterText(find.text(line0), '$line0\n$lineNew');
//       await tester.pumpAndSettle();

//       // New-line exists and has-focus
//       final findLineNew = find.text(controllerTextLineNew);
//       expect(findLineNew, findsOneWidget);
//       final editableText =
//           (findLineNew.evaluate().first.widget as EditableText);
//       expect(editableText.focusNode.hasFocus, isTrue);
//       expect(editableText.controller.selection.start,
//           editableText.controller.text.length);

//       // Unaffected lines
//       expect(find.text(line0), findsOneWidget);
//       expect(find.text(controllerTextLine1), findsOneWidget);
//       expect(find.text(controllerTextLine2), findsOneWidget);
//       expect(find.text(kInvisibleCharacter), findsOneWidget);
//     }

//     /// Remove the new line of text
//     {
//       await tester.enterText(find.text(controllerTextLineNew), '');
//       await tester.pumpAndSettle();

//       expect(find.text(controllerTextLineNew), findsNothing);

//       // Focus returns to [line0]
//       final findLine0 = find.text(line0);
//       expect(findLine0, findsOneWidget);
//       expect(
//           (findLine0.evaluate().first.widget as EditableText)
//               .focusNode
//               .hasFocus,
//           isTrue);

//       // Unaffected lines
//       expect(find.text(controllerTextLine1), findsOneWidget);
//       expect(find.text(controllerTextLine2), findsOneWidget);
//       expect(find.text(kInvisibleCharacter), findsOneWidget);
//     }

//     /// Join two lines
//     {
//       // Removing [kInvisibleCharacter] simulates backspace
//       await tester.enterText(find.text(controllerTextLine1), line1);
//       await tester.pumpAndSettle();

//       // Original lines are removed
//       expect(find.text(line0), findsNothing);
//       expect(find.text(controllerTextLine1), findsNothing);

//       // Joined line is added
//       expect(find.text('$line0$line1'), findsOneWidget);

//       // Unaffected lines
//       expect(find.text(controllerTextLine2), findsOneWidget);
//       expect(find.text(kInvisibleCharacter), findsOneWidget);
//     }
//   });

//   testWidgets('MultiText cursor position test', (WidgetTester tester) async {
//     await testPlainText(tester);

//     /// Tap end of [line0]
//     final Offset endLine0 = textOffsetToPosition(tester, line0.length);
//     final TestGesture gesture = await tester.startGesture(endLine0);
//     await tester.pump();
//     await gesture.up();
//     await tester.pumpAndSettle();

//     final editableTextLine0 =
//         find.text(line0).evaluate().first.widget as EditableText;
//     final editableTextLine1 =
//         find.text(controllerTextLine1).evaluate().first.widget as EditableText;

//     /// Selection and focus is correct
//     {
//       expect(editableTextLine0.focusNode.hasFocus, isTrue);
//       expect(editableTextLine0.controller.selection.start,
//           editableTextLine0.controller.text.length);
//     }

//     /// Press [→] key moves to the beginning of next line
//     {
//       await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
//       await tester.pumpAndSettle();
//       expect(editableTextLine0.focusNode.hasFocus, isFalse);
//       expect(editableTextLine1.focusNode.hasFocus, isTrue);
//       expect(editableTextLine1.controller.selection.start, 1);
//     }

//     /// Press [←] key moves to the end of previous line
//     {
//       await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
//       await tester.pumpAndSettle();

//       expect(editableTextLine0.focusNode.hasFocus, isTrue);
//       expect(editableTextLine0.controller.selection.start,
//           editableTextLine0.controller.text.length);
//       expect(editableTextLine1.focusNode.hasFocus, isFalse);
//     }

//     /// Press [↓] key moves to the beginning of next line
//     {
//       await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
//       await tester.pumpAndSettle();

//       expect(editableTextLine0.focusNode.hasFocus, isFalse);
//       expect(editableTextLine1.focusNode.hasFocus, isTrue);
//       expect(editableTextLine1.controller.selection.start, 1);
//     }

//     /// Press [↑] key moves to the end of previous line
//     {
//       await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
//       await tester.pumpAndSettle();

//       expect(editableTextLine0.focusNode.hasFocus, isTrue);
//       expect(editableTextLine0.controller.selection.start,
//           editableTextLine0.controller.text.length);
//       expect(editableTextLine1.focusNode.hasFocus, isFalse);
//     }
//   });

//   testWidgets('MultiText selection test', (WidgetTester tester) async {
//     await testPlainText(tester);

//     /// Drag range-slider to its maximum
//     {
//       final slider = find.byType(RangeSlider);
//       await tester.drag(slider, tester.getBottomRight(slider));
//       await tester.pumpAndSettle();

//       /// All text selected in [line0]
//       final editableTextLine0 =
//           find.text(line0).evaluate().first.widget as EditableText;
//       expect(editableTextLine0.controller.selection.start, 0);
//       expect(editableTextLine0.controller.selection.end, line0.length);

//       /// All text except for hidden new-line character selected in [line1]
//       final editableTextLine1 = find
//           .text(controllerTextLine1)
//           .evaluate()
//           .first
//           .widget as EditableText;
//       expect(editableTextLine1.controller.selection.start, 1);
//       expect(editableTextLine1.controller.selection.end,
//           controllerTextLine1.length);

//       /// All text except for hidden new-line character selected in [line2]
//       final editableTextLine2 = find
//           .text(controllerTextLine2)
//           .evaluate()
//           .first
//           .widget as EditableText;
//       expect(editableTextLine2.controller.selection.start, 1);
//       expect(editableTextLine2.controller.selection.end,
//           controllerTextLine2.length);

//       /// Collapsed selection and focus at trailing new-line
//       final editableTextLineEmpty = find
//           .text(kInvisibleCharacter)
//           .evaluate()
//           .first
//           .widget as EditableText;
//       expect(editableTextLineEmpty.controller.selection.start, 1);
//       expect(editableTextLineEmpty.controller.selection.end, 1);
//       expect(editableTextLineEmpty.focusNode.hasFocus, isTrue);

//       TestTextInput().enterText(lineNew);
//       await tester.pumpAndSettle();

//       /// Text is replaced with [lineNew] and cursor follows
//       final editableTextLineNew =
//           find.text(lineNew).evaluate().first.widget as EditableText;
//       expect(editableTextLineNew.controller.selection.start, lineNew.length);
//       expect(editableTextLineNew.controller.selection.end, lineNew.length);
//       expect(editableTextLineNew.focusNode.hasFocus, true);

//       /// Trailing new-line is not selected
//       expect(
//           (find.text(kInvisibleCharacter).evaluate().first.widget
//                   as EditableText)
//               .controller
//               .selection
//               .isValid,
//           false);
//     }
//   });
// }
