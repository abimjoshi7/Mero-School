package school.mero.lms.research

import android.content.pm.ActivityInfo
import android.net.Uri
import android.os.Bundle
import android.util.Log
import android.view.Gravity
import android.view.View
import android.view.WindowManager
import android.widget.FrameLayout
import android.widget.ImageView
import androidx.activity.viewModels
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.widget.PopupMenu
import androidx.core.content.ContextCompat
import androidx.lifecycle.Observer
import com.github.rubensousa.previewseekbar.exoplayer.PreviewTimeBar
import com.google.android.exoplayer2.*
import com.google.android.exoplayer2.source.DefaultMediaSourceFactory
import com.google.android.exoplayer2.source.MediaSourceFactory
import com.google.android.exoplayer2.trackselection.DefaultTrackSelector
import com.google.android.exoplayer2.ui.PlayerControlView
import com.google.android.exoplayer2.upstream.DataSource
import com.google.android.exoplayer2.util.MimeTypes
import com.google.gson.Gson
import com.webengage.sdk.android.Analytics
import com.webengage.sdk.android.WebEngage
import kotlinx.android.synthetic.main.activity_single_video.videoView
import kotlinx.android.synthetic.main.activity_single_video_hls.*
import school.mero.lms.Application
import school.mero.lms.JSONSchemas.CourseSchema
import school.mero.lms.R
import school.mero.lms.SHOW_SPRITES
import school.mero.lms.courseCache.TrackSelectionDialog
import school.mero.lms.courseCache.VideoCache
import school.mero.lms.courseCache.VideoCacheViewModel
import school.mero.lms.courseCache.VideoVideoCacheViewModel
import school.mero.lms.customplayer.exoplayer.ExoPlayerManager
import school.mero.lms.live.DemoUtil
import school.mero.lms.live.DownloadTracker
import java.lang.Exception
import java.text.SimpleDateFormat
import java.util.*
import javax.crypto.Cipher
import javax.crypto.spec.IvParameterSpec
import javax.crypto.spec.SecretKeySpec
import kotlin.collections.HashMap


class SingleHlsVideoActivity : AppCompatActivity() {


    var icDownload: ImageView? = null
    var icFullScreen: ImageView? = null
    var icSettings: ImageView? = null
//    var simpleExoPlayer: SimpleExoPlayer ? = null

    var videoModel : VideoModel ? =null

    var previewImageView: ImageView? = null
    var previewFrameLayout : FrameLayout ? = null

    var icNext : ImageView? = null
    var icPrev: ImageView ? = null

    var icSpeed : ImageView ? = null

    private var trackSelector: DefaultTrackSelector? = null
    private var trackSelectorParameters: DefaultTrackSelector.Parameters? = null
    private var isShowingTrackSelectionDialog = false


    private var downloadTracker: DownloadTracker? = null
    var currentUri : String ? = null

    var dataSourceFactory : DataSource.Factory ?=null


    private val videoCacheViewModel : VideoCacheViewModel by viewModels{
        VideoVideoCacheViewModel((application as Application).videoCacheRepo)
    }

    var weAnalytics: Analytics = WebEngage.get().analytics()


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_single_video_hls)


        window.setFlags(WindowManager.LayoutParams.FLAG_SECURE,
                WindowManager.LayoutParams.FLAG_SECURE);


        dataSourceFactory = DemoUtil.getDataSourceFactory( /* context= */this)

        //initialized download utils
        downloadTracker = DemoUtil.getDownloadTracker(applicationContext);


//        downloadTracker?.addListener {
//            Log.d("Listener", "Download Status changed")
//
//            currentUri?.let {
//                uri ->
////                downloadTracker?.getDownloadRequest(it)
//                var downloadStatus = downloadTracker?.downloads?.get(Uri.parse(uri))
//
//                downloadStatus?.let {
//                    videoCacheViewModel.updateState(downloadStatus.state, uri)
//                }
//
//            }
//        }
//        ///

        val builder = DefaultTrackSelector.ParametersBuilder( /* context= */this)
        trackSelectorParameters = builder.build()
        trackSelector = DefaultTrackSelector( /* context= */this)
        trackSelector?.setParameters(trackSelectorParameters!!)


        val mediaSourceFactory: MediaSourceFactory = DefaultMediaSourceFactory(dataSourceFactory!!)
                .setAdViewProvider(videoView)
        // 2. Create the player

        icFullScreen = videoView?.findViewById<ImageView>(R.id.exo_fullscreen_icon)
        icSettings = videoView?.findViewById<ImageView>(R.id.exo_settings)
        icDownload = videoView?.findViewById<ImageView>(R.id.exo_download)

        previewTimeBar = videoView?.findViewById(R.id.exo_progress)

        previewImageView = videoView?.findViewById(R.id.imageView);

        icPrev = videoView?.findViewById(R.id.exo_prv);
        icNext = videoView?.findViewById(R.id.exo_nxt);

        icNext?.visibility = View.GONE
        icPrev?.visibility = View.GONE
        icDownload?.visibility = View.GONE

        icSpeed = videoView?.findViewById(R.id.exo_speed);

        //        previewSeekBar = findViewById(R.id.previewSeekBar);
        exoPlayerManager = ExoPlayerManager(videoView, mediaSourceFactory, trackSelector, previewTimeBar,
                previewImageView, "https://17174.co/meroschool/videotest/sprite.jpg", object: PlayerControlView.VisibilityListener{
            override fun onVisibilityChange(visibility: Int) {

            }

        }){
            //it contains the state


        }//hardcorder thumbinal

        previewFrameLayout = videoView?.findViewById(R.id.previewFrameLayout);



        if(SHOW_SPRITES)
        {
            previewFrameLayout?.visibility = View.VISIBLE;
        }else{
            previewFrameLayout?.visibility = View.INVISIBLE;
        }

        icSettings?.visibility = View.GONE



        exoPlayerManager?.onStart();

        window.setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_FULLSCREEN);



         videoModel = intent.getSerializableExtra("videoModel") as VideoModel


        progressBar?.visibility = View.GONE

        videoModel?.videoUrl?.let {
            playWithBuffer(it)
            currentUri = it


            videoCacheViewModel.getSingleItemRepoFlow(it)?.observe(this, Observer {

                it?.let {

                    Log.d("VideoCache" , "${it.title} ${it.state}")


                    if(it.state == 3){

                        icDownload?.setImageResource(R.drawable.ic_baseline_offline_pin_24)
                        icDownload?.isEnabled = false

                    }else{

                        icDownload?.setImageResource(R.drawable.ic_download)
                        icDownload?.isEnabled = false
                    }





                    val checkoutStartedAttributes: MutableMap<String, Any> = HashMap()
                    checkoutStartedAttributes["url"] = it.proxy.toString()

                    it.json?.let {
                        var course: CourseSchema? = Gson().fromJson<CourseSchema>(it, CourseSchema::class.java);
                        course?.let {
                            it.title?.let {
                                checkoutStartedAttributes["Course Name"] = it;
                            }

                        }

                    }

                    checkoutStartedAttributes["Course Id"] = it.courseId.toString()
                    checkoutStartedAttributes["Expiry"] = it.expiry.toString()
                    checkoutStartedAttributes["Title"] = it.title.toString()
                    checkoutStartedAttributes["Expiry Date"] = it.expiry?.toExpiryDate().toString()
                    weAnalytics.track(
                        "Offline Video Started",
                        checkoutStartedAttributes,
                        Analytics.Options().setHighReportingPriority(true)
                    )


                }?: kotlin.run {

                    icDownload?.setImageResource(R.drawable.ic_download_white)
                    icDownload?.isEnabled = true

                }



            })
        }





        //service start

        // Start the download service if it should be running but it's not currently.
        // Starting the service in the foreground causes notification flicker if there is no scheduled
        // action. Starting it in the background throws an exception if the app is in the background too
        // (e.g. if device screen is locked).
//        try {
//            DownloadService.start(this, DemoDownloadService::class.java)
//        } catch (e: IllegalStateException) {
//            DownloadService.startForeground(this, DemoDownloadService::class.java)
//            e.printStackTrace()
//        }
//
//



        icFullScreen?.setOnClickListener {

            doLayout()


        }


        icSettings?.setOnClickListener {



            if(!isShowingTrackSelectionDialog
                    && TrackSelectionDialog.willHaveContent(trackSelector)){

                isShowingTrackSelectionDialog = true

                val trackSelectionDialog: TrackSelectionDialog = TrackSelectionDialog.createForTrackSelector(
                        trackSelector  /* onDismissListener= */
                ) {
                    isShowingTrackSelectionDialog = false
                }

                trackSelectionDialog.show(supportFragmentManager,  /* tag= */null)
            }


        }


        icDownload?.setOnClickListener {
            Log.d("Download", "Ready: ")


            videoModel?.let {
                it.title?.let { ttl ->

                    Log.d("Download", "Reached: $ttl ")

                    currentUri?.let {

                        clickedDownload(Uri.parse(currentUri), ttl)


                        var videoCache = VideoCache(it)

                        videoCache.title = ttl
                        videoCache.duration = videoCache.duration
                        videoCache.thumbnail = videoCache.thumbnail

                        videoCacheViewModel.insertIntoDb(videoCache)

                    }





                }
            }



        }



        //same exist in HlsVideoFragment
        icSpeed?.setOnClickListener {
            val popupMenu = PopupMenu(this, it, Gravity.TOP)
            popupMenu.inflate(R.menu.menuspeed)
            popupMenu.setOnMenuItemClickListener { item ->


                var speed = 1.0f

                when(item.itemId){

                    R.id.icVerySlow ->{

                        speed = 0.5f
                    }


                    R.id.icSlow -> {

                        speed = 0.25f
                    }


                    R.id.icNormal -> {

                        speed = 1.0f

                    }

                    R.id.icFast ->{

                        speed = 1.25f
                    }


                    R.id.icVeryFast ->{

                        speed = 1.5f
                    }


                }


                exoPlayerManager?.changeSpeed(speed)



                false
            }

            popupMenu.show();

        }







    }


    fun doLayout(){

        if(fullScreen){
            icFullScreen?.setImageDrawable(ContextCompat.getDrawable(this, R.drawable.ic_full_screen_white))

            requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_PORTRAIT;

            fullScreen = false

        }else{

            icFullScreen?.setImageDrawable(ContextCompat.getDrawable(this, R.drawable.ic_full_exit))
            requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE;


            fullScreen = true

        }

    }
    var mCipher: Cipher? = null
    var mSecretKeySpec: SecretKeySpec? = null
    var mIvParameterSpec: IvParameterSpec? = null


    var fullScreen = false;


    private var exoPlayerManager: ExoPlayerManager? = null
    private var previewTimeBar: PreviewTimeBar? = null

    fun playWithBuffer(uri: String)
    {


        Log.d("Uri", "$uri")




        // 2. Create the player
        var mediaItem = getMediaItem(Uri.parse(uri));
        exoPlayerManager?.play(mediaItem, uri)






    }



    override fun onPause() {
        super.onPause()
//        simpleExoPlayer?.setPlayWhenReady(false)
        exoPlayerManager?.onPause()

    }

    override fun onDestroy() {
//        simpleExoPlayer?.release(
//        )

        exoPlayerManager?.onStop()
        super.onDestroy()
    }


    override fun onBackPressed() {



        if(fullScreen){
            doLayout()
        }else{
            super.onBackPressed()

        }




    }

    fun clickedDownload(uri: Uri, title: String){


//
//        Log.d("clickedDownload", "$uri $title")
//
//        var  mediaItemBuilder = MediaItem.Builder()
//        mediaItemBuilder
//                .setUri(uri)
//                .setMediaMetadata(MediaMetadata.Builder().setTitle(title).build())
//                .setMimeType(MimeTypes.APPLICATION_M3U8);
//
//
//        var mediaItem =  mediaItemBuilder.build();
//
//        val renderersFactory: RenderersFactory = DemoUtil.buildRenderersFactory( /* context= */
//                this)
//        downloadTracker!!.toggleDownload(
//                supportFragmentManager, mediaItem, renderersFactory)




    }





    fun getMediaItem(uri: Uri): MediaItem{
        val downloadRequest = downloadTracker?.getDownloadRequest(uri)


        Log.d("DownloadReqest", ""+ uri.toString() + ":"+ downloadRequest?.id)


        if (downloadRequest != null) {

            Log.d("DownloadReqest", "Found cache")


            val builder: MediaItem.Builder = MediaItem.Builder()
                    .setUri(uri)
                    .setMimeType(MimeTypes.APPLICATION_M3U8);


            builder
                    .setMediaId(downloadRequest.id)
                    .setUri(downloadRequest.uri)
                    .setCustomCacheKey(downloadRequest.customCacheKey)
                    .setMimeType(downloadRequest.mimeType)
                    .setStreamKeys(downloadRequest.streamKeys)


            return builder.build()

        } else {
            Log.d("DownloadReqest", "Cache NOt found")




            val builder: MediaItem.Builder = MediaItem.Builder()
                    .setUri(uri)
                    .setMimeType(MimeTypes.APPLICATION_M3U8)

            ;



            return  builder.build()


        }

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


}