## [2.3.2] - 2022-09-08
- Update `measure_size` pacakge version

## [2.3.1] - 2022-06-22
- Fix box-shadows appearing above bar color
- `color` defaults to `T`heme.of(context).bottomAppBarColor`
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


9ff88ea8ca87cb5fb3f6efeba353196df61218d8
[Unreleased]: https://github.com/mhrst/bottom_sheet_bar/compare/9ff88ea8ca87cb5fb3f6efeba353196df61218d8...HEAD
[2.3.1]: https://github.com/mhrst/bottom_sheet_bar/compare/9fe9692dd11c497c74b29170c08aaa5a8f74d6c0...9ff88ea8ca87cb5fb3f6efeba353196df61218d8
[2.2.1]: https://github.com/mhrst/bottom_sheet_bar/compare/0c962a7baa33a0b30d2c841dad63acc24ec5b462...9fe9692dd11c497c74b29170c08aaa5a8f74d6c0
[2.2.0]: https://github.com/mhrst/bottom_sheet_bar/compare/f3a35f11d31e37d883d21e0803264ff8f89c4940...0c962a7baa33a0b30d2c841dad63acc24ec5b462
[2.0.0]: https://github.com/mhrst/bottom_sheet_bar/compare/44955fb42f5484c9bc753f0466f1b6be061493bf...f3a35f11d31e37d883d21e0803264ff8f89c4940
[1.0.2+7]: https://github.com/mhrst/bottom_sheet_bar/compare/e3e4463b33a5164bfb6e9355a006b221c65990ad...44955fb42f5484c9bc753f0466f1b6be061493bf
[1.0.2+6]: https://github.com/mhrst/bottom_sheet_bar/compare/81945ff94376c66055298dea6373063b50d41f52...e3e4463b33a5164bfb6e9355a006b221c65990ad
[1.0.1+5]: https://github.com/mhrst/bottom_sheet_bar/compare/0fb7b4fc6c19a33bcfdf8e1e09a4e776add70d45...81945ff94376c66055298dea6373063b50d41f52
[1.0.1+4]: https://github.com/mhrst/bottom_sheet_bar/compare/a14c9b679f6cd51a6042234ceeb05b5e470fce90...0fb7b4fc6c19a33bcfdf8e1e09a4e776add70d45
[1.0.0+3]: https://github.com/mhrst/bottom_sheet_bar/compare/c908368e6fd1c4e807c93fe6ec98d7036acc70d4...a14c9b679f6cd51a6042234ceeb05b5e470fce90
[1.0.0+2]: https://github.com/mhrst/bottom_sheet_bar/compare/6222a43bd589ee38b3ec2aa7182f87de1ae50690...c908368e6fd1c4e807c93fe6ec98d7036acc70d4
[1.0.0+1]:https://github.com/mhrst/bottom_sheet_bar/6222a43bd589ee38b3ec2aa7182f87de1ae50690
