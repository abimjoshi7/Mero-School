package school.mero.lms.research

import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import java.io.Serializable

class VideoModel : Serializable{
    var type: String?= null
    var videoUrl: String ? = null
    var thumbnail: String ? = null
    var duration: String ? = null
    var title : String ? = null
    var videoUrlForMobile: String? = null
    var videoTypeForMobile: String ? = null

    var courseId: Int ? = null
    var token: String ? = null

    var idFromServer : String? =null

    var courseTitle: String ? = null

    var currentId: Int ? = null

    var enablenext: Boolean = true
    var enableprev : Boolean = true


    var expiry: Long ? = null
    var isLessonFree : String ? = ""

}


class ShareViewModel : ViewModel(){


    var videoModel  = MutableLiveData<VideoModel>()

    fun select(vm: VideoModel){
        videoModel.postValue(vm)
    }



}