package school.mero.lms

import android.content.Intent
import android.net.Uri
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import androidx.activity.viewModels
import com.google.android.exoplayer2.MediaItem
import com.google.android.exoplayer2.MediaMetadata
import com.google.android.exoplayer2.RenderersFactory
import com.google.android.exoplayer2.util.MimeTypes
import kotlinx.android.synthetic.main.activity_download_test.*
import school.mero.lms.courseCache.VideoCache
import school.mero.lms.courseCache.VideoCacheViewModel
import school.mero.lms.courseCache.VideoVideoCacheViewModel
import school.mero.lms.live.DemoUtil
import school.mero.lms.live.DownloadActivity
import school.mero.lms.live.DownloadTracker
import kotlin.random.Random

class DownloadTestActivity : AppCompatActivity() {

    var downloadTracker: DownloadTracker?= null ;

    private val videoCacheViewModel : VideoCacheViewModel by viewModels{
        VideoVideoCacheViewModel((application as Application).videoCacheRepo)
    }


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_download_test)

        var rand = Random(1)


        downloadTracker = Application.globalDownloadTracker;


        viewAll.setOnClickListener {

            var intent = Intent(this, DownloadActivity::class.java);
            startActivity(intent);
        }

        addDownload.setOnClickListener {








            var num = rand.nextInt(100)
            val url = "https://video.mero.school/science%2010/0.%20Introduction%20To%20Science%7C1.%20Introduction%20to%20course/master.m3u8";
            var token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJjb3Vyc2VfaWQiOiIxMyIsImNvdXJzZV9uYW1lIjoic2NpZW5jZSUyMDEwIiwiZXhwIjoxNjM3MTUxMjU4fQ.jfj39FQF0gno8VK8KSXTJy2rLbcAKr1HN7coA3Vs8LM";
            var title = "${num} Introduction to course"
            var thumbnail = "${num} https://mero.school/uploads/thumbnails/course_thumbnails/course_thumbnail_default_13.jpg?time=1621005843";
            var proxy = "https://lb.mero.school/api/v1/video/retrieve_path/2960022b-5e8a-4dd7-8e14-9b70d0705b20 $num"
            var duration ="https://lb.mero.school/api/v1/video/retrieve_path/2960022b-5e8a-4dd7-8e14-9b70d0705b20"
            var course = "Science 10"


            clickedDownload(url, token, title, thumbnail, proxy, duration, course);

        }

    }

    fun downloadStart(){

    }

    fun clickedDownload(url: String?, token:String?, title: String?, thumbnail:String? , proxy:String?, duration: String?, course: String?){

//        DemoUtil.updateHeaders(this@MainActivity, token, token);




        val uri = Uri.parse("$url");
        uri.let {

            val  mediaItemBuilder = MediaItem.Builder()
            mediaItemBuilder
                .setUri(it)
                .setMediaMetadata(
                    MediaMetadata.Builder()
                        .setTitle(title)
                    .build())
                .setMimeType(MimeTypes.APPLICATION_M3U8);

            val mediaItem =  mediaItemBuilder.build();

            val renderersFactory: RenderersFactory = DemoUtil.buildRenderersFactory( /* context= */
                this)





            downloadTracker?.startAutoDownload(mediaItem, renderersFactory,token);

//            downloadTracker?.toggleDownload(
//                supportFragmentManager, mediaItem, renderersFactory)


            val videoCache = VideoCache(it.toString())
            videoCache.title = "$title"
            videoCache.duration = "$duration"
            videoCache.thumbnail = "$thumbnail"
            videoCache.proxy = "$proxy"

            videoCacheViewModel.insertIntoDb(videoCache)


        }




    }


}