package school.mero.lms

//import android.view.WindowManager;

import android.content.Context
import android.content.Intent
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Bundle
import android.util.Base64
import android.util.Log
import android.view.WindowManager
import androidx.activity.viewModels
import androidx.annotation.NonNull;
import androidx.fragment.app.FragmentActivity
import com.google.android.exoplayer2.MediaItem
import com.google.android.exoplayer2.MediaMetadata
import com.google.android.exoplayer2.RenderersFactory
import com.google.android.exoplayer2.offline.Download
import com.google.android.exoplayer2.util.MimeTypes
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import com.webengage.sdk.android.Analytics
import com.webengage.sdk.android.WebEngage
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant;
import java.lang.Exception
import java.security.MessageDigest
import java.security.NoSuchAlgorithmException

import school.mero.lms.JSONSchemas.CourseSchema
import school.mero.lms.JSONSchemas.ValidCourse
import school.mero.lms.courseCache.VideoCache
import school.mero.lms.courseCache.VideoCacheDao
import school.mero.lms.courseCache.VideoCacheViewModel
import school.mero.lms.courseCache.VideoVideoCacheViewModel
import school.mero.lms.live.*
import java.text.SimpleDateFormat
import java.util.*


import java.util.HashMap




private const val TAG = "MainActivity";

class MainActivity: FlutterFragmentActivity() {

    private val NATIVE_CHANNEL = "native_channel";
    var downloadTracker: DownloadTracker ?= null ;

    var savingDialog: SavingDialog ? = null

    var weAnalytics: Analytics = WebEngage.get().analytics()

    private val videoCacheViewModel : VideoCacheViewModel by viewModels{
        VideoVideoCacheViewModel((application as Application).videoCacheRepo)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        savingDialog = SavingDialog(this);


//        downloadTracker = DemoUtil.getDownloadTracker(applicationContext);
        downloadTracker = Application.globalDownloadTracker;


        if(!BuildConfig.DEBUG){
            window.setFlags(
                WindowManager.LayoutParams.FLAG_SECURE,
                WindowManager.LayoutParams.FLAG_SECURE);
        }


        window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)



        downloadTracker?.addListener(object: DownloadTracker.Listener{
            override fun onDownloadsChanged(downloads: Download?) {

                downloads?.let {
                    if(it.state == Download.STATE_COMPLETED){
                        logDownloadComplete(it.request.uri.toString())
                    }
                }

            }

            override fun dismiss() {

            }

            override fun onDownloadsChanged() {

            }


        })


//        logDownloadComplete("https://video.mero.school/compulsory%20math%209/1.%20Course%20Introduction%20&%20Mark%20Distribution%7CClass%209%20Syllabus/master.m3u8")
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, NATIVE_CHANNEL).setMethodCallHandler(
            object : MethodChannel.MethodCallHandler {
                override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
                    if(call.method.equals("startDownload")) {

//                        savingDialog?.setMsg("please wait..");
//                        savingDialog?.show();


                        val url = call.argument<String>("url");
                        var token = call.argument<String>("token");
                        var title = call.argument<String>("lession_title");
                        var thumbnail = call.argument<String>("thumbnail");
                        var proxy = call.argument<String>("proxy");
                        var duration = call.argument<String>("duration");
                        var course = call.argument<String>("course");
                        var course_title = call.argument<String>("course_title");
                        var course_expiry = call.argument<String>("course_expiry_date");


                        clickedDownload(url, token, title, thumbnail, proxy, duration,"$course", course_expiry, course_title);

                    }
                    else if(call.method.equals("startDownloadActivity")){

                        val intent = Intent(this@MainActivity, DownloadActivity::class.java);
                        startActivity(intent);

                    }else if(call.method.equals("startDownloadTest")){

                        val intent = Intent(this@MainActivity, DownloadTestActivity::class.java);
                        startActivity(intent);

                    }else if(call.method.equals("checkDownload")){

                        val url = call.argument<String>("url");
                        val tracker = Application.globalDownloadTracker
                        val isDownloaded = tracker.isDownloadedUrl(Uri.parse(url));
                        result.success(isDownloaded)

                    }else if(call.method.equals("validCourse")){


                        var jsonString = call.argument<String>("validIds");
                        var gson = Gson();

                        var validCourses : List<ValidCourse> = gson.fromJson(jsonString, object : TypeToken<List<ValidCourse>>() {}.type)
                        val maps = HashMap<String, String>();

                        validCourses.forEach {
                            maps[it.course_id.toString()] = it.plan_exp_date.toString();
                        }

                        maps?.let {
                            removeTheInValidIdsOfflineData(maps);
                        }
                    }else if(call.method.equals("logEnrolled")){
                        val format = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'")
                        val orderPlacedAttributes: MutableMap<String, Any> = HashMap<String, Any>()

                        try {
                            val date: Date = format.parse("2017-10-06T09:27:37Z")
                            orderPlacedAttributes.put("Course Expiry", date)
                        } catch (e: Exception) {
                            e.printStackTrace()
                        }

                        weAnalytics.track("Course Enrolled", orderPlacedAttributes)
                    }
                }
            })


    }


    fun clickedDownload(url: String?, token:String?, title: String?, thumbnail:String? ,
                        proxy:String?,
                        duration: String?,
                        course: String?,
                        expiry: String?,
                        course_title : String?
    ){

//        DemoUtil.updateHeaders(this@MainActivity, token, token);


        var uri = Uri.parse("$url");
        uri.let {

            var  mediaItemBuilder = MediaItem.Builder()
            mediaItemBuilder
                .setUri(it)
                .setMediaMetadata(MediaMetadata
                    .Builder()
                    .setTitle(title)
                    .build())
                .setMimeType(MimeTypes.APPLICATION_M3U8);

            var mediaItem =  mediaItemBuilder.build();

            val renderersFactory: RenderersFactory = DemoUtil.buildRenderersFactory( /* context= */
                this)

            downloadTracker?.startAutoDownload(mediaItem, renderersFactory,token);

//            downloadTracker?.toggleDownload(
//                supportFragmentManager, mediaItem, renderersFactory)


            var videoCache = VideoCache(it.toString())
            videoCache.title = "$title"
            videoCache.duration = "$duration"
            videoCache.thumbnail = "$thumbnail"
            videoCache.proxy = "$proxy"
            videoCache.expiry = expiry?.toExpiryDate();
            videoCache.courseId = course?.toInt();
            videoCache.state = 7;



            var courseSchema = CourseSchema()
            courseSchema.id = course;
            courseSchema.title = "$course_title";

            videoCache.json = Gson().toJson(courseSchema)

            videoCacheViewModel.insertIntoDb(videoCache)


        }




    }




    fun downloadView(){

//        var  mediaItemBuilder = MediaItem.Builder()
//        mediaItemBuilder
//            .setUri(it)
//            .setMediaMetadata(MediaMetadata.Builder().setTitle(title).build())
//            .setMimeType(MimeTypes.APPLICATION_M3U8);

    }


    fun String.toExpiryDate(): Long {
        var result = 0L
        try{

            val myFormat = SimpleDateFormat("yyyy-MM-dd")
            val dateAfter = myFormat.parse(this)
            return dateAfter.time

        }catch (e: Exception){
            e.printStackTrace()
        }

        return  result;
    }


    fun Long.toExpiryDate(): String{

        var result = ""

        try{
            val date = Date(this)
            val format = SimpleDateFormat("yyyy-MM-dd")
            result =  format.format(date)
        }catch (e: Exception){
            e.printStackTrace()
        }
       return  result;
    }


    fun logDownloadComplete(url: String)
    {
        //getSingleItemRepo
        AppExecutors.getInstance().diskIO().execute {
            val database: DownlaodDatabase = (application as Application).database
            val dao: VideoCacheDao = database.videoCacheDao()

            var videoCache : VideoCache = dao.checkIfAlreadyFromUrl(url);
            val checkoutStartedAttributes: MutableMap<String, Any> = HashMap()



            checkoutStartedAttributes["url"] = videoCache.proxy.toString();

            videoCache.json?.let {
                var course: CourseSchema? = Gson().fromJson<CourseSchema>(it, CourseSchema::class.java);
                course?.let {
                    it.title?.let {
                        checkoutStartedAttributes["Course Name"] = it;
                    }

                }

            }

            checkoutStartedAttributes["Course Id"] = videoCache.courseId.toString()
            checkoutStartedAttributes["Expiry"] = videoCache.expiry.toString()
            checkoutStartedAttributes["Title"] = videoCache.title.toString()
            checkoutStartedAttributes["Expiry Date"] = videoCache.expiry?.toExpiryDate().toString()
            weAnalytics.track(
                "Download Completed",
                checkoutStartedAttributes,
                Analytics.Options().setHighReportingPriority(true)
            )


            Log.d("MainActiivty", "${checkoutStartedAttributes.toString()}");

        }
    }




    fun removeTheInValidIdsOfflineData(activeIds: HashMap<String, String>){

        AppExecutors.getInstance().diskIO().execute {
            val database: DownlaodDatabase = (application as Application).database
            val dao: VideoCacheDao = database.videoCacheDao()
            var list = dao.currentList

            list.forEach { videoCache->
                videoCache.courseId?.let {
                    id->

                    if(activeIds.containsKey(id.toString())){

                        var changed =activeIds.get(id.toString())?.toExpiryDate()

                        changed?.let {
                            dao.updateWithCourse(id, it);

                        }

                    }else{
                        Log.d("Exist", "False  $id")
//                        dao.deleteAllWithCourse(id)

                    }
                }

            }

        }
    }





    fun printHashKey(pContext: Context) {
        try {
            val info: PackageInfo = pContext.getPackageManager()
                .getPackageInfo(pContext.getPackageName(), PackageManager.GET_SIGNATURES)
            for (signature in info.signatures) {
                val md: MessageDigest = MessageDigest.getInstance("SHA")
                md.update(signature.toByteArray())
                val hashKey: String = String(Base64.encode(md.digest(), 0))
                Log.i(TAG, "printHashKey() Hash Key: $hashKey")
            }
        } catch (e: NoSuchAlgorithmException) {


            Log.e(TAG, "printHashKey()", e)
        } catch (e: Exception) {
            Log.e(TAG, "printHashKey()", e)
        }
    }

}
