## [2.3.11] - 2025-06-13
- Handle touchpad scrolling gestures

## [2.3.10] - 2024-05-16
- Replace deprecated usage of `bottomAppBarColor`

## [2.3.9] - 2023-03-29
- Fix back gesture for iOS when bottom-sheet is collapsed

## [2.3.8] - 2022-10-18
- Remove `WillPopScope`
- Add `willPopScope` and `backButtonListener` properties to support handling back-gestures in multiple scenarios

## [2.3.7] - 2022-10-18
- Replace `BackButtonListener` with `WillPopScope`
- Wrap expanded-sheet widget with a `RepaintBoundary`
- Prevent pan-gesture and fling from hiding the `collapsed` widget entirely

## [2.3.6] - 2022-10-13
- Added `BackButtonListener` to collapse bottom-sheet when using the device's 'Back' button

## [2.3.5] - 2022-09-22
- Fix shadows and layering with `SafeArea`

## [2.3.4] - 2022-09-20
- Wrap `SafeArea` with `color` to match bar color

## [2.3.3] - 2022-09-15
- Added new parameter to adjust fling velocity: `velocityMin`
- When collapsing, check `ScrollController.hasClients` before resetting scroll position

## [2.3.2] - 2022-09-08
- Update `measure_size` pacakge version

## [2.3.1] - 2022-06-22
- Fix box-shadows appearing above bar color
- `color` defaults to `Theme.of(context).bottomAppBarColor`
  - The default is still `Colors.white`
- Reduce number of `build` calls in widget tree

## [2.2.1] - 2022-06-01
- Set Flutter SDK constraint

## [2.2.0] - 2022-05-12
- Updated for Flutter 3

## [2.1.1] - 2021-10-12
### Fixed
- Widget accomodates for safe-area spaces (bottom-notch, etc.)

## [2.1.0] - 2021-10-09
### Fixed
- Swiping to open/close works more consistently
- Made isCollapsed and isExpanded reliable
- Inkwell animations appear on the BottomSheetBar background

## [2.0.1] - 2021-05-22
### Added
- Add optional box-shadows to BottomSheetBar widget

## [2.0.0] - 2021-03-07
### Changed
- Migrated to null safety

## [1.0.2+7] - 2020-11-06
### Fixed
- No longer using deprecated `VelocityTracker` constructor
- Bottom of body is no longer obscured when a bottom-safe-area is present

## [1.0.2+6] - 2020-10-18
### Added
- Optional property `borderRadiusExpanded` to animate and display a different border-radius in the expanded state

## [1.0.1+5] - 2020-10-17
### Changed
- Moved `MeasureSize` widget to https://pub.dev/packages/measure_size

## [1.0.1+4] - 2020-10-17
### Fixed
- Body widget gets placed in a full-size container
  - (side-effect) Body widgets are aligned to the top of parent container rather than aligned above the bottom-sheet

## [1.0.0+3] - 2020-10-08
### Fixed
- Content overflowing bottom sheet now scrollable with scroll gestures other than touch (mousewheel, trackpad, etc.)

## [1.0.0+2] - 2020-09-28
### Added
- Dart docstrings added to public API

### Changed
- README updated
- Longer package description

### Fixed
- VelocityTracker uses the deprecated constructor for compatibility with Flutter stable channel

## [1.0.0+1] - 2020-09-26
- Initial release
