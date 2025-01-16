import 'package:custom_flutter_dialog_plus/src/transition.dart';
import 'package:flutter/material.dart';

class DialogUtils {
  final bool? dismissable;
  final Widget child;
  final DialogTransitionType? dialogTransitionType;
  final Color? barrierColor;
  final RouteSettings? routeSettings;
  final bool? useRootNavigator;
  final bool? useSafeArea;
  final Duration? transitionDuration;

  DialogUtils({
    required this.child,
    this.useSafeArea,
    this.barrierColor,
    this.dismissable,
    this.dialogTransitionType,
    this.routeSettings,
    this.transitionDuration,
    this.useRootNavigator,
  });

  ///Show dialog directly
  Future show<T>(BuildContext context) => showGeneralDialog<T>(
        context: context,
        routeSettings: routeSettings,
        pageBuilder: (context, animation, secondaryAnimation) =>
            (useSafeArea ?? true) ? SafeArea(child: child) : child,
        barrierColor: barrierColor ?? const Color(0x00ffffff),
        barrierDismissible: dismissable ?? true,
        barrierLabel: '',
        transitionDuration:
            transitionDuration ?? const Duration(milliseconds: 500),
        transitionBuilder: (context, animation, secondaryAnimation, child) =>
            _animationWidget(animation, child),
        useRootNavigator: useRootNavigator ?? false,
      );

  Widget _animationWidget(Animation<double> animation, Widget child) {
    switch (dialogTransitionType ?? DialogTransitionType.none) {
      case DialogTransitionType.bubble:
        return DialogTransition.bubble(animation, child);
      case DialogTransitionType.leftToRight:
        return DialogTransition.transitionFromLeft(animation, child);
      case DialogTransitionType.rightToLeft:
        return DialogTransition.transitionFromRight(animation, child);
      case DialogTransitionType.topToBottom:
        return DialogTransition.transitionFromTop(animation, child);
      case DialogTransitionType.bottomToTop:
        return DialogTransition.transitionFromBottom(animation, child);
      case DialogTransitionType.shrink:
        return DialogTransition.shrink(animation, child);
      default:
    }
    return child;
  }
}
