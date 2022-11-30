package school.mero.lms.JSONSchemas

import java.io.Serializable

class LessonSchema : Serializable{
    var id: Int? = null
    var title: String =""
    var lesson_title: String=""
    var duration: String=""


    var course_id: Int? = null

    var video_type: String=""


    var video_url: String=""

    var video_type_for_mobile_application: String? = null


    var video_url_for_mobile_application: String? = null


    var lesson_type: String? = null



    var is_completed = 0


    var is_lesson_free: String? = null


    var extra_token: String =""
}