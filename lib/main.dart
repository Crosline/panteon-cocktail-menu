import 'package:flutter/material.dart';
import 'package:panteon_cocktail_menu/models/bar_settings.dart';
import 'package:panteon_cocktail_menu/pages/onboarding_page.dart';

import 'controllers/firebase_controller.dart';
import 'controllers/sign_in_controller.dart';

import 'widgets/side_bar.dart';

final FirebaseController firebaseController = FirebaseController();
final SignInController signInController = SignInController();
late BarSettings barSettings;

bool isAdmin = false;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Panteon Cocktail',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
          brightness: Brightness.light,
          // overrides
          primary: Colors.blue,
          secondary: Colors.green
        ),
        useMaterial3: true,
      ),
      home: const OnboardingPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String title = "Menu";
  int _counter = 0;

  @override
  void initState() {

    if (!firebaseController.isInitialized) {
      var account = signInController.currentUser;
      firebaseController.initialize().then((_) async {
        bool isAdminAWAIT = await firebaseController.isUserAdmin(account?.email);
        BarSettings barSettingsAWAIT = await firebaseController.getBarSettings();

        setState(() {
          isAdmin = isAdminAWAIT;
          barSettings = barSettingsAWAIT;
          title = barSettings.title;
        });
      });
    }

    super.initState();
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      drawer: const SideBar(),
      appBar: AppBar(
        leading: SideBar.getCustomLeading(),
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
