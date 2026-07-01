import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widget_app_test/feature/timetable_widget/view/timetable_view.dart';
import 'package:widget_app_test/feature/example_widget/view/example_widget_controller.dart';
import 'package:widget_app_test/feature/timetable_widget/controller/timetable_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print('=== App Starting ===');
  
  try {
    print('Initializing TimetableController...');
    await TimetableController.initializeWorkManager();
    print('TimetableController initialized successfully');
  } catch (e) {
    print('Error setting up TimetableController: $e');
  }
  
  print('Starting app...');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Home Widgets Demo'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.widgets, size: 80, color: Colors.deepPurple),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () {
                  Get.to(() => const ExampleWidgetView());
                },
                icon: const Icon(Icons.add_circle),
                label: const Text('Counter Widget'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  Get.to(() => const TimetableView());
                },
                icon: const Icon(Icons.schedule),
                label: const Text('Timetable Widget'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
