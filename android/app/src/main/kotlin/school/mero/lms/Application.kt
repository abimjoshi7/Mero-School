package school.mero.lms

import android.content.ContentValues
import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingBackgroundService


import com.webengage.webengage_plugin.WebengageInitializer;
import com.webengage.sdk.android.WebEngageConfig;
import com.webengage.sdk.android.WebEngage;
import com.webengage.sdk.android.WebEngageActivityLifeCycleCallbacks;
import com.webengage.sdk.android.LocationTrackingStrategy;
import android.content.ContentValues.TAG


import com.google.android.gms.tasks.Task;
import com.google.firebase.messaging.FirebaseMessaging;
import com.google.android.gms.tasks.OnCompleteListener;
import androidx.annotation.NonNull;


import com.google.android.gms.tasks.OnSuccessListener;

import android.util.Log
import school.mero.lms.courseCache.VideoCacheRepo
import school.mero.lms.live.DemoUtil
import school.mero.lms.live.DownlaodDatabase
import school.mero.lms.live.DownloadTracker


class Application : FlutterApplication(), PluginRegistrantCallback {




    companion object {
//        lateinit var instance: Application private set
        lateinit var globalDownloadTracker: DownloadTracker private set

//        lateinit var _sslSocketFactory: SSLSocketFactory
    }

    val database by lazy { DownlaodDatabase.getDatabase(this) }
    val videoCacheRepo by lazy { VideoCacheRepo(database.videoCacheDao()) }


    override fun onCreate() {
        super.onCreate()
        globalDownloadTracker =  DemoUtil.getDownloadTracker(applicationContext);

//        FlutterFirebaseMessagingBackgroundService.setPluginRegistrant(this);




        //initialize web engage

        //        311c4c57
//        production: 311c4c57
//        stagin: aa131c65


      //demo
//    var webEngageKey = "aa131c65"
//    var isDevelopment = true;

        //live
    var webEngageKey = "311c4c57"
    var isDevelopment = false;



//        if(BuildConfig.DEBUG){
//            webEngageKey = "aa131c65"
//            isDevelopment = true;
//        }else{
//            webEngageKey = "311c4c57"
//        }


        val webEngageConfig: WebEngageConfig = WebEngageConfig.Builder()
                .setWebEngageKey(webEngageKey) //aa131c65
                .setAutoGCMRegistrationFlag(false)
                .setLocationTrackingStrategy(LocationTrackingStrategy.ACCURACY_BEST)
                .setDebugMode(isDevelopment) // only in development mode
                .build()
        WebengageInitializer.initialize(this, webEngageConfig)



        FirebaseMessaging.getInstance().token.addOnCompleteListener {

            if(!it.isSuccessful){
                Log.w(TAG, "Fetching FCM registration token failed brutally", it.getException())
                return@addOnCompleteListener;
            }

            var token = it.result
            WebEngage.get().setRegistrationID(token); //push in the webengage

        }


    }

//    override fun registerWith(registry: PluginRegistry) {
//        GeneratedPluginRegistrant.registerWith(registry);
//    }
    override fun registerWith(registry: PluginRegistry) {
                 registry?.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin");
    }
}