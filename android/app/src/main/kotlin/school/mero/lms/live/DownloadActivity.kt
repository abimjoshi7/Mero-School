package school.mero.lms.live

import android.Manifest
import android.content.DialogInterface
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.View
import android.widget.Toast
import androidx.activity.viewModels
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import androidx.recyclerview.widget.SimpleItemAnimator
import androidx.work.Data
import androidx.work.OneTimeWorkRequest
import androidx.work.WorkManager
import com.google.android.exoplayer2.MediaMetadata
import com.google.android.exoplayer2.offline.Download
import com.google.android.exoplayer2.offline.DownloadManager
import com.google.android.exoplayer2.scheduler.Requirements
import com.webengage.sdk.android.Analytics
import com.webengage.sdk.android.WebEngage
import kotlinx.android.synthetic.main.activity_download.*
import kotlinx.android.synthetic.main.activity_single_video.*
import kotlinx.android.synthetic.main.toolbar_with_delete.*
import kotlinx.android.synthetic.main.toolbar_with_refresh.*
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.Runnable
import pub.devrel.easypermissions.AfterPermissionGranted
import pub.devrel.easypermissions.EasyPermissions
import school.mero.lms.Application
import school.mero.lms.R
import school.mero.lms.courseCache.VideoCache
import school.mero.lms.courseCache.VideoCacheAdapter
import school.mero.lms.courseCache.VideoCacheViewModel
import school.mero.lms.courseCache.VideoVideoCacheViewModel
import school.mero.lms.research.SingleHlsVideoActivity
import school.mero.lms.research.VideoModel
import java.lang.Exception
import java.util.*
import kotlin.collections.ArrayList

const val  RC_STORAGE = 1002
const val  TAG = "DownloadTest"


class DownloadActivity : AppCompatActivity() {


//    var fetch: Fetch?  = null


    @AfterPermissionGranted(RC_STORAGE)
    private fun methodWithStoragePermission() {
        val perms = arrayOf<String>(Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.READ_EXTERNAL_STORAGE)
        if (EasyPermissions.hasPermissions(this, *perms)) {
            // Already have permission, do the thing
            // ...




        } else {
            // Do not have permissions, request them now
            EasyPermissions.requestPermissions(this, "Needed Storage Permission to save the downloaded file.",
                    RC_STORAGE, *perms)
        }
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == RC_STORAGE && grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
            methodWithStoragePermission()
        } else {
            Toast.makeText(this, "Permission Not available for storing video for offline.", Toast.LENGTH_SHORT).show()
        }
    }


    private val videoCacheViewModel : VideoCacheViewModel by viewModels{
        VideoVideoCacheViewModel((application as Application).videoCacheRepo)
    }


    fun handleBackButton(view: View?) {
        onBackPressed()
    }


    var downloadTracker : DownloadTracker ? =null


    var viewModelJob = Job()
    val uiScope = CoroutineScope(Dispatchers.Main + viewModelJob)

    var previousVideo : VideoModel ? = null

    var weAnalytics: Analytics = WebEngage.get().analytics()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_download)


        weAnalytics.screenNavigated("Download Page");


//        downloadTracker = DemoUtil.getDownloadTracker(applicationContext);
        downloadTracker = Application.globalDownloadTracker;



        var downloads =  downloadTracker?.downloads
        Log.d("DownloadSize","${downloads?.size}")




        downloads?.forEach {

            var key = it.key
            var download = it.value
            var percentDownloaded = download.percentDownloaded.toDouble()
            videoCacheViewModel.updateState(download.state, key.toString(), percentDownloaded)


        }

        val recyclerView = findViewById<RecyclerView>(R.id.recylerView)
        val adapter = VideoCacheAdapter()


        recyclerView.adapter = adapter
        recyclerView.layoutManager = LinearLayoutManager(this)




        downloadTracker?.addListener(object: DownloadTracker.Listener{
            override fun onDownloadsChanged() {


                Log.d("--Download", "onDownloadsChangded")
            }

            override fun onDownloadsChanged(downloads: Download?) {


                Log.d("--Download", "onDownloadsChanged ---")

                downloads?.let {
                    var key = downloads.request.uri
                    var percent = downloads.percentDownloaded.toDouble()




                    Log.d("DownloadSize","Here Update the status ${downloads.state} ${downloads.percentDownloaded} ${key}")

                    videoCacheViewModel.updateState(downloads.state, key.toString(), percent)
//                    adapter.notifyDataSetChanged()
                }



            }

            override fun dismiss() {

            }


        })


        supportActionBar?.title = getString(R.string.notifications)
        supportActionBar?.setDisplayHomeAsUpEnabled(true)


        (recyclerView.itemAnimator as SimpleItemAnimator).supportsChangeAnimations = false


        adapter.downloadStatusChange = object : VideoCacheAdapter.DownloadStatusChangesInterface{
            override fun updateProgress(downloads: VideoCache, pos: Int) {
                Log.d("Progress" , "on play video")




                var videoModel = VideoModel()
                videoModel.type = "bulk_videos"
                videoModel.title = downloads.title
                videoModel.videoUrl = downloads.url
                videoModel.thumbnail = downloads.thumbnail
                videoModel.duration = downloads.duration

                var intent = Intent(this@DownloadActivity, SingleHlsVideoActivity::class.java)
                intent.putExtra("videoModel", videoModel)
                this@DownloadActivity.startActivity(intent)


            }

            override fun delete(downloads: VideoCache, pos: Int) {


                val dialog = AlertDialog.Builder(this@DownloadActivity)
                        .setTitle(getString(R.string.app_name))
                        .setMessage("Are you sure remove it from cache ?")
                        .setPositiveButton("Remove", DialogInterface.OnClickListener { dialogInterface, i ->


                            Log.d("DownloadActivity","Trying to remove:  " + downloads.url);

                            DemoUtil.getDownloadManager(this@DownloadActivity).removeDownload(downloads.url)
                            videoCacheViewModel.deleteFromDb(downloads);





                            dialogInterface.dismiss()
                        })
                        .setNegativeButton("Cancel", DialogInterface.OnClickListener { dialogInterface, i ->
                            dialogInterface.dismiss()

                        })

                dialog.show()










            }

            override fun pause(downloads: VideoCache, pos: Int) {


            }


            override fun play(downloads: VideoCache, pos: Int) {



                Log.d("Progress" , "on play")

            }

            override fun refresh(videoCache: VideoCache, pos: Int) {


//               var vido =  downloadTracker?.downloads?.get(downloads.url)




//
//
//                val map = HashMap<String, Any>()
//                map["title"] = videoCache.title.toString()
//                map["duration"] = videoCache.duration.toString()
//                map["thumbnail"] = videoCache.thumbnail.toString()
//                map["proxy"] = videoCache.proxy.toString()
//                map["json"] = videoCache.json.toString()
//                map["courseId"] =videoCache.courseId.toString()
//                map["url"] =videoCache.url
//
//                //for lesson form section
////                                map["extraToken"] = lesson.extraToken
//
//                val data = Data.Builder().putAll(map)
//                        .build()
//                val work = OneTimeWorkRequest.Builder(RetryWorker::class.java)
//                        .setInputData(data)
//                        .build()
//                WorkManager.getInstance(applicationContext).beginWith(work).enqueue().result
//


            }
        }


        videoCacheViewModel.downloads.observe(this, androidx.lifecycle.Observer {
            dwons ->


            Log.d("SIze", "$dwons")
            adapter.submitList(dwons)


        })



        if(intent.hasExtra("VideoModel")){

            previousVideo = intent.getSerializableExtra("VideoModel") as VideoModel


        }



        imgDeleteAll.setOnClickListener {

            val dialog = AlertDialog.Builder(this@DownloadActivity)
                    .setTitle(getString(R.string.app_name))
                    .setMessage("Are you sure remove all video from Downloads ?")
                    .setPositiveButton("Remove", DialogInterface.OnClickListener { dialogInterface, i ->





                        adapter.currentList.forEach {

                            downloads ->
                            Log.d("DownloadActivity","Trying to remove:  " + downloads.url);

                            DemoUtil.getDownloadManager(this@DownloadActivity).removeDownload(downloads.url)
                            videoCacheViewModel.deleteFromDb(downloads);


                        }



                        DemoUtil.getDownloadManager(this@DownloadActivity).removeAllDownloads();




//                        DemoUtil.getDownloadManager(this@DownloadActivity).remov




                        dialogInterface.dismiss()
                    })
                    .setNegativeButton("Cancel", DialogInterface.OnClickListener { dialogInterface, i ->
                        dialogInterface.dismiss()

                    })

            dialog.show()




        }

//        imgRefresh.setOnClickListener {
//
//           refresh()
//
//        }



        runnable = Runnable {
            kotlin.run {
                refresh()
                runnable?.let {
                    handler.postDelayed(it, UPDATE_INTERVAL)
                }
            }
        }

    }

    val UPDATE_INTERVAL = 5000L

    val handler = Handler(Looper.getMainLooper())

    var runnable : Runnable ? = null


    override fun onResume() {
        super.onResume()
        runnable?.let { handler.postDelayed(it, UPDATE_INTERVAL) }
    }

    override fun onPause() {
        super.onPause()

        runnable?.let { handler.removeCallbacks(it) }
    }


    fun refresh(){
        var downloads =  downloadTracker?.downloads


        var isProgress = false;

        downloads?.forEach {

            var key = it.key
            var download = it.value

            if(download.state == Download.STATE_DOWNLOADING){

                isProgress = true;

                var percentDownloaded = download.percentDownloaded.toDouble()
                videoCacheViewModel.updateState(download.state, key.toString(), percentDownloaded)
            }

        }

        if(!isProgress){
            runnable?.let { handler.removeCallbacks(it) }
        }



    }








}