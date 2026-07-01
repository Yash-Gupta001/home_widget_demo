package com.example.widget_app_test

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

class TimetableWidget : AppWidgetProvider() {
    
    companion object {
        const val ACTION_REFRESH = "com.example.widget_app_test.REFRESH"
    }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        
        if (ACTION_REFRESH == intent.action) {
            // Update the widget data when refresh is clicked
            val appWidgetManager = AppWidgetManager.getInstance(context)
            val appWidgetIds = appWidgetManager.getAppWidgetIds(
                ComponentName(context, TimetableWidget::class.java)
            )
            
            // Update widget data by cycling to next course
            val widgetData = HomeWidgetPlugin.getData(context)
            val currentCourseName = widgetData.getString("timetable_course_name", "Mathematics")
            
            val courses = arrayOf("Mathematics", "Physics", "Chemistry", "English", "Computer Science", "Biology")
            val times = arrayOf("09:00 - 10:00", "10:00 - 11:00", "11:00 - 12:00", "12:00 - 01:00", "02:00 - 03:00", "03:00 - 04:00")
            
            val currentIndex = courses.indexOf(currentCourseName)
            val nextIndex = if (currentIndex == -1 || currentIndex == courses.size - 1) 0 else currentIndex + 1
            
            val nextCourseName = courses[nextIndex]
            val nextCourseTime = times[nextIndex]
            
            // Save the new course data
            val editor = widgetData.edit()
            editor.putString("timetable_course_name", nextCourseName)
            editor.putString("timetable_course_time", nextCourseTime)
            editor.apply()
            
            // Update all widget instances
            for (appWidgetId in appWidgetIds) {
                updateWidget(context, appWidgetManager, appWidgetId)
            }
        }
    }

    private fun updateWidget(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int) {
        val widgetData = HomeWidgetPlugin.getData(context)
        val courseName = widgetData.getString("timetable_course_name", "Mathematics")
        val courseTime = widgetData.getString("timetable_course_time", "09:00 - 10:00")
        
        val views = RemoteViews(context.packageName, R.layout.timetable_widget).apply {
            setTextViewText(R.id.course_name, courseName)
            setTextViewText(R.id.course_time, courseTime)
            
            // Set up refresh button click handler
            val refreshIntent = Intent(context, TimetableWidget::class.java).apply {
                action = ACTION_REFRESH
            }
            val refreshPendingIntent = PendingIntent.getBroadcast(
                context, 
                0, 
                refreshIntent, 
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            setOnClickPendingIntent(R.id.refresh_button, refreshPendingIntent)
        }

        appWidgetManager.updateAppWidget(appWidgetId, views)
    }

    override fun onEnabled(context: Context) {
    }

    override fun onDisabled(context: Context) {
    }
}
