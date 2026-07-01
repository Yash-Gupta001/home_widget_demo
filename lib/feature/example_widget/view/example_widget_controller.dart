import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/example_widget_controller.dart';

class ExampleWidgetView extends StatelessWidget {
  const ExampleWidgetView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ExampleWidgetController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: const Text("Counter Widget"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You have pushed the button this many times:'),
            Obx(
              () => Text(
                '${controller.counter.value}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
