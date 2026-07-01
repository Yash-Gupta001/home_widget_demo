import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  int _counter = 0;

  // home WIdget
  String appGroupId = 'group.homeScreenApp';
  String ioSWidgetName = "MyHomeWidget";
  String androidWidgetName = "MyHomeWidget";
  String dataKey = "text_from_flutter";

  @override
  void initState() {
    super.initState();
    // Initialize widget data
    HomeWidget.setAppGroupId(appGroupId);
    // Add lifecycle observer
    WidgetsBinding.instance.addObserver(this);
    // Load counter from widget data
    _loadCounter();
  }

  @override
  void dispose() {
    // Remove lifecycle observer
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Load counter value from widget storage
  Future<void> _loadCounter() async {
    try {
      final data = await HomeWidget.getWidgetData<String>(dataKey);
      if (data != null) {
        // Extract number from "Count = X" format
        final count = int.tryParse(data.replaceAll('Count = ', '')) ?? 0;
        setState(() {
          _counter = count;
        });
      }
    } catch (e) {
      print('Error loading counter: $e');
    }
  }

  void _incrementCounter() async {
    setState(() {
      _counter++;
    });

    // save data to widget
    String data = "Count = $_counter";
    await HomeWidget.saveWidgetData(dataKey, data);

    // update widget
    await HomeWidget.updateWidget(
      name: ioSWidgetName,
      androidName: androidWidgetName,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Reload counter when app comes back to foreground
      _loadCounter();
    }
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You have pushed the button this many times:'),
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
      ),
    );
  }
}
