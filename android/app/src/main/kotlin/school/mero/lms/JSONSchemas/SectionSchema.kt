package school.mero.lms.JSONSchemas

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey
import com.google.gson.annotations.SerializedName
import java.io.Serializable

@Entity(tableName = "SectionSchema")
class SectionSchema: Serializable {
    @PrimaryKey
    @ColumnInfo(name = "id")
    var id: Int = 0

    @ColumnInfo(name = "title")
    var title: String? = null

    @ColumnInfo(name = "course_id")
    var course_id: Int? = null

    @ColumnInfo(name = "order")
    var order: Int? = null

    @ColumnInfo(name = "lessons")
    var lessons: List<LessonSchema>? = null

    @ColumnInfo(name = "completed_lesson_number")
    var completed_lesson_number: Int = 0

    @ColumnInfo(name = "user_validity")
    var user_validity: Boolean? = null

    @ColumnInfo(name = "total_duration")
    var total_duration: String? = null

    @ColumnInfo(name = "lesson_counter_starts")
    var lesson_counter_starts: Int = 0

    @ColumnInfo(name = "lesson_counter_ends")
    var lesson_counter_ends: Int? = null

    @ColumnInfo(name = "encoded_token")
    var encoded_token: String = ""
}