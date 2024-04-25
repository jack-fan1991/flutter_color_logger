import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:color_logging/color_logging.dart';

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.listenOnColorLogger(
    stackTracking: true,
    kIsWeb: true,
    levelColors: {
      Level.WARNING: AnsiColor.fg(214),
    },
  );
  // AnsiColor.showColor();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Logger logger = Logger("MyApp");
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    logger.finest("finest");
    logger.finer("finer");
    logger.fine("fine");
    logger.info("info");
    logger.warning("warning");
    logger.severe("severe\n\nsevere\nsevere");
    logger.logPrettyMap({
      "glossary": {
        "title": "example glossary",
        "GlossDiv": {
          "title": "S",
          "GlossList": {
            "GlossEntry": {
              "ID": "SGML",
              "SortAs": "SGML",
              "GlossTerm": "Standard Generalized Markup Language",
              "Acronym": "SGML",
              "Abbrev": "ISO 8879:1986",
              "GlossDef": {
                "para":
                    "A meta-markup language, used to create markup languages such as DocBook.",
                "GlossSeeAlso": ["GML", "XML"]
              },
              "GlossSee": "markup"
            }
          }
        }
      }
    });

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
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
