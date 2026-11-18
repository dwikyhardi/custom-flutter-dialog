# DDialog
[![Fork](https://img.shields.io/github/forks/dwikyhardi/custom-flutter-dialog?style=social)](https://github.com/dwikyhardi/custom-flutter-dialog/fork)&nbsp; [![Star](https://img.shields.io/github/stars/dwikyhardi/custom-flutter-dialog?style=social)](https://github.com/dwikyhardi/custom-flutter-dialog)&nbsp; [![Watches](https://img.shields.io/github/watchers/dwikyhardi/custom-flutter-dialog?style=social)](https://github.com/dwikyhardi/custom-flutter-dialog/)&nbsp; [![Get the library](https://img.shields.io/badge/Get%20library-pub-blue)](https://pub.dev/packages/d_dialog)&nbsp; [![Example](https://img.shields.io/badge/Example-Ex-success)](https://pub.dev/packages/d_dialog/example)

Custom dialog with blur background, popup animation and progressDialog with native style.

Not only helps you display dialog with a blurred background, d_dialog is here to help you do many things. for example, with d_dialog you can display `ProgressDialog` to the user once until it meets the end of `Future`!

First of all, let's leave the old style with `showDialog(blablabla)`, with DDialog you have dialog extensions, you just simply call `.show(context)` at the end of your dialog and let the magic work!

There are 5 types, they are `DDialog`, `DAlertDialog`, `ProgressDialog`, `CustomProgressDialog` and `ZoomDialog`.

## Version 2.0 compatibility

Version 2.0 requires Flutter >=3.47.0 and Dart >=3.13.0 and is validated with Flutter 3.50.0.

Dialogs, themes, styles and the `.show<T>(context)` extensions now use the extracted Material and Cupertino UI libraries. Use the same UI imports in your app as in [the example](example/lib/main.dart); legacy SDK dialog and theme types are different types. The required dependencies are listed in [pubspec.yaml](pubspec.yaml).

Modern Material and Cupertino apps work without a legacy compatibility bridge. Material dialogs inherit the host theme and localization delegates, including localized dismiss and default cancel labels. Cupertino dialogs and custom `DialogBackground` widgets also work in a Cupertino-only app. Custom routes in a plain widgets app use an English dismiss label when no UI localizations are available.

For local integration, override the hosted dependency in your app:

```yaml
dependency_overrides:
  d_dialog:
    path: /absolute/path/to/custom-flutter-dialog
```

## DDialog
Is a raw dialog where you can view them right away without anything else
``` dart
  await DDialog(
    dialogStyle: DialogStyle(titleDivider: true),
    title: Text("Hi, This is d_dialog"),
    content: Text("And here is your content, hoho... "),  
    actions: <Widget>[
      TextButton(child: Text("You"),onPressed: () {}),
      TextButton(child: Text("Are"),onPressed: () {}),
      TextButton(child: Text("Awesome"),onPressed: () {}),
    ],
  ).show(context);
```

## DAlertDialog
Is a dialog where you can directly set the background attributes without be wrapped by `DialogBackground` and you can simply display them.

``` dart
  await DAlertDialog(
    dialogStyle: DialogStyle(titleDivider: true),
    title: Text("Hi, This is DAlertDialog"),
    content: Text("And here is your content, hoho... "), 
    actions: <Widget>[
      TextButton(child: Text("You"),onPressed: () {}),
      TextButton(child: Text("Are"),onPressed: () {}),
      TextButton(child: Text("Awesome"),onPressed: () {}),
    ],
  ).show(context);
``` 
 
## ProgressDialog
Will display the ProgressDialog with Android native style.

``` dart
  ProgressDialog progressDialog = ProgressDialog(context, 
    message:Text("This is the message"), 
    title:Text("This is the title")
  );

  //You can set Message using this function
  progressDialog.setTitle(Text("Loading"));
  progressDialog.setMessage(Text("Please Wait, Injecting your phone with my virus"));
  progressDialog.show();

  await Future.delayed(Duration(seconds: 5));

  //Progress Dialog already show? don't worry, you can change the message :D
  progressDialog.setTitle(Text("Just Kidding"));
  progressDialog.setMessage(Text("I mean, virus of love :*"));

  await Future.delayed(Duration(seconds: 5));

  progressDialog.dismiss();
```

## CustomProgressDialog
Will display a progress dialog with customizable widgets

``` dart
  CustomProgressDialog progressDialog = CustomProgressDialog(context,blur: 10);

  ///You can set Loading Widget using this function
  progressDialog.setLoadingWidget(CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.red)));
  progressDialog.show(useSafeArea: false);

  await Future.delayed(Duration(seconds: 5));

  //Progress Dialog already show? don't worry, you can change the loading widget :D
  progressDialog.setLoadingWidget(NewLoadingWidget());

  await Future.delayed(Duration(seconds: 5));

  progressDialog.dismiss();
```

This is what I'm talking about, Each Progress Dialog has a `.future(context)` static function, which will help you display the progress dialog once until `Future` is completed

``` dart
///ProgressDialog
await ProgressDialog.future(
  context, 
  future: Future.delayed(Duration(seconds: 5), () {
    return "HIYAAA";
  }),
  message: Text("Please Wait"),
  cancelText: Text("Batal"),
  title: Text("Loging in"),
)

///CustomProgressDialog
await CustomProgressDialog.future(
  context,
  future: Future.delayed(Duration(seconds: 5), () {
    return "WOHOOO";
  }),
  loadingWidget: Center(
    child: Container(
      alignment:Alignment.center, 
      child:CircularProgressIndicator(),
    ),
  ),
  backgroundColor: Colors.blue.withValues(alpha: .5),
)

```

## ZoomDialog
Is a dialog that you can zoom on it, you can zoom all type of widget on this dialog, simply write this code and boom, there you go!


``` dart
  await ZoomDialog(
    zoomScale: 5,
    child: Container(
      child: Text("Zoom me!"),
      color: Colors.white,
      padding: EdgeInsets.all(20),
    ),
  ).show(context);
``` 

## Dialog Extensions!
You can call `show(context)` on the Material and Cupertino dialogs from your UI imports.

``` dart
  DAlertDialog( ... ).show(context);
  SimpleDialog( ... ).show(context);
  Dialog( ... ).show(context);
  CupertinoAlertDialog( ... ).show(context);
```

## DialogBackground
You can use DialogBackground to create your own custom dialog and display them easily, not only that, you can also change the barrierColor / background color and add little bit blur effects there.

Note : BlurDialogBackground is depreceted, use `DialogBackground` instead!

``` dart
  await DialogBackground(
    dialog: DAlertDialog(
      title: Text("Alert Dialog"),
      content: Text("Wohoo.. This is ordinary AlertDialog with Blur background"),
      actions: <Widget>[
        TextButton(child: Text("You"),onPressed: () {}),
        TextButton(child: Text("Are"),onPressed: () {}),
        TextButton(child: Text("Awesome"),onPressed: () {}),
      ],
    ),
  ).show(context); 
``` 

## Screenshot
![Example](./example/screenshots/screenshot.gif)

Inspired by [NDialog](https://pub.dev/packages/ndialog)

## License

MIT; see [LICENSE](LICENSE). Earlier public-domain releases retain their original terms.
