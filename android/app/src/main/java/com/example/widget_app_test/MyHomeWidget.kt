package com.example.widget_app_test

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

/**
 * Implementation of App Widget functionality.
 */
class MyHomeWidget : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        // There may be multiple widgets active, so update all of them
        for (appWidgetId in appWidgetIds) {
            // get data from flutter app
            val widgetData = HomeWidgetPlugin.getData(context);
            val currentCount = widgetData.getString("text_from_flutter", "Count = 0")
            
            val views = RemoteViews(context.packageName,R.layout.my_home_widget).apply{
                setTextViewText(R.id.text_id, currentCount)
                
                // Set up button click to increment counter
                val intent = Intent(context, MyHomeWidget::class.java).apply {
                    action = "INCREMENT_COUNTER"
                    putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
                }
                val pendingIntent = PendingIntent.getBroadcast(
                    context, 
                    appWidgetId, 
                    intent, 
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )
                setOnClickPendingIntent(R.id.increment_button, pendingIntent)
            }

            // update widget
            appWidgetManager.updateAppWidget(appWidgetId,views)
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        
        if (intent.action == "INCREMENT_COUNTER") {
            val appWidgetId = intent.getIntExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, -1)
            
            // Get current count
            val widgetData = HomeWidgetPlugin.getData(context)
            val currentText = widgetData.getString("text_from_flutter", "Count = 0") ?: "Count = 0"
            val currentCount = currentText.replace("Count = ", "").toIntOrNull() ?: 0
            
            // Increment and save
            val newCount = currentCount + 1
            val newText = "Count = $newCount"
            
            // Save to SharedPreferences
            val editor = widgetData.edit()
            editor.putString("text_from_flutter", newText)
            editor.apply()
            
            // Update widget
            val appWidgetManager = AppWidgetManager.getInstance(context)
            onUpdate(context, appWidgetManager, intArrayOf(appWidgetId))
        }
    }

    override fun onEnabled(context: Context) {
        // Enter relevant functionality for when the first widget is created
    }

    override fun onDisabled(context: Context) {
        // Enter relevant functionality for when the last widget is disabled
    }
}

// internal fun updateAppWidget(
//     context: Context,
//     appWidgetManager: AppWidgetManager,
//     appWidgetId: Int
// ) {
//     val widgetText = context.getString(R.string.appwidget_text)
//     // Construct the RemoteViews object
//     val views = RemoteViews(context.packageName, R.layout.my_home_widget)
//     views.setTextViewText(R.id.text_id, widgetText)

//     // Instruct the widget manager to update the widget
//     appWidgetManager.updateAppWidget(appWidgetId, views)
// }