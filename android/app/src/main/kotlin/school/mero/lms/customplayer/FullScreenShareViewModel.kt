package school.mero.lms.customplayer

import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.google.android.exoplayer2.ui.AspectRatioFrameLayout




const val PAUSE = 1001
const val PLAY = 1002
const val CART = 1003

class FullScreenShareViewModel : ViewModel(){


    var isPlayerFullScreen : MutableLiveData<Boolean> = MutableLiveData();


    var playLInk: MutableLiveData<String> = MutableLiveData();

    var scaleModel: MutableLiveData<Int> = MutableLiveData();



    fun setFullScreen(isFull: Boolean){
        isPlayerFullScreen.postValue(isFull)
    }


    fun setScaleMode(mode: Int){
        scaleModel.postValue(mode)
    }



    fun postLInk(link:String){
        playLInk.postValue(link);
    }

    var actionIsNext : MutableLiveData<Boolean>  = MutableLiveData();







    fun selectIsNext(isNext: Boolean){
        actionIsNext.postValue(isNext);
    }





    var actionIsPause: MutableLiveData<Int> = MutableLiveData();

    fun selectAction(isPause: Int){
        actionIsPause.postValue(isPause)
    }


}