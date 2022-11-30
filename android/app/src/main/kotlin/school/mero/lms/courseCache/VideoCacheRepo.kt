package school.mero.lms.courseCache

import android.app.Application
import androidx.annotation.WorkerThread
import androidx.lifecycle.LiveData
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.first


class VideoCacheRepo(val dao : VideoCacheDao) {
//    val allDownloads: LiveData<List<Downloads?>?>?
    val count: LiveData<Int?>?     = dao.countDownloads()



    val allDownloads: Flow<List<VideoCache>> = dao.allDownloads





    @Suppress("RedundantSuspendModifier")
    @WorkerThread
    suspend fun insert(down: VideoCache) {
        dao.insert(down)
    }


    fun insertSingle(down: VideoCache) {
        dao.insertSingle(down)
    }



    @Suppress("RedundantSuspendModifier")
    @WorkerThread
    suspend fun updateState(state: Int, url : String, percent: Double) {
        dao.updateState(state, url, percent)
    }



//    fun insert(notification: Downloads?) {
//        AppExecutors.getInstance().diskIO().execute { dao.insert(notification) }
//    }

    @Suppress("RedundantSuspendModifier")
    suspend fun getSingleDownload(url: String): VideoCache?{
        return dao.getSingleDownloads(url).first()
    }


    @Suppress("RedundantSuspendModifier")
     fun getSingleDownloadFlowable(url: String): LiveData<VideoCache>?{
        return dao.getSingleDownloadsLiveData(url)
    }


    @Suppress("RedundantSuspendModifier")
    fun checkIfAlreadyDownloaded(proxy: String): VideoCache?{
        return dao.checkIfAlreadyDownloaded(proxy)
    }



    @Suppress("RedundantSuspendModifier")
    @WorkerThread
    suspend fun deleteAll() {
        dao.deleteAll()
    }


    @Suppress("RedundantSuspendModifier")
    @WorkerThread
    suspend fun delete(down: VideoCache) {
        dao.delete(down)
    }




//    fun deleteAll() {
//        AppExecutors.getInstance().diskIO().execute { dao.deleteAll() }
//    }

    init {

    }
}