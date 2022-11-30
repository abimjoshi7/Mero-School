package school.mero.lms.courseCache

import android.app.Application
import androidx.lifecycle.*
import kotlinx.coroutines.Job
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.launch

class VideoCacheViewModel( val repo: VideoCacheRepo) : ViewModel() {



    var downloads: LiveData<List<VideoCache>> = repo.allDownloads.asLiveData()


    var count: LiveData<Int?>? = repo.count


     suspend fun getSingleItemRepo(url: String): VideoCache?{
         return repo.getSingleDownload(url)
     }


     fun getSingleItemRepoFlow(url: String): LiveData<VideoCache>?{
        return repo.getSingleDownloadFlowable(url)
    }


    fun checkAlreadyDownloaded(proxy: String): VideoCache?{
        return repo.checkIfAlreadyDownloaded(proxy)
    }



    fun insertIntoDb(download: VideoCache) = viewModelScope.launch {
        repo.insert(download)
    }



    fun updateState(state: Int, url : String, byteDownloaded: Double  ) = viewModelScope.launch {
        repo.updateState(state, url, byteDownloaded)
    }


//    fun getCurrentList(): List<VideoCache>{
//      return repo.getCurrentList()
//    }





    fun deleteAll() = viewModelScope.launch {
        repo.deleteAll()
    }

//    fun insertIntoDb(notification: Downloads) {
//        repo.insert(notification)
//    }

    fun deleteFromDb(notification: VideoCache) = viewModelScope.launch {
        repo.delete(notification)
    }


}


class VideoVideoCacheViewModel(private val repository: VideoCacheRepo) : ViewModelProvider.Factory {
    override fun <T : ViewModel> create(modelClass: Class<T>): T {
        if (modelClass.isAssignableFrom(VideoCacheViewModel::class.java)) {
            @Suppress("UNCHECKED_CAST")
            return VideoCacheViewModel(repository) as T
        }
        throw IllegalArgumentException("Unknown ViewModel class")
    }
}