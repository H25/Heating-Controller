import 'dart:math';
import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_controller.dart';

class ThermometerController extends FlareController {

  FlutterActorArtboard mActorArtboard;
  ActorAnimation mFillAnimation;
  double mTemperature = 0;
  double mCurrentTemperatureFill = 0;
  static const double mMaxTemperature = 100;
  static const int mSmoothTime = 5;

  @override
  void initialize(FlutterActorArtboard artboard) {
    mActorArtboard = artboard;
    mFillAnimation = artboard.getAnimation("fill animation");
  }

  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) {
    if (artboard.name.compareTo("Artboard") == 0) {
      mCurrentTemperatureFill +=
          (mTemperature - mCurrentTemperatureFill) * min(1, elapsed * mSmoothTime);
      mFillAnimation.apply(mCurrentTemperatureFill, artboard, 1);
    }
    return true;
  }

  @override
  void setViewTransform(Mat2D viewTransform) {
    // nothing to do
  }

  void updateTemperature(int temperature) {
    mTemperature = temperature/mMaxTemperature;
  }

  void resetTemperature() {
    mTemperature = 0;
  }

}