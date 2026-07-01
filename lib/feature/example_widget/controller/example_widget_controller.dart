import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_widget/home_widget.dart';

class ExampleWidgetController extends GetxController
    with WidgetsBindingObserver {
  final RxInt counter = 0.obs;

  final String appGroupId = 'group.homeScreenApp';
  final String ioSWidgetName = "MyHomeWidget";
  final String androidWidgetName = "MyHomeWidget";
  final String dataKey = "text_from_flutter";

  @override
  void onInit() {
    super.onInit();
    HomeWidget.setAppGroupId(appGroupId);
    WidgetsBinding.instance.addObserver(this);
    _loadCounter();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  Future<void> _loadCounter() async {
    try {
      final data = await HomeWidget.getWidgetData<String>(dataKey);
      if (data != null) {
        final count = int.tryParse(data.replaceAll('Count = ', '')) ?? 0;
        counter.value = count;
      }
    } catch (e) {
      print('Error loading counter: $e');
    }
  }

  Future<void> incrementCounter() async {
    counter.value++;

    String data = "Count = ${counter.value}";
    await HomeWidget.saveWidgetData(dataKey, data);

    await HomeWidget.updateWidget(
      name: ioSWidgetName,
      androidName: androidWidgetName,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadCounter();
    }
  }
}
