import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:custom_flutter_dialog_plus/d_dialog.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blur Dialog',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Example BlurDialog'),
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
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          TextButton(
            style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.blue)),
            child: const Text(
              'DAlertDialog show',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              const DAlertDialog(
                title: Text('Test'),
                content: Text('Iya iya'),
                blur: 2,
              ).show(context, transitionType: DialogTransitionType.bubble);
            },
          ),
          TextButton(
            style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.blue)),
            child: const Text(
              'DDialog can do it too!',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              DDialog(
                title: const Text('Test'),
                dialogStyle: DialogStyle(
                  animatePopup: false,
                ),
                content: const Text('Iya iya'),
              ).show(context);
            },
          ),
          TextButton(
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.blue),
            ),
            onPressed: () async {
              ProgressDialog progressDialog = ProgressDialog(
                context,
                blur: 10,
                dialogTransitionType: DialogTransitionType.shrink,
                transitionDuration: const Duration(milliseconds: 100),
                onDismiss: () {
                  if (kDebugMode) {
                    print('Do something onDismiss');
                  }
                },
              );
              progressDialog.setLoadingWidget(const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.red),
              ));
              progressDialog.setMessage(const Text(
                  'Please Wait, Injecting your phone with my virus'));
              progressDialog.setTitle(const Text('Loading'));
              progressDialog.show(useSafeArea: false);

              await Future.delayed(const Duration(seconds: 5));

              progressDialog.setMessage(const Text('I mean, virus of love :*'));
              progressDialog.setTitle(const Text('Just Kidding'));

              await Future.delayed(const Duration(seconds: 5));

              progressDialog.dismiss();
            },
            child: const Text('Progress Dialog',
                style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            style: const ButtonStyle(
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
              progressDialog.setLoadingWidget(const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.red),
              ));
              progressDialog.show(useSafeArea: false);

              await Future.delayed(const Duration(seconds: 5));

              await Future.delayed(const Duration(seconds: 5));

              progressDialog.dismiss();
            },
            child: const Text('Custom Progress Dialog',
                style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.blue)),
            onPressed: () async {
              if (kDebugMode) {
                print(await ProgressDialog.future(
                  context,
                  blur: 0.0,
                  future: Future.delayed(const Duration(seconds: 5), () {
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
                  message: const Text('Please Wait'),
                  cancelText: const Text('Batal'),
                  title: const Text('Loging in'),
                ));
              }
            },
            child: const Text(
              'Progress Dialog Future',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.blue),
            ),
            onPressed: () async {
              if (kDebugMode) {
                print(await CustomProgressDialog.future(
                  context,
                  backgroundColor: Colors.blue.withValues(alpha: 0.5),
                  future: Future.delayed(const Duration(seconds: 5), () {
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
            child: const Text('Custom Progress Dialog Future',
                style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.blue)),
            onPressed: () async {
              await DAlertDialog(
                dialogStyle: DialogStyle(titleDivider: true),
                title: const Text('Hi, This is DAlertDialog'),
                content: const Text('And here is your content, hoho... '),
                actions: <Widget>[
                  TextButton(
                    style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.blue)),
                    child: const Text('You'),
                    onPressed: () {},
                  ),
                  TextButton(
                    style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.blue)),
                    child: const Text('Are'),
                    onPressed: () {},
                  ),
                  TextButton(
                    style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.blue)),
                    child: const Text('Awesome'),
                    onPressed: () {},
                  )
                ],
              ).show(context);
            },
            child: const Text('Show DAlertDialog',
                style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.blue)),
            onPressed: () async {
              await DDialog(
                dialogStyle: DialogStyle(titleDivider: true),
                title: const Text('Hi, This is DDialog'),
                content: const Text('And here is your content, hoho... '),
                actions: <Widget>[
                  TextButton(
                    child: const Text('You'),
                    onPressed: () {},
                  ),
                  TextButton(
                    child: const Text('Are'),
                    onPressed: () {},
                  ),
                  TextButton(
                    child: const Text('Awesome'),
                    onPressed: () {},
                  )
                ],
              ).show(
                context,
              );
            },
            child: const Text('Show DDialog',
                style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.blue)),
            child: const Text(
              'Show Alert Dialog\nWith Blur Background',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            onPressed: () async {
              await DialogBackground(
                barrierColor: Colors.black.withValues(alpha: .5),
                blur: 0,
                dialog: AlertDialog(
                  title: const Text('Alert Dialog'),
                  content: const Text(
                      'Wohoo.. This is ordinary AlertDialog with Blur background'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('You'),
                      onPressed: () {},
                    ),
                    TextButton(
                      child: const Text('Are'),
                      onPressed: () {},
                    ),
                    TextButton(
                      child: const Text('Awesome'),
                      onPressed: () {},
                    )
                  ],
                ),
              ).show(
                context,
              );
            },
          ),
          const SizedBox(
            height: 10,
          ),
          TextButton(
            style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.blue)),
            child: const Text(
              'Show Alert Dialog\nWith Custom Background Color',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            onPressed: () async {
              await DAlertDialog(
                backgroundColor: Colors.red.withValues(alpha: 0.5),
                blur: 0,
                title: const Text('Alert Dialog'),
                content: const Text(
                    'Wohoo.. This is ordinary AlertDialog with Custom Color background'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('You'),
                    onPressed: () {},
                  ),
                  TextButton(
                    child: const Text('Are'),
                    onPressed: () {},
                  ),
                  TextButton(
                    child: const Text('Awesome'),
                    onPressed: () {},
                  )
                ],
              ).show(context);
            },
          ),
          TextButton(
            style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.blue)),
            child: const Text(
              'Dialog Extension',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            onPressed: () async {
              await AlertDialog(
                title: const Text('Alert Dialog'),
                content: const Text(
                    'Wohoo.. This is ordinary AlertDialog with Blur background'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('You'),
                    onPressed: () {},
                  ),
                  TextButton(
                    child: const Text('Are'),
                    onPressed: () {},
                  ),
                  TextButton(
                    child: const Text('Awesome'),
                    onPressed: () {},
                  )
                ],
              ).show(context);
            },
          ),
          TextButton(
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.blue),
            ),
            child: const Text(
              'CupertinoDialog Extension',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              await CupertinoAlertDialog(
                title: const Text('Alert Dialog'),
                content: const Text(
                  'Wohoo.. This is ordinary AlertDialog with Blur background',
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('You'),
                    onPressed: () {},
                  ),
                  TextButton(
                    child: const Text('Are'),
                    onPressed: () {},
                  ),
                  TextButton(
                    child: const Text('Awesome'),
                    onPressed: () {},
                  )
                ],
              ).show(context);
            },
          ),
          TextButton(
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.blue),
            ),
            child: const Text(
              'ZoomDIALOG',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            onPressed: () async {
              await ZoomDialog(
                zoomScale: 5,
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(20),
                  child: const Text('Zoom me!'),
                ),
              ).show(context);
            },
          ),
        ],
      ),
    );
  }
}
