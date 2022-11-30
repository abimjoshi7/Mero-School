package school.mero.lms

import android.app.Dialog
import android.content.Context
import android.view.Window
import android.view.WindowManager
import school.mero.lms.R
import kotlinx.android.synthetic.main.saving_layout.*

class SavingDialog(context: Context) : Dialog(context) {

    init {
        requestWindowFeature(Window.FEATURE_NO_TITLE)
        setContentView(R.layout.saving_layout)
        window!!.setLayout(
            WindowManager.LayoutParams.MATCH_PARENT,
            WindowManager.LayoutParams.WRAP_CONTENT
        )

        window!!.setBackgroundDrawableResource(android.R.color.transparent);
    }

    fun setMsg(msg :String)
    {
        txtMsg.text = msg
    }
}