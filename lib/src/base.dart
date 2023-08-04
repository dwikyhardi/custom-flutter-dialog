import 'dart:async';
import 'dart:ui';

import 'package:d_dialog/src/transition.dart';
import 'package:d_dialog/src/utils.dart';
import 'package:d_dialog/src/zoom_widget/zoom_widget.dart';
import 'package:flutter/material.dart';

/// DDialog widget
class DDialog extends StatelessWidget {
  ///Dialog style
  final DialogStyle? dialogStyle;

  ///The (optional) title of the dialog is displayed in a large font at the top of the dialog.
  final Widget? title;

  ///The (optional) content of the dialog is displayed in the center of the dialog in a lighter font.
  final Widget? content;

  ///The (optional) set of actions that are displayed at the bottom of the dialog.
  final List<Widget>? actions;

  const DDialog(
      {Key? key, this.dialogStyle, this.title, this.content, this.actions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final DialogTheme dialogTheme = DialogTheme.of(context);
    final DialogStyle style = dialogStyle ?? DialogStyle();

    String? label = style.semanticsLabel;
    Widget dialogChild = IntrinsicWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          title != null
              ? Padding(
                  padding: style.titlePadding ??
                      const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
                  child: DefaultTextStyle(
                    style: style.titleTextStyle ??
                        dialogTheme.titleTextStyle ??
                        theme.textTheme.titleLarge!,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Semantics(
                          namesRoute: true,
                          label: label,
                          child: title,
                        ),
                        style.titleDivider ?? false
                            ? const Divider()
                            : Container(
                                height: 10.0,
                              )
                      ],
                    ),
                  ),
                )
              : Container(),
          content != null
              ? Flexible(
                  child: Padding(
                    padding: style.contentPadding ??
                        const EdgeInsets.only(
                            right: 15.0, left: 15.0, top: 0.0, bottom: 15.0),
                    child: DefaultTextStyle(
                      style: style.contentTextStyle ??
                          dialogTheme.contentTextStyle ??
                          theme.textTheme.titleMedium!,
                      child: Semantics(child: content),
                    ),
                  ),
                )
              : Container(),
          actions != null
              ? Theme(
                  data: ThemeData(
                    buttonTheme: ButtonThemeData(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                  ),
                  child: actions!.length <= 3
                      ? IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: List.generate(
                              actions!.length,
                              (index) {
                                return Expanded(child: actions![index]);
                              },
                            ),
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                            actions!.length,
                            (index) {
                              return SizedBox(
                                height: 50.0,
                                child: actions![index],
                              );
                            },
                          ),
                        ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );

    return Padding(
      padding: MediaQuery.of(context).viewInsets +
          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 280.0),
          child: Card(
            clipBehavior: Clip.antiAlias,
            elevation: style.elevation ?? 24,
            color: style.backgroundColor,
            shape: style.borderRadius != null
                ? RoundedRectangleBorder(borderRadius: style.borderRadius!)
                : style.shape ??
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
            child: dialogChild,
          ),
        ),
      ),
    );
  }

  Future<T?> show<T>(BuildContext context,
          {DialogTransitionType? transitionType,
          bool? dismissable,
          Duration? transitionDuration}) =>
      DialogUtils(
        child: this,
        dialogTransitionType: transitionType,
        dismissable: dismissable,
        barrierColor: Colors.black.withOpacity(.5),
        transitionDuration: transitionDuration,
      ).show(context) as Future<T?>;
}

///Simple dialog with blur background and popup animations, use DialogStyle to custom it
class DAlertDialog extends DialogBackground {
  ///Dialog style
  final DialogStyle? dialogStyle;

  ///The (optional) title of the dialog is displayed in a large font at the top of the dialog.
  final Widget? title;

  ///The (optional) content of the dialog is displayed in the center of the dialog in a lighter font.
  final Widget? content;

  ///The (optional) set of actions that are displayed at the bottom of the dialog.
  final List<Widget>? actions;

  ///Its Barrier Color
  final Color? backgroundColor;

  const DAlertDialog({
    Key? key,
    this.backgroundColor,
    this.dialogStyle,
    this.title,
    this.content,
    this.actions,
    double? blur,
    bool? dismissable,
    Function? onDismiss,
  }) : super(
          key: key,
          onDismiss: onDismiss,
          dismissable: dismissable,
          blur: blur,
        );

  @override
  Widget build(BuildContext context) {
    return DialogBackground(
      dialog: DDialog(
        dialogStyle: dialogStyle,
        actions: actions,
        content: content,
        title: title,
      ),
      dismissable: dismissable,
      blur: blur ?? 0,
      onDismiss: onDismiss,
      barrierColor: backgroundColor,
      key: key,
    );
  }
}

//A Dialog, but you can zoom on it
class ZoomDialog extends DialogBackground {
  ///The (optional) content of the dialog is displayed in the center of the dialog in a lighter font.
  final Widget child;

  /// Background color
  final Color? backgroundColor;

  ///Maximum zoom scale
  final double zoomScale;

  ///Initialize zoom scale on dialog show
  final double initZoomScale;

  const ZoomDialog({
    Key? key,
    this.backgroundColor,
    required this.child,
    this.initZoomScale = 0,
    this.zoomScale = 3,
    double? blur,
    Function? onDismiss,
  }) : super(
          key: key,
          blur: blur,
          onDismiss: onDismiss,
        );

  @override
  Widget build(BuildContext context) {
    return DialogBackground(
      key: key,
      dialog: Zoom(
        onTap: () {
          Navigator.pop(context);
          if (onDismiss != null) onDismiss!();
        },
        canvasColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        initZoom: initZoomScale,
        centerOnScale: true,
        maxZoomWidth: MediaQuery.of(context).size.width * zoomScale,
        maxZoomHeight: MediaQuery.of(context).size.height * zoomScale,
        child: Transform.scale(
          scale: zoomScale,
          child: Center(
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: child,
            ),
          ),
        ),
      ),
      dismissable: true,
      blur: blur ?? 0,
      onDismiss: onDismiss,
      barrierColor: backgroundColor,
    );
  }
}

///Blur background of dialog, you can use this class to make your custom dialog background blur
class DialogBackground extends StatelessWidget {
  ///Widget of dialog, you can use d_dialog, Dialog, AlertDialog or Custom your own Dialog
  final Widget? dialog;

  ///Because blur dialog cover the barrier, you have to declare here
  final bool? dismissable;

  ///Action before dialog dismissed
  final Function? onDismiss;

  /// Creates an background filter that applies a Gaussian blur.
  /// Default = 0
  final double? blur;

  final Color? barrierColor;

  const DialogBackground(
      {Key? key,
      this.dialog,
      this.dismissable,
      this.blur,
      this.onDismiss,
      this.barrierColor})
      : super(key: key);

  ///Show dialog directly
  // Future show<T>(BuildContext context) => showDialog<T>(context: context, builder: (context) => this, barrierColor: barrierColor, barrierDismissible: dismissable ?? true);

  Future<T?> show<T>(BuildContext context,
          {DialogTransitionType? transitionType,
          bool? dismissable,
          Duration? transitionDuration}) =>
      DialogUtils(
        child: this,
        dialogTransitionType: transitionType,
        dismissable: dismissable,
        barrierColor: barrierColor ?? Colors.black.withOpacity(.5),
        transitionDuration: transitionDuration,
      ).show(context) as Future<T?>;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.canvas,
      color: Colors.transparent,
      child: WillPopScope(
        onWillPop: () async {
          if (dismissable ?? true) {
            if (onDismiss != null) onDismiss!();
            Navigator.pop(context);
          }
          return false;
        },
        child: Stack(
          clipBehavior: Clip.antiAlias,
          alignment: Alignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: dismissable ?? true
                  ? () {
                      if (onDismiss != null) {
                        onDismiss!();
                      }
                      Navigator.pop(context);
                    }
                  : () {},
              child: (blur ?? 0) < 1
                  ? Container()
                  : TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0.1, end: blur ?? 0),
                      duration: const Duration(milliseconds: 300),
                      builder: (context, double? val, Widget? child) {
                        return BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: val ?? 0,
                            sigmaY: val ?? 0,
                          ),
                          child: Container(color: Colors.transparent),
                        );
                      },
                    ),
            ),
            dialog!
          ],
        ),
      ),
    );
  }
}

///Dialog style to custom your dialog
class DialogStyle {
  /// Divider on title
  final bool? titleDivider;

  ///Set circular border radius for your dialog
  final BorderRadius? borderRadius;

  ///Set semanticslabel for Title
  final String? semanticsLabel;

  ///Set padding for your Title
  final EdgeInsets? titlePadding;

  ///Set padding for your  Content
  final EdgeInsets? contentPadding;

  ///Set TextStyle for your Title
  final TextStyle? titleTextStyle;

  ///Set TextStyle for your Content
  final TextStyle? contentTextStyle;

  ///Elevation for dialog
  final double? elevation;

  ///Background color of dialog
  final Color? backgroundColor;

  ///Shape for dialog, ignored if you set BorderRadius
  final ShapeBorder? shape;

  ///Bubble animation when your dialog will popup
  @Deprecated('Use animatePopup on .show() instead')
  final bool? animatePopup;

  ///Dialog Transition Type
  // final DialogTransitionType dialogTransitionType;

  DialogStyle({
    this.titleDivider,
    // this.dialogTransitionType,
    this.borderRadius,
    this.semanticsLabel,
    this.titlePadding,
    this.contentPadding,
    this.titleTextStyle,
    this.contentTextStyle,
    this.elevation,
    this.backgroundColor,
    this.animatePopup,
    this.shape,
  });
}
