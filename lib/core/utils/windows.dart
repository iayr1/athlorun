// ignore_for_file: non_constant_identifier_names

import 'dart:ui';
import 'package:flutter/material.dart';

/*
  This is where the magic happens.
  These functions are responsible to make UI responsive across all the mobile devices.
*/

class Window {
  /*
    These are the Viewport values of your Figma Design.
    These are used in the code as a reference to create your UI Responsively.
  */
  static num FIGMA_DESIGN_WIDTH = 360;
  static num FIGMA_DESIGN_HEIGHT = 812;
  static num FIGMA_DESIGN_STATUS_BAR = 0;

  static num _width = 0;
  static num _height = 0;
  static num _safeHeight = 0;

  void adaptDeviceScreenSize({required FlutterView view}) {
    Size deviceScreenSize = view.physicalSize;
    double devicePixelRatio = view.devicePixelRatio;

    Size size = deviceScreenSize / devicePixelRatio;

    _width = size.width;
    _height = size.height;

    num statusBar = MediaQueryData.fromView(view).viewPadding.top;
    num bottomBar = MediaQueryData.fromView(view).viewPadding.bottom;
    num screenHeight = size.height - statusBar - bottomBar;

    _safeHeight = screenHeight;
  }

  /*
    Width
  */
  static double get width => _width * 1.0;

  /*
    Height
  */
  static double get height => _height * 1.0;

  /*
    Safe Height
  */
  static double get safeHeight => _safeHeight * 1.0;

  /*
    This method is used to set padding/margin (for the left and right side)
    &
    width of the screen or widget according to the viewport width.
  */
  static double getHorizontalSize(double px) {
    return ((px * width) / FIGMA_DESIGN_WIDTH);
  }

  static double getRadiusSize(double px) {
    return ((px * width) / FIGMA_DESIGN_WIDTH);
  }

  /*
    This method is used to set padding/margin (for the top and bottom side)
    &
    height of the screen or widget according to the viewport height.
  */
  static double getVerticalSize(double px) {
    return ((px * height) / (FIGMA_DESIGN_HEIGHT - FIGMA_DESIGN_STATUS_BAR));
  }

  /*
    This method is used to set smallest px in image height and width
  */
  static double getSize(double px) {
    var height = getVerticalSize(px);
    var width = getHorizontalSize(px);
    if (height < width) {
      return height;
    } else {
      return width;
    }
  }

  /*
    This method is used to set text font size according to viewport
  */
  static double getFontSize(double px) {
    return getSize(px);
  }

  /*
    This method is used to set padding responsively
  */
  static EdgeInsets getPadding({
    double? all,
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    return getMarginOrPadding(
      all: all,
      left: left,
      top: top,
      right: right,
      bottom: bottom,
    );
  }

  /*
    This method is used to set symmetric padding responsively
  */
  static EdgeInsets getSymmetricPadding({
    double horizontal = 0,
    double vertical = 0,
  }) {
    return EdgeInsets.symmetric(
      horizontal: getHorizontalSize(horizontal),
      vertical: getVerticalSize(vertical),
    );
  }

  /*
    This method is used to set margin responsively
  */
  static EdgeInsets getMargin({
    double? all,
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    return getMarginOrPadding(
      all: all,
      left: left,
      top: top,
      right: right,
      bottom: bottom,
    );
  }

  /*
    This method is used to get padding or margin responsively
  */
  static EdgeInsets getMarginOrPadding({
    double? all,
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    if (all != null) {
      left = all;
      top = all;
      right = all;
      bottom = all;
    }
    return EdgeInsets.only(
      left: getHorizontalSize(
        left ?? 0,
      ),
      top: getVerticalSize(
        top ?? 0,
      ),
      right: getHorizontalSize(
        right ?? 0,
      ),
      bottom: getVerticalSize(
        bottom ?? 0,
      ),
    );
  }
}
