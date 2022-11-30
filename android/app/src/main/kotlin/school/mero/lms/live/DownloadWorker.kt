//package school.mero.lms.live
//
//
//import android.content.Context
//import android.util.Log
//import androidx.work.ListenableWorker
//import androidx.work.Worker
//import androidx.work.WorkerParameters
//import com.google.android.exoplayer2.MediaItem
//import com.google.android.exoplayer2.MediaMetadata
//import com.google.android.exoplayer2.RenderersFactory
//import com.google.android.exoplayer2.util.MimeTypes
//import com.google.gson.Gson
//import school.mero.lms.Network.ServiceGenerator
//import school.mero.lms.Network.VideoService
//import school.mero.lms.Network.VideoServiceRP
//import school.mero.lms.application.MainApplication
//import school.mero.lms.courseCache.VideoCache
//
//
//class DownloadWorker(val appContext: Context, workerParams: WorkerParameters): Worker(appContext, workerParams) {
//
//    override fun doWork(): Result {
//
//        val  repo = (MainApplication).instance.videoCacheRepo
//
//
//
//        val title  = inputData.getString("title")
//        val duration  = inputData.getString("duration")
//        val thumbnail  = inputData.getString("thumbnail")
//        val proxy  = inputData.getString("proxy")
//        val json  = inputData.getString("json")
//        val courseId  = inputData.getString("courseId")
//        val extraToken  = inputData.getString("extraToken")
//        val expiryDate = inputData.getLong("expiryDate", 0L)
//        var url = ""
//
//
//        //check the proxi is in db
//
//
//
//        proxy?.let {
//
//           var data =  repo.checkIfAlreadyDownloaded(proxy)
//           data?.let {
//               //already exist the downloaded videos.
//
//
//               if(it.state == 2 || it.state == 3 ){
//
//                   //found aleady download
//                   return Result.failure()
//
//               }else{
//                   //do the need ful
//
//               }
//
//
//
//           }?: kotlin.run {
//               //didinot found int the repo
//               //do network request with proxy to get real link
//
//
//           }
//
//        }?: kotlin.run {
//            //no link found retrun to the list
//            return Result.failure()
//
//        }
//
//
//
//        var videoService = ServiceGenerator.createVideoService(VideoService::class.java);
//        var callBack = videoService.videoUrl(proxy).execute()
//        if(callBack.isSuccessful){
//            var body  = Gson().fromJson<VideoServiceRP>(callBack.body()?.string(), VideoServiceRP::class.java)
//            body?.let {
//                Log.d("DownloadWorker-->", "Retruned the Real link to download: " + it.videoUrl)
//                url = it.videoUrl + "/master.m3u8";
//
//
//
//
////                val  context = appContext.applicationContext
////                val cronetEngineWrapper = CronetEngineWrapper(context)
////                val httpDataSourceFactory = CronetDataSourceFactory(cronetEngineWrapper, Executors.newSingleThreadExecutor())
////                val map: MutableMap<String, String> = HashMap()
////                map["Authorization"] = "" + extraToken
////                httpDataSourceFactory.defaultRequestProperties.set(map)
////
//
//
//
//                //add to download queue
//                var  mediaItemBuilder = MediaItem.Builder()
//                mediaItemBuilder
//                        .setUri(url)
//                        .setMediaMetadata(MediaMetadata.Builder().setTitle(title).build())
//                        .setMimeType(MimeTypes.APPLICATION_M3U8);
//
//                var mediaItem =  mediaItemBuilder.build();
//                val renderersFactory: RenderersFactory = DemoUtil.buildRenderersFactory( /* context= */
//                        appContext)
//                var downloadTracker = DemoUtil.getDownloadTracker(appContext.applicationContext);
//                downloadTracker.startAutoDownload(mediaItem, renderersFactory, extraToken )
//
//
//                //insert to my db
//                var videoCache = VideoCache(url)
//                videoCache.title = title
//                videoCache.duration = duration
//                videoCache.thumbnail = thumbnail
//                videoCache.proxy = proxy
//                videoCache.json = json
//                videoCache.courseId = courseId?.toInt()
//                videoCache.state = 7
//                videoCache.expiry = expiryDate
//
//                repo.insertSingle(videoCache)
//
//
//
//            }
//        }else{
//            //failed to get the correct url
//            return Result.failure()
//
//        }
//
//
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