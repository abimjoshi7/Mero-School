//package school.mero.lms.live
//
//
//import android.app.NotificationManager
//import android.app.PendingIntent
//import android.app.TaskStackBuilder
//import android.content.Context
//import android.content.Intent
//import android.graphics.Color
//import androidx.core.app.NotificationCompat
//import androidx.core.app.NotificationManagerCompat
//import androidx.work.ListenableWorker
//import androidx.work.Worker
//import androidx.work.WorkerParameters
//import com.bumptech.glide.Glide
//import school.mero.lms.Activities.ScrollingCourseDetailsActivity
//import school.mero.lms.R
//import school.mero.lms.notificationPck.*
//import java.util.*
//
//
//class NotificationPrepareWorker(val appContext: Context, workerParams: WorkerParameters): Worker(appContext, workerParams) {
//
//    override fun doWork(): Result {
//
//
//
//        //parse data
//        val notification = Notification()
//        val calendar = Calendar.getInstance()
//        notification.notificationArrivalTimeInMillis = calendar.timeInMillis
//
//
//
//
//        notification.title = inputData.getString("title")
//        notification.body =  inputData.getString("body")
//
//
//        if(inputData.hasKeyWithValueOfType("type", String::class.java)){
//            notification.type  = inputData.getString("type")
//        }
//
//        if(inputData.hasKeyWithValueOfType("itemId", String::class.java)){
//            notification.itemId = inputData.getString("itemId")
//        }
//
//
//        if(inputData.hasKeyWithValueOfType("json", String::class.java)){
//            val phrase =  inputData.getString("json")
//            notification.phrase = phrase
//        }
//
//
//        if(inputData.hasKeyWithValueOfType("icon", String::class.java)) {
//            val userProfile = inputData.getString("icon")
//            notification.userProfile = userProfile
//        }
//
//        notification.status = "Unread"
//
//
//
//
//        //insert to db
//        AppExecutors.getInstance().diskIO().execute(Runnable {
//            val database: AppDatabase = AppDatabase.getDatabase(applicationContext)
//            val dao: NotificationDao = database.notificationDao()
//            dao.insert(notification)
//        })
//
//
//
//        //create notification
//
//        val builder = NotificationCompat.Builder(appContext, "MeroSchool")
//                .setSmallIcon(R.drawable.ic_stat_name)
//                .setColor(Color.parseColor("#6A0002"))
//                .setContentTitle(notification.title)
//                .setContentText(notification.body)
//                .setPriority(NotificationCompat.PRIORITY_HIGH)
//                // Set the intent that will fire when the user taps the notification
//                .setAutoCancel(true)
//
//
//        notification.userProfile?.let {
//            builder.apply {
//
//                try {
//                    val futureBitmap =  Glide.with(applicationContext)
//                             .asBitmap()
//                             .load(notification.userProfile)
//                             .submit();
//
//                    val bitmap = futureBitmap.get()
//                    this.setStyle(NotificationCompat.BigPictureStyle()
//                            .bigPicture(bitmap)
//                    )
//
//                } catch (e: Exception) {
//                    e.printStackTrace()
//                }
//
//            }
//        }
//
//
//
//
//        //check if the special case like course etc.
//        var isHandled = false
//
//
//        var rand = java.util.Random()
//
//
//        notification.itemId?.let {
//            id ->
//
//            notification.type?.let {
//
//                if(it.equals("course", ignoreCase = true)){
//
//                    isHandled =true
//
//
//                    val resultIntent = Intent(appContext, ScrollingCourseDetailsActivity::class.java)
//                    resultIntent.putExtra("courseId", notification.itemId.toString())
//
//                    val resultPendingIntent: PendingIntent? = TaskStackBuilder.create(appContext).run {
//                        // Add the intent, which inflates the back stack
//
//
//                        addNextIntentWithParentStack(resultIntent)
//                        // Get the PendingIntent containing the entire back stack
//                        getPendingIntent(0, PendingIntent.FLAG_UPDATE_CURRENT)
//                    }
//
//
//
//                    builder.apply {
//                        setContentIntent(resultPendingIntent)
//
//                    }
//
//                }
//            }
//        }
//
//
//
//        if(!isHandled){
//
//
//            val resultIntent = Intent(appContext, NotificationListActivity::class.java)
//
//            val resultPendingIntent: PendingIntent? = TaskStackBuilder.create(appContext).run {
//                // Add the intent, which inflates the back stack
//                addNextIntentWithParentStack(resultIntent)
//                // Get the PendingIntent containing the entire back stack
//                getPendingIntent(0, PendingIntent.FLAG_UPDATE_CURRENT)
//            }
//
//
//
//            builder.apply {
//                setContentIntent(resultPendingIntent)
//
//            }
//        }
//
//
//
//        //publish the notification
//        val notificationManager: NotificationManager =
//                appContext.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
//
//        with(NotificationManagerCompat.from(appContext)) {
//            notificationManager.notify(rand.nextInt(), builder.build())
//        }
//
//
//
//
//
//        return ListenableWorker.Result.success()
//    }
//
//
//}