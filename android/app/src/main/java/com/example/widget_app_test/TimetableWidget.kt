package com.example.widget_app_test

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

class TimetableWidget : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            val widgetData = HomeWidgetPlugin.getData(context)
            val courseName = widgetData.getString("timetable_course_name", "Mathematics")
            val courseTime = widgetData.getString("timetable_course_time", "09:00 - 10:00")
            
            val views = RemoteViews(context.packageName, R.layout.timetable_widget).apply {
                setTextViewText(R.id.course_name, courseName)
                setTextViewText(R.id.course_time, courseTime)
            }

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }

    override fun onEnabled(context: Context) {
    }

    override fun onDisabled(context: Context) {
    }
}
