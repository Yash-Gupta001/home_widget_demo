import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/timetable_controller.dart';

class TimetableView extends StatelessWidget {
  const TimetableView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TimetableController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: const Text("Timetable Widget"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.manualRefresh,
            tooltip: 'Refresh',
          ),
          // IconButton(
          //   icon: const Icon(Icons.bug_report),
          //   onPressed: () async {
          //     await TimetableWorker.testWorkManager();
          //   },
          //   tooltip: 'Test Widget Update',
          // ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Obx(
            () => controller.currentCourse.value == null
                ? const CircularProgressIndicator()
                : Card(
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.school,
                            size: 64,
                            color: Colors.deepPurple,
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Current Course',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            controller.currentCourse.value!.name,
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.access_time, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                controller.currentCourse.value!.time,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Updates every 5 seconds when app is open',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
