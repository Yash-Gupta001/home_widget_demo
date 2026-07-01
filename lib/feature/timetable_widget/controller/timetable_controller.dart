import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_widget/home_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimetableController extends GetxController with WidgetsBindingObserver {
  final Rx<CourseInfo?> currentCourse = Rx<CourseInfo?>(null);
  Timer? _timer;

  final String appGroupId = 'group.homeScreenApp';
  final String ioSWidgetName = "TimetableWidget";
  final String androidWidgetName = "TimetableWidget";
  final String courseNameKey = "timetable_course_name";
  final String courseTimeKey = "timetable_course_time";
  final String currentIndexKey = "timetable_current_index";

  final List<CourseInfo> timetable = [
    CourseInfo(name: 'Mathematics', time: '09:00 - 10:00'),
    CourseInfo(name: 'Physics', time: '10:00 - 11:00'),
    CourseInfo(name: 'Chemistry', time: '11:00 - 12:00'),
    CourseInfo(name: 'English', time: '12:00 - 01:00'),
    CourseInfo(name: 'Computer Science', time: '02:00 - 03:00'),
    CourseInfo(name: 'Biology', time: '03:00 - 04:00'),
  ];

  @override
  void onInit() {
    super.onInit();
    HomeWidget.setAppGroupId(appGroupId);
    WidgetsBinding.instance.addObserver(this);
    _loadCurrentCourse();
    _startTimer();
  }

  // Simple initialization
  static Future<void> initializeWorkManager() async {
    print('Initializing TimetableWorker with refresh button support...');
    HomeWidget.setAppGroupId('group.homeScreenApp');
    print('TimetableWorker initialized successfully');
  }

  // Simple periodic update (mainly for app open timer)
  static Future<void> schedulePeriodicUpdate() async {
    print('Setting up basic widget functionality...');
    await updateWidget(); // Update once when scheduled
    print('Widget functionality setup completed');
  }

  // Direct widget update method
  static Future<void> updateWidget() async {
    try {
      print('Updating widget...');
      HomeWidget.setAppGroupId('group.homeScreenApp');
      
      final prefs = await SharedPreferences.getInstance();
      int currentIndex = prefs.getInt('timetable_current_index') ?? 0;
      
      final nextIndex = (currentIndex + 1) % 6; // 6 courses
      final courses = ['Mathematics', 'Physics', 'Chemistry', 'English', 'Computer Science', 'Biology'];
      final times = ['09:00 - 10:00', '10:00 - 11:00', '11:00 - 12:00', '12:00 - 01:00', '02:00 - 03:00', '03:00 - 04:00'];
      
      print('Updating widget to: ${courses[nextIndex]} - ${times[nextIndex]}');
      
      await HomeWidget.saveWidgetData('timetable_course_name', courses[nextIndex]);
      await HomeWidget.saveWidgetData('timetable_course_time', times[nextIndex]);
      
      await HomeWidget.updateWidget(
        name: "TimetableWidget",
        androidName: "TimetableWidget",
      );
      
      await prefs.setInt('timetable_current_index', nextIndex);
      
      print('Widget updated successfully');
    } catch (e) {
      print('Error updating widget: $e');
    }
  }

  // Test method for direct widget update
  static Future<void> testWorkManager() async {
    print('Testing widget refresh...');
    await updateWidget();
  }

  @override
  void onClose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _updateCourse();
    });
  }

  
  Future<void> _loadCurrentCourse() async {
    final courseName = await HomeWidget.getWidgetData<String>(courseNameKey);
    final courseTime = await HomeWidget.getWidgetData<String>(courseTimeKey);

    if (courseName != null && courseTime != null) {
      currentCourse.value = CourseInfo(name: courseName, time: courseTime);
    } else {
      currentCourse.value = timetable[0];
      await _saveToWidget(currentCourse.value!);
    }
  }

  Future<void> _updateCourse() async {
    if (currentCourse.value == null) {
      currentCourse.value = timetable[0];
    } else {
      final currentIndex = timetable.indexWhere(
        (course) => course.name == currentCourse.value!.name,
      );
      final nextIndex = (currentIndex + 1) % timetable.length;
      currentCourse.value = timetable[nextIndex];
    }

    await _saveToWidget(currentCourse.value!);
  }

  Future<void> _saveToWidget(CourseInfo course) async {
    await HomeWidget.saveWidgetData(courseNameKey, course.name);
    await HomeWidget.saveWidgetData(courseTimeKey, course.time);

    await HomeWidget.updateWidget(
      name: ioSWidgetName,
      androidName: androidWidgetName,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadCurrentCourse();
    }
  }

  Future<void> manualRefresh() async {
    await _updateCourse();
  }
}

class CourseInfo {
  final String name;
  final String time;

  CourseInfo({required this.name, required this.time});
}
