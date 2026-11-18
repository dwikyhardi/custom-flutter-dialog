import 'dart:async';

import 'package:cupertino_ui/cupertino_ui.dart' as cupertino;
import 'package:d_dialog/d_dialog.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

const _transition = Duration(milliseconds: 600);

Future<BuildContext> _pumpHost(
  WidgetTester tester, {
  Brightness brightness = Brightness.light,
}) async {
  late BuildContext host;
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('id'),
      supportedLocales: const [Locale('en'), Locale('id')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      theme: ThemeData(
        brightness: brightness,
        colorSchemeSeed: Colors.teal,
        dialogTheme: const DialogThemeData(
          titleTextStyle: TextStyle(color: Colors.red, fontSize: 21),
          contentTextStyle: TextStyle(color: Colors.blue, fontSize: 17),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: Colors.orange),
        ),
      ),
      home: Builder(
        builder: (context) {
          host = context;
          return const Scaffold(body: Text('Host page'));
        },
      ),
    ),
  );
  await tester.pumpAndSettle();
  return host;
}

Widget _doneButton() => Builder(
  builder: (context) => TextButton(
    onPressed: () => Navigator.pop(context, 'done'),
    child: const Text('Done'),
  ),
);

Future<void> _finishRoute(WidgetTester tester) async {
  await tester.tap(find.text('Done'));
  await tester.pumpAndSettle();
  expect(find.text('Host page'), findsOneWidget);
  expect(tester.takeException(), isNull);
}

void main() {
  group('DDialog', () {
    for (final brightness in Brightness.values) {
      testWidgets(
        'inherits $brightness host styles and returns typed results',
        (tester) async {
          final host = await _pumpHost(tester, brightness: brightness);
          final result = DDialog(
            title: const Text('Title'),
            content: const Text('Content'),
            actions: [_doneButton()],
          ).show<String>(host);
          await tester.pumpAndSettle();

          expect(
            DefaultTextStyle.of(tester.element(find.text('Title'))).style.color,
            Colors.red,
          );
          expect(
            DefaultTextStyle.of(tester.element(find.text('Content')))
                .style
                .color,
            Colors.blue,
          );
          expect(
            DefaultTextStyle.of(tester.element(find.text('Done'))).style.color,
            Colors.orange,
          );
          expect(
            Theme.of(tester.element(find.text('Done'))).brightness,
            brightness,
          );

          await _finishRoute(tester);
          expect(await result, 'done');
        },
      );
    }
  });

  group('Dialog extensions', () {
    final dialogs = <String, Future<String?> Function(BuildContext)>{
      'Dialog': (context) => Dialog(child: _doneButton()).show<String>(context),
      'AlertDialog': (context) =>
          AlertDialog(actions: [_doneButton()]).show<String>(context),
      'SimpleDialog': (context) =>
          SimpleDialog(children: [_doneButton()]).show<String>(context),
      'DAlertDialog': (context) =>
          DAlertDialog(actions: [_doneButton()]).show<String>(context),
      'CupertinoAlertDialog': (context) => cupertino.CupertinoAlertDialog(
        actions: [
          Builder(
            builder: (context) => cupertino.CupertinoDialogAction(
              onPressed: () => Navigator.pop(context, 'done'),
              child: const Text('Done'),
            ),
          ),
        ],
      ).show<String>(context, barrierDismissible: true),
    };

    for (final entry in dialogs.entries) {
      testWidgets('${entry.key} uses localized routes and preserves results', (
        tester,
      ) async {
        final host = await _pumpHost(tester);
        final result = entry.value(host);
        await tester.pumpAndSettle();

        final barrier = tester.widgetList<ModalBarrier>(
          find.byType(ModalBarrier),
        );
        expect(
          barrier.any((widget) => widget.semanticsLabel == 'Tutup'),
          isTrue,
        );
        await _finishRoute(tester);
        expect(await result, 'done');
      });
    }

    testWidgets('barrier dismissal leaves the host navigator intact', (
      tester,
    ) async {
      final host = await _pumpHost(tester);
      final result = const AlertDialog(content: Text('Dismiss me'))
          .show<String>(host);
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(5, 5));
      await tester.pumpAndSettle();
      expect(await result, isNull);
      expect(find.text('Dismiss me'), findsNothing);
      expect(find.text('Host page'), findsOneWidget);
    });

    testWidgets('back dismissal leaves the host navigator intact', (
      tester,
    ) async {
      final host = await _pumpHost(tester);
      final result = const DAlertDialog(content: Text('Go back'))
          .show<void>(host);
      await tester.pumpAndSettle();
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      await result;
      expect(find.text('Go back'), findsNothing);
      expect(find.text('Host page'), findsOneWidget);
    });
  });

  group('ProgressDialog', () {
    testWidgets('inherits modern dialog styles and localizes cancel', (
      tester,
    ) async {
      final host = await _pumpHost(tester, brightness: Brightness.dark);
      var cancelled = 0;
      final dialog = ProgressDialog(
        host,
        title: const Text('Working'),
        message: const Text('Please wait'),
        onCancel: () => cancelled++,
      );
      dialog.show();
      await tester.pump();
      await tester.pump(_transition);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(
        DefaultTextStyle.of(tester.element(find.text('Working'))).style.color,
        Colors.red,
      );
      expect(find.text('Batal'), findsOneWidget);
      await tester.tap(find.text('Batal'));
      await tester.pumpAndSettle();
      expect(cancelled, 1);
      expect(find.text('Working'), findsNothing);
      expect(find.text('Host page'), findsOneWidget);
    });

    testWidgets('preserves explicit cancel text', (tester) async {
      final host = await _pumpHost(tester);
      final dialog = ProgressDialog(
        host,
        message: const Text('Please wait'),
        cancelText: const Text('Stop upload'),
        onCancel: () {},
      );
      dialog.show();
      await tester.pump();
      await tester.pump(_transition);
      expect(find.text('Stop upload'), findsOneWidget);
      await tester.tap(find.text('Stop upload'));
      await tester.pumpAndSettle();
      expect(find.text('Host page'), findsOneWidget);
    });
  });

  group('Cupertino-only host', () {
    for (final brightness in Brightness.values) {
      testWidgets('inherits $brightness theme and returns typed results', (
        tester,
      ) async {
        late BuildContext host;
        await tester.pumpWidget(
          cupertino.CupertinoApp(
            locale: const Locale('id'),
            supportedLocales: const [Locale('id')],
            localizationsDelegates:
                cupertino.GlobalCupertinoLocalizations.delegates,
            theme: cupertino.CupertinoThemeData(
              brightness: brightness,
              primaryColor: Colors.purple,
            ),
            home: Builder(
              builder: (context) {
                host = context;
                return const cupertino.CupertinoPageScaffold(
                  child: Text('Host page'),
                );
              },
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(
          Localizations.of<MaterialLocalizations>(host, MaterialLocalizations),
          isNull,
        );

        final result = cupertino.CupertinoAlertDialog(
          title: const Text('Cupertino title'),
          actions: [
            Builder(
              builder: (context) => cupertino.CupertinoDialogAction(
                onPressed: () => Navigator.pop(context, 'done'),
                child: const Text('Done'),
              ),
            ),
          ],
        ).show<String>(host);
        await tester.pumpAndSettle();
        final actionContext = tester.element(find.text('Done'));
        expect(
          cupertino.CupertinoTheme.of(actionContext).brightness,
          brightness,
        );
        expect(DefaultTextStyle.of(actionContext).style.color, Colors.purple);
        expect(
          tester
              .widgetList<ModalBarrier>(find.byType(ModalBarrier))
              .any((barrier) => barrier.semanticsLabel == 'Tutup'),
          isTrue,
        );
        await _finishRoute(tester);
        expect(await result, 'done');

        final customResult = DialogBackground(
          dialog: Center(
            child: Builder(
              builder: (context) => cupertino.CupertinoButton(
                onPressed: () => Navigator.pop(context, 'done'),
                child: const Text('Done'),
              ),
            ),
          ),
        ).show<String>(host);
        await tester.pumpAndSettle();
        expect(
          tester
              .widgetList<ModalBarrier>(find.byType(ModalBarrier))
              .any((barrier) => barrier.semanticsLabel == 'Tutup'),
          isTrue,
        );
        await _finishRoute(tester);
        expect(await customResult, 'done');

        var cancelled = false;
        ProgressDialog(
          host,
          message: const Text('Please wait'),
          onCancel: () => cancelled = true,
        ).show();
        await tester.pump();
        await tester.pump(_transition);
        expect(find.text('Batal'), findsOneWidget);
        await tester.tap(find.text('Batal'));
        await tester.pumpAndSettle();
        expect(cancelled, isTrue);
        expect(find.text('Please wait'), findsNothing);
        expect(find.text('Host page'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('Nested navigation', () {
    for (final useRootNavigator in [false, true]) {
      testWidgets('routes to root navigator: $useRootNavigator', (
        tester,
      ) async {
        final root = GlobalKey<NavigatorState>();
        final nested = GlobalKey<NavigatorState>();
        late BuildContext host;
        await tester.pumpWidget(
          MaterialApp(
            navigatorKey: root,
            home: Navigator(
              key: nested,
              onGenerateRoute: (_) => MaterialPageRoute<void>(
                builder: (context) {
                  host = context;
                  return const Scaffold(body: Text('Host page'));
                },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final result = AlertDialog(actions: [_doneButton()]).show<String>(
          host,
          useRootNavigator: useRootNavigator,
          routeSettings: const RouteSettings(name: '/dialog'),
        );
        await tester.pumpAndSettle();
        expect(root.currentState!.canPop(), useRootNavigator);
        expect(nested.currentState!.canPop(), !useRootNavigator);
        expect(
          ModalRoute.of(tester.element(find.text('Done')))!.settings.name,
          '/dialog',
        );
        await _finishRoute(tester);
        expect(await result, 'done');
        expect(root.currentState!.canPop(), isFalse);
        expect(nested.currentState!.canPop(), isFalse);
      });
    }
  });

  testWidgets('custom routes work under a plain WidgetsApp', (tester) async {
    late BuildContext host;
    await tester.pumpWidget(
      WidgetsApp(
        color: Colors.white,
        pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
          settings: settings,
          pageBuilder: (context, _, _) => builder(context),
        ),
        home: Builder(
          builder: (context) {
            host = context;
            return const Text('Host page');
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    final result = DialogUtils(
      child: const Center(child: Text('Custom content')),
    ).show<String>(host);
    await tester.pumpAndSettle();
    expect(find.text('Custom content'), findsOneWidget);
    expect(
      tester
          .widgetList<ModalBarrier>(find.byType(ModalBarrier))
          .any((barrier) => barrier.semanticsLabel == 'Dismiss'),
      isTrue,
    );
    await tester.tapAt(const Offset(5, 5));
    await tester.pumpAndSettle();
    expect(await result, isNull);
    expect(find.text('Host page'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  group('CustomProgressDialog', () {
    for (final custom in [false, true]) {
      testWidgets(
        'shows and dismisses ${custom ? 'custom' : 'default'} content',
        (tester) async {
          final host = await _pumpHost(tester, brightness: Brightness.dark);
          final primary = Theme.of(host).colorScheme.primary;
          final dialog = CustomProgressDialog(
            host,
            loadingWidget: custom
                ? Builder(
                    builder: (context) => Text(
                      'Loading',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  )
                : null,
          );
          dialog.show();
          await tester.pump();
          await tester.pump(_transition);

          if (custom) {
            expect(
              tester.widget<Text>(find.text('Loading')).style?.color,
              primary,
            );
          } else {
            final spinner = tester.element(
              find.byType(CircularProgressIndicator),
            );
            expect(Theme.of(spinner).colorScheme.primary, primary);
          }
          dialog.dismiss();
          await tester.pumpAndSettle();
          expect(find.byType(CircularProgressIndicator), findsNothing);
          expect(find.text('Loading'), findsNothing);
          expect(find.text('Host page'), findsOneWidget);
        },
      );
    }

    testWidgets('future completion returns data and removes the dialog', (
      tester,
    ) async {
      final host = await _pumpHost(tester);
      final completer = Completer<String>();
      final result = CustomProgressDialog.future<String>(
        host,
        future: completer.future,
        loadingWidget: const Text('Upload'),
      );
      await tester.pumpAndSettle();
      expect(find.text('Upload'), findsOneWidget);
      completer.complete('uploaded');
      await tester.pumpAndSettle();
      expect(await result, 'uploaded');
      expect(find.text('Upload'), findsNothing);
      expect(find.text('Host page'), findsOneWidget);
    });
  });
}
