package school.mero.lms.live

import android.content.Context
import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase
import school.mero.lms.DATABASE_VERSION
import school.mero.lms.courseCache.VideoCache
import school.mero.lms.courseCache.VideoCacheDao


@Database(entities = arrayOf( VideoCache::class), version = DATABASE_VERSION, exportSchema = false)
public abstract class DownlaodDatabase : RoomDatabase() {

    abstract fun videoCacheDao(): VideoCacheDao


    companion object {
        // Singleton prevents multiple instances of database opening at the
        // same time.
        @Volatile
        private var INSTANCE: DownlaodDatabase? = null

        fun getDatabase(context: Context): DownlaodDatabase {
            // if the INSTANCE is not null, then return it,
            // if it is, then create the database
            return INSTANCE ?: synchronized(this) {
                val instance = Room.databaseBuilder(
                        context.applicationContext,
                        DownlaodDatabase::class.java,
                        "word_database" //word_database
                ).fallbackToDestructiveMigration()

                        .build()
                INSTANCE = instance
                // return instance
                instance
            }
        }
    }
}