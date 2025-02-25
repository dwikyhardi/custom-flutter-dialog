import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:d_dialog/d_dialog.dart';

///Extension of Dialog
extension DialogShow on Dialog {
  Future<T?> show<T>(
    BuildContext context, {
    bool barrierDismissible = true,
    Color? barrierColor,
    bool useSafeArea = true,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
  }) =>
      showDialog<T>(
        context: context,
        builder: (context) => this,
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor,
        useSafeArea: useSafeArea,
        useRootNavigator: useRootNavigator,
        routeSettings: routeSettings,
      );
}

///Extension of AlertDialog
extension AlertDialogShow on AlertDialog {
  Future<T?> show<T>(
    BuildContext context, {
    bool barrierDismissible = true,
    Color? barrierColor,
    bool useSafeArea = true,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
    DialogTransitionType? dialogTransitionType,
  }) =>
      DialogUtils(
        barrierColor: barrierColor ?? Colors.black.withValues(alpha: .5),
        child: this,
        dismissable: barrierDismissible,
        dialogTransitionType: dialogTransitionType,
        routeSettings: routeSettings,
        useRootNavigator: useRootNavigator,
        useSafeArea: useSafeArea,
      ).show(context) as Future<T?>;
}

///Extension of SimpleDialog
extension SimpleDialogShow on SimpleDialog {
  Future<T?> show<T>(
    BuildContext context, {
    bool barrierDismissible = true,
    Color? barrierColor,
    bool useSafeArea = true,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
    DialogTransitionType? dialogTransitionType,
  }) =>
      DialogUtils(
        barrierColor: barrierColor ?? Colors.black.withValues(alpha: .5),
        child: this,
        dismissable: barrierDismissible,
        dialogTransitionType: dialogTransitionType,
        routeSettings: routeSettings,
        useRootNavigator: useRootNavigator,
        useSafeArea: useSafeArea,
      ).show(context) as Future<T?>;
}

///Extension of CupertinoAlertDialog
extension CupertinoAlertDialogShow on CupertinoAlertDialog {
  Future<T?> show<T>(
    BuildContext context, {
    bool barrierDismissible = true,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
  }) =>
      showCupertinoDialog<T>(
        context: context,
        builder: (context) => this,
        barrierDismissible: barrierDismissible,
        useRootNavigator: useRootNavigator,
        routeSettings: routeSettings,
      );
}
