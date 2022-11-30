//package school.mero.lms.live
//
//
//import android.content.Context
//import androidx.work.ListenableWorker
//import androidx.work.Worker
//import androidx.work.WorkerParameters
//import school.mero.lms.Application
//import school.mero.lms.JSONSchemas.UserSchema
//import school.mero.lms.Network.Api
//import school.mero.lms.Network.ServiceGenerator
//import school.mero.lms.application.KEY_USER
//import school.mero.lms.application.MainApplication
//import school.mero.lms.application.ModelPrefManager
//
//
//class RetryWorker(val appContext: Context, workerParams: WorkerParameters): Worker(appContext, workerParams) {
//
//    override fun doWork(): Result {
//
//        val  repo = (Application).instance.videoCacheRepo
//
//
//
//        val title  = inputData.getString("title")
//        val duration  = inputData.getString("duration")
//        val thumbnail  = inputData.getString("thumbnail")
//        val proxy  = inputData.getString("proxy")
//        val json  = inputData.getString("json")
//        val courseId  = inputData.getString("courseId")
//        var url = inputData.getString("url")
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
//        var authToken = ""
//
//        val user = ModelPrefManager.get<UserSchema>(KEY_USER)
//
//        user?.token?.let {
//            authToken = it
//        }
//
//        val api = ServiceGenerator.createRequest(Api::class.java)
//
//        courseId?.let {
//            var result = api.getCourseDetails(authToken, it).execute()
//            val courses = result.body()
//
//            courses?.let {
////
////                if(it.size > 0){
////                    var token  = it[0].encoded_token
////
////                    var  mediaItemBuilder = MediaItem.Builder()
////                    mediaItemBuilder
////                            .setUri(url)
////                            .setMediaMetadata(MediaMetadata.Builder().setTitle(title).build())
////                            .setMimeType(MimeTypes.APPLICATION_M3U8);
////
////                    var mediaItem =  mediaItemBuilder.build();
////                    val renderersFactory: RenderersFactory = DemoUtil.buildRenderersFactory( /* context= */
////                            appContext)
////                    var downloadTracker = DemoUtil.getDownloadTracker(appContext.applicationContext);
////                    downloadTracker.startAutoDownload(mediaItem, renderersFactory, token )
////
////
////                    //insert to my db
////                    var videoCache = VideoCache(url!!)
////                    videoCache.title = title
////                    videoCache.duration = duration
////                    videoCache.thumbnail = thumbnail
////                    videoCache.proxy = proxy
////                    videoCache.json = json
////                    videoCache.courseId = courseId.toInt()
////                    videoCache.state = 7
////
////                    repo.insertSingle(videoCache)
////
////
////                }
//
//            }
//
//
//        }
//
//
//
//
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