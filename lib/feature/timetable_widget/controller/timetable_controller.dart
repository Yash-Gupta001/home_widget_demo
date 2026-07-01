import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_widget/home_widget.dart';

class TimetableController extends GetxController with WidgetsBindingObserver {
  final Rx<CourseInfo?> currentCourse = Rx<CourseInfo?>(null);
  Timer? _timer;

  final String appGroupId = 'group.homeScreenApp';
  final String ioSWidgetName = "TimetableWidget";
  final String androidWidgetName = "TimetableWidget";
  final String courseNameKey = "timetable_course_name";
  final String courseTimeKey = "timetable_course_time";

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
