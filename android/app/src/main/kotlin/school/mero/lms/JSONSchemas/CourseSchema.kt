package school.mero.lms.JSONSchemas

import java.io.Serializable


class CourseSchema : Serializable, Comparable<CourseSchema>
{


    
    var id: String? = null
    var title: String? = null
    var short_description: String? = null
    var description: String? = null


    var outcomes: List<String>? = null
    var includes: List<String>? = null
    var requirements: List<String>? = null



    var language: String? = null
    var category_id: String? = null



    var price: String? = null


    var currency: String? = null
        get() = if(field!=null) field else "Rs "

    var discount_flag: String? = null


    var discounted_price: String? = null


    var level: String? = null


    var user_id: String? = null


    var thumbnail: String? = null
        get() =  if( field !=null ) field else "https://mero.school/uploads/thumbnails/course_thumbnails/course_thumbnail_default_${id}.jpg"

    var video_url: String? = null





    var category_name : String ?=  null
    var hours_lesson: String? = null

    var visibility: Any? = null



    var status: String? = null


    var course_overview_provider: String? = null




    var rating = 0f
        get() {


            if(field == 0f){

                average_rating?.let {

                    try {
                        val r = it
                        field = r
                        return field;
                    } catch (e: Exception) {
                        e.printStackTrace()
                    }

                }

            }

            return field
        }

    var number_of_ratings: Int? = null
        get() {

            if(field == null ){

                no_rating?.let {

                    try {
                        val r = it
                        field = r
                        return field;
                    } catch (e: Exception) {
                        e.printStackTrace()
                    }

                }

            }
            return  field

        }


    var instructor_name: String? = null


    var total_enrollment: Int? = null


    var shareable_link: String? = null


    var completion = 0


    var total_number_of_lessons = 0


    var total_number_of_completed_lessons = 0


    var is_wishlisted = false



    //added fields

    var is_free_course: String? = null



    var encoded_token: String = ""




    var is_purchased: Boolean ? = null




    var is_enrolled: Int ? = null



    var exp_date: String ? = null




    var duration: String ? = null

    //new added

    var paid_exp_days: Int ? = null


    var free_exp_days: Int ? = null




    var action : String ? = null
    val sections: List<SectionSchema>? = null




    // "average_rating": "0",
    //            "no_rating": "0"


    var no_rating :Int? = null
    var average_rating :Float? = null


    override fun compareTo(other: CourseSchema): Int {

        title?.let { a->

            other.title?.let { b->


                val rsl = a.compareTo(b, ignoreCase = true)




                return  rsl;
            }

        }


        return 0;
    }




}





