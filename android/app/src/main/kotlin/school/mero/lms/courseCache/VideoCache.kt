package school.mero.lms.courseCache

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey
import org.jetbrains.annotations.NotNull


@Entity(tableName = "VideoCache")
data class VideoCache(@PrimaryKey
                @ColumnInfo(name = "url")
                val url: String) {

    @ColumnInfo(name = "title")
    var title: String? = null

    @ColumnInfo(name = "state")
    var state: Int? = null


    @ColumnInfo(name = "proxy")
    var proxy: String? = null


    @ColumnInfo(name = "duration")
    var duration: String? = null

    @ColumnInfo(name = "thumbnail")
    var thumbnail: String? = null

    @ColumnInfo(name = "json")
    var json: String? = null


    @ColumnInfo(name = "courseId")
    var courseId: Int? = null


    @ColumnInfo(name = "percent")
    var percent: Double? = null


    @ColumnInfo(name = "expiry")
    var expiry: Long ? = null






}