package school.mero.lms.courseCache

import android.graphics.Color
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.appcompat.widget.AppCompatImageView
import androidx.core.content.ContextCompat
import androidx.recyclerview.widget.DiffUtil
import androidx.recyclerview.widget.ListAdapter
import androidx.recyclerview.widget.RecyclerView
import com.google.android.exoplayer2.offline.Download
import com.google.gson.Gson
import kotlinx.android.synthetic.main.single_item_downloads.view.*
import school.mero.lms.JSONSchemas.CourseSchema
import school.mero.lms.R
import school.mero.lms.toFixed2Digit
import java.lang.Exception
import java.text.SimpleDateFormat
import java.util.*

class   VideoCacheAdapter : ListAdapter<VideoCache, VideoCacheAdapter.DownloadViewHolder>(VideoCacheComparator()) {

    public var downloadStatusChange : DownloadStatusChangesInterface ?= null

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): DownloadViewHolder {
        return DownloadViewHolder.create(parent, downloadStatusChange)
    }


    class DownloadViewHolder(itemView: View, clickListener: DownloadStatusChangesInterface?) : RecyclerView.ViewHolder(itemView) {

        private val txtTitle: TextView = itemView.findViewById(R.id.txtTitle)
        private val txtSubtitle: TextView = itemView.findViewById(R.id.txtSubtitle)
        private val txtDuration: TextView = itemView.findViewById(R.id.txtDuration)

        private val statusTextView : TextView = itemView.findViewById(R.id.txtStatus)
        private val icPlay : AppCompatImageView = itemView.findViewById(R.id.icPlay)
        private val icPause : AppCompatImageView = itemView.findViewById(R.id.icPause)
        private val icStop : AppCompatImageView = itemView.findViewById(R.id.icStop)
        private val icRefresh : AppCompatImageView = itemView.findViewById(R.id.icRefresh)

        var data : VideoCache? = null
        init {

            itemView.setOnClickListener {

                clickListener?.let {
                    data?.let {


//                        clickListener.updateProgress(it, adapterPosition)


                        if(data?.state == 3){
                            clickListener.updateProgress(it, adapterPosition)

                        }

                    }
                }
            }


            itemView.icStop.setOnClickListener  {

                clickListener?.let {
                    data?.let {
                        clickListener.delete(it,adapterPosition)
                    }
                }

            }


            itemView.icPlay.setOnClickListener  {

                clickListener?.let {
                    data?.let {


                        if(it.state!= 8){
                            clickListener.play(it,adapterPosition)
                        }


                    }
                }

            }


            itemView.icPause.setOnClickListener  {

                clickListener?.let {
                    data?.let {
                        clickListener.pause(it,adapterPosition)
                    }
                }

            }


            itemView.icRefresh.setOnClickListener {

                clickListener?.let {
                    data?.let {
                        clickListener.refresh(it,adapterPosition)
                    }
                }

            }

        }



        fun getStateName(state : Int?, percent: Double?): String{
            return when(state){

                0-> "QUEUED";
                1-> "STOPPED";
                2-> "DOWNLOADING....${percent?.toFixed2Digit()}%";
                3-> "COMPLETED";
                4-> "FAILED";
                5-> "REMOVING";
                6-> "RESTARTING";
                7-> "WAITING"
                8-> "EXPIRED"
                else -> {
                    "N/A"
                }
            }


        }

        fun bind(downloads: VideoCache) {

            Log.d("Value", "on bind  Called")


            var exp =  downloads.expiry


            Log.d("ExpDate", "Exp Date: "+ exp)




            var changed = Calendar.getInstance();
            changed.set(Calendar.HOUR_OF_DAY, 0);
            changed.set(Calendar.MINUTE, 0);
            changed.set(Calendar.SECOND, 0);
            changed.set(Calendar.MILLISECOND, 0);


            var now  = changed.time.time;


            exp?.let {
                if(now > exp){
                    downloads.state = 8
                }
            }


            Log.d("Exp", "exp $exp");

            if(exp == null)
            {
                downloads.state = 2
            }


            data= downloads





            txtSubtitle.text = downloads.title?.trim()
            statusTextView.text = getStateName(downloads.state, downloads.percent)
            txtDuration.text = downloads.duration?.trim()




            if(downloads.state == 8 || downloads.state == 4) {
                statusTextView.setTextColor(Color.parseColor("#F65053"));
            }else if(downloads.state == 3){
                statusTextView.setTextColor(Color.parseColor("#29D0A8"));
            }else if(downloads.state == 2){
                statusTextView.setTextColor(Color.parseColor("#1c68bf"));
            }else{
                statusTextView.setTextColor(Color.GRAY)
            }

            downloads.json?.let {
                var course: CourseSchema? = Gson().fromJson<CourseSchema>(it, CourseSchema::class.java);
                course?.let {
                    it.title?.let {
                        txtTitle.text = it
                    }

                }

            }

            if(downloads.state == Download.STATE_FAILED){
                icRefresh.visibility = View.VISIBLE
            }else
            {
                icRefresh.visibility = View.GONE
            }

            icRefresh.visibility = View.GONE



            if(downloads.state== Download.STATE_COMPLETED){

                icPause.visibility= View.GONE
                icPlay.visibility =View.GONE

                icStop.setImageDrawable(ContextCompat.getDrawable(itemView.context, R.drawable.ic_delete_white));

            }else{
//                icPause.visibility= View.VISIBLE
////                icPlay.visibility =View.VISIBLE

                icPause.visibility= View.GONE
                icPlay.visibility =View.GONE
                icStop.setImageDrawable(ContextCompat.getDrawable(itemView.context, R.drawable.ic_delete_white));


            }

//            downloads.total?.let {
//                t->
//
//                downloads.downloaded?.let {
//                    d->
//
//                    var p = d.toDouble()/t.toDouble() * 100
//
//
//                    progressTextView.setText("$p %")
//
//                }
//
//            }


//            progressTextView.setText("${downloads.downloaded} of ${downloads.total} ")

        }

        companion object {

            fun create(parent: ViewGroup, clickListener: DownloadStatusChangesInterface?): DownloadViewHolder {
                val view: View = LayoutInflater.from(parent.context)
                        .inflate(R.layout.single_item_downloads, parent, false)
                return DownloadViewHolder(view, clickListener)
            }
        }
    }

    class VideoCacheComparator : DiffUtil.ItemCallback<VideoCache>() {

        override fun areItemsTheSame(oldItem: VideoCache, newItem: VideoCache): Boolean {


            Log.d("Value", "are ITemSame :: ${oldItem.url == newItem.url}")
            return oldItem.url== newItem.url
        }

        override fun areContentsTheSame(oldItem: VideoCache, newItem: VideoCache): Boolean {

            return oldItem.url == newItem.url && oldItem.percent == newItem.percent && oldItem.state == newItem.state && oldItem.title == newItem.title && oldItem.json == newItem.json
        }
    }

    override fun onBindViewHolder(holder: DownloadViewHolder, position: Int) {
        val current = getItem(position)
        holder.bind(current)
    }


    fun String.toExpiryDate(): Long {
        var result = 0L
        try{

            val myFormat = SimpleDateFormat("yyyy-MM-dd")
            val dateAfter = myFormat.parse(this)
            return dateAfter.time

        }catch (e: Exception){
            e.printStackTrace()
        }

        return  result;
    }

    interface DownloadStatusChangesInterface{

        fun updateProgress(downloads: VideoCache,pos: Int )
        fun delete(downloads: VideoCache, pos: Int )

        fun play(downloads: VideoCache, pos: Int )
        fun pause(downloads: VideoCache, pos: Int )

        fun refresh(downloads: VideoCache, pos: Int)

    }


    // STATE_QUEUED,
    //    STATE_STOPPED,
    //    STATE_DOWNLOADING,
    //    STATE_COMPLETED,
    //    STATE_FAILED,
    //    STATE_REMOVING,
    //    STATE_RESTARTING

}