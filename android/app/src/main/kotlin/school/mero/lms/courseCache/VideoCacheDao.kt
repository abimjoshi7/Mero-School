package school.mero.lms.courseCache

import androidx.lifecycle.LiveData
import androidx.room.*
import kotlinx.coroutines.flow.Flow

/**
 * Created by root on 5/25/18.
 */
@Dao
interface VideoCacheDao {



    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(notification: VideoCache?)

     @get:Query("SELECT * from VideoCache")
     val allDownloads: Flow<List<VideoCache>>


    @get:Query("SELECT * from VideoCache")
    val currentList : List<VideoCache>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    fun insertSingle(notification: VideoCache?)



    @Query("DELETE FROM VideoCache")
    suspend fun deleteAll()


    @Delete
    suspend fun delete(downloads: VideoCache)



    @Query("DELETE from VideoCache WHERE courseId =:cid")
    fun deleteAllWithCourse(cid: Int)



    @Query("DELETE from VideoCache WHERE url =:dId")
    fun deleteDownloads(dId: String)



    @Query("SELECT * from VideoCache WHERE url =:url limit 1")
    fun getSingleDownloads(url: String): Flow<VideoCache>


    @Query("SELECT * from VideoCache WHERE proxy =:proxy limit 1")
    fun checkIfAlreadyDownloaded(proxy: String): VideoCache


    @Query("SELECT * from VideoCache WHERE url =:proxy limit 1")
    fun checkIfAlreadyFromUrl(proxy: String): VideoCache


    @Query("SELECT * from VideoCache WHERE url =:url limit 1")
    fun getSingleDownloadsLiveData(url: String): LiveData<VideoCache>?


    //update state

    @Query("UPDATE VideoCache SET state=:state , percent=:percent WHERE url = :url")
    suspend fun updateState(state: Int, url: String, percent: Double)




    @Query("UPDATE VideoCache SET expiry=:exp_date WHERE courseId =:cid")
    fun updateWithCourse(cid: Int, exp_date: Long)


    @Query("SELECT count(*) FROM VideoCache")
    fun countDownloads(): LiveData<Int?>?



    @Insert(onConflict = OnConflictStrategy.REPLACE)
    fun insertAll(ads: List<VideoCache?>?)



}