import 'package:d_dialog/d_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blur Dialog',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Example BlurDialog'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: <Widget>[
          TextButton(
            style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.blue)),
            child: Text(
              'DAlertDialog show',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              DAlertDialog(
                title: Text('Test'),
                content: Text('Iya iya'),
                blur: 2,
              ).show(context, transitionType: DialogTransitionType.bubble);
            },
          ),
          TextButton(
            style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.blue)),
            child: Text(
              'DDialog can do it too!',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              DDialog(
                title: Text('Test'),
                dialogStyle: DialogStyle(
                  animatePopup: false,
                ),
                content: Text('Iya iya'),
              ).show(context);
            },
          ),
          TextButton(
            style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.blue)),
            onPressed: () async {
              ProgressDialog progressDialog = ProgressDialog(
                context,
                blur: 10,
                dialogTransitionType: DialogTransitionType.shrink,
                transitionDuration: Duration(milliseconds: 100),
                onDismiss: () {
                  if (kDebugMode) {
                    print('Do something onDismiss');
                  }
                },
              );
              progressDialog.setLoadingWidget(CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.red),
              ));
              progressDialog.setMessage(
                  Text('Please Wait, Injecting your phone with my virus'));
              progressDialog.setTitle(Text('Loading'));
              progressDialog.show(useSafeArea: false);

              await Future.delayed(Duration(seconds: 5));

              progressDialog.setMessage(Text('I mean, virus of love :*'));
              progressDialog.setTitle(Text('Just Kidding'));

              await Future.delayed(Duration(seconds: 5));

              progressDialog.dismiss();
            },
            child:
                Text('Progress Dialog', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.blue)),
            onPressed: () async {
              CustomProgressDialog progressDialog = CustomProgressDialog(
                context,
                blur: 10,
                onDismiss: () {
                  if (kDebugMode) {
                    print('Do something onDismiss');
                  }
                },
              );
              progressDialog.setLoadingWidget(CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.red),
              ));
              progressDialog.show(useSafeArea: false);

              await Future.delayed(Duration(seconds: 5));

              await Future.delayed(Duration(seconds: 5));

              progressDialog.dismiss();
            },
            child: Text('Custom Progress Dialog',
                style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.blue)),
            onPressed: () async {
              if (kDebugMode) {
                print(await ProgressDialog.future(
                  context,
                  blur: 0.0,
                  future: Future.delayed(Duration(seconds: 5), () {
                    return 'HIYAAA';
                  }),
                  onProgressError: (error) {
                    if (kDebugMode) {
                      print('Do something onProgressError');
                    }
                  },
                  onProgressFinish: (data) {
                    if (kDebugMode) {
                      print('Do something onProgressFinish');
                    }
                  },
                  onDismiss: () {
                    if (kDebugMode) {
                      print('Dismissed');
                    }
                  },
                  message: Text('Please Wait'),
                  cancelText: Text('Batal'),
                  title: Text('Loging in'),
                ));
              }
            },
            child: Text('Progress Dialog Future',
                style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.blue)),
            onPressed: () async {
              if (kDebugMode) {
                print(await CustomProgressDialog.future(
                  context,
                  backgroundColor: Colors.blue.withValues(alpha: .5),
                  future: Future.delayed(Duration(seconds: 5), () {
                    return 'WOHOOO';
                  }),
                  onProgressError: (error) {
                    if (kDebugMode) {
                      print('Do something onProgressError');
                    }
                  },
                  onProgressFinish: (data) {
                    if (kDebugMode) {
                      print('Do something onProgressFinish');
                    }
                  },
                  onDismiss: () {
                    if (kDebugMode) {
                      print('Dismissed');
                    }
                  },
                ));
              }
            },
            child: Text('Custom Progress Dialog Future',
                style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.blue)),
            onPressed: () async {
              await DAlertDialog(
                dialogStyle: DialogStyle(titleDivider: true),
                title: Text('Hi, This is DAlertDialog'),
                content: Text('And here is your content, hoho... '),
                actions: <Widget>[
                  TextButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.blue)),
                    child: Text('You'),
                    onPressed: () {},
                  ),
                  TextButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.blue)),
                    child: Text('Are'),
                    onPressed: () {},
                  ),
                  TextButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.blue)),
                    child: Text('Awesome'),
                    onPressed: () {},
                  )
                ],
              ).show(context);
            },
            child: Text('Show DAlertDialog',
                style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.blue)),
            onPressed: () async {
              await DDialog(
                dialogStyle: DialogStyle(titleDivider: true),
                title: Text('Hi, This is DDialog'),
                content: Text('And here is your content, hoho... '),
                actions: <Widget>[
                  TextButton(
                    child: Text('You'),
                    onPressed: () {},
                  ),
                  TextButton(
                    child: Text('Are'),
                    onPressed: () {},
                  ),
                  TextButton(
                    child: Text('Awesome'),
                    onPressed: () {},
                  )
                ],
              ).show(
                context,
              );
            },
            child: Text('Show DDialog', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.blue)),
            child: Text(
              'Show Alert Dialog\nWith Blur Background',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            onPressed: () async {
              await DialogBackground(
                barrierColor: Colors.black.withValues(alpha: .5),
                blur: 0,
                dialog: AlertDialog(
                  title: Text('Alert Dialog'),
                  content: Text(
                      'Wohoo.. This is ordinary AlertDialog with Blur background'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('You'),
                      onPressed: () {},
                    ),
                    TextButton(
                      child: Text('Are'),
                      onPressed: () {},
                    ),
                    TextButton(
                      child: Text('Awesome'),
                      onPressed: () {},
                    )
                  ],
                ),
              ).show(
                context,
              );
            },
          ),
          SizedBox(
            height: 10,
          ),
          TextButton(
            style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.blue)),
            child: Text(
              'Show Alert Dialog\nWith Custom Background Color',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            onPressed: () async {
              await DAlertDialog(
                backgroundColor: Colors.red.withValues(alpha: .5),
                blur: 0,
                title: Text('Alert Dialog'),
                content: Text(
                    'Wohoo.. This is ordinary AlertDialog with Custom Color background'),
                actions: <Widget>[
                  TextButton(
                    child: Text('You'),
                    onPressed: () {},
                  ),
                  TextButton(
                    child: Text('Are'),
                    onPressed: () {},
                  ),
                  TextButton(
                    child: Text('Awesome'),
                    onPressed: () {},
                  )
                ],
              ).show(context);
            },
          ),
          TextButton(
            style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.blue)),
            child: Text(
              'Dialog Extension',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            onPressed: () async {
              await AlertDialog(
                title: Text('Alert Dialog'),
                content: Text(
                    'Wohoo.. This is ordinary AlertDialog with Blur background'),
                actions: <Widget>[
                  TextButton(
                    child: Text('You'),
                    onPressed: () {},
                  ),
                  TextButton(
                    child: Text('Are'),
                    onPressed: () {},
                  ),
                  TextButton(
                    child: Text('Awesome'),
                    onPressed: () {},
                  )
                ],
              ).show(context);
            },
          ),
          TextButton(
            style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.blue)),
            child: Text(
              'CupertinoDialog Extension',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            onPressed: () async {
              await CupertinoAlertDialog(
                title: Text('Alert Dialog'),
                content: Text(
                    'Wohoo.. This is ordinary AlertDialog with Blur background'),
                actions: <Widget>[
                  TextButton(
                    child: Text('You'),
                    onPressed: () {},
                  ),
                  TextButton(
                    child: Text('Are'),
                    onPressed: () {},
                  ),
                  TextButton(
                    child: Text('Awesome'),
                    onPressed: () {},
                  )
                ],
              ).show(context);
            },
          ),
          TextButton(
            style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.blue)),
            child: Text(
              'ZoomDIALOG',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            onPressed: () async {
              await ZoomDialog(
                zoomScale: 5,
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(20),
                  child: Text('Zoom me!'),
                ),
              ).show(context);
            },
          ),
        ],
      ),
    );
  }
}
