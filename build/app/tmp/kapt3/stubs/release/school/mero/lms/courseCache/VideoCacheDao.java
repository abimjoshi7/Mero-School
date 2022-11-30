package school.mero.lms.courseCache;

import java.lang.System;

/**
 * Created by root on 5/25/18.
 */
@androidx.room.Dao()
@kotlin.Metadata(mv = {1, 5, 1}, k = 1, d1 = {"\u0000B\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0013\n\u0002\u0010\u0006\n\u0002\b\u0003\n\u0002\u0010\t\n\u0000\bg\u0018\u00002\u00020\u0001J\u0010\u0010\u000b\u001a\u00020\u00052\u0006\u0010\f\u001a\u00020\rH\'J\u0010\u0010\u000e\u001a\u00020\u00052\u0006\u0010\f\u001a\u00020\rH\'J\u0012\u0010\u000f\u001a\f\u0012\u0006\u0012\u0004\u0018\u00010\u0011\u0018\u00010\u0010H\'J\u0019\u0010\u0012\u001a\u00020\u00132\u0006\u0010\u0014\u001a\u00020\u0005H\u00a7@\u00f8\u0001\u0000\u00a2\u0006\u0002\u0010\u0015J\u0011\u0010\u0016\u001a\u00020\u0013H\u00a7@\u00f8\u0001\u0000\u00a2\u0006\u0002\u0010\u0017J\u0010\u0010\u0018\u001a\u00020\u00132\u0006\u0010\u0019\u001a\u00020\u0011H\'J\u0010\u0010\u001a\u001a\u00020\u00132\u0006\u0010\u001b\u001a\u00020\rH\'J\u0016\u0010\u001c\u001a\b\u0012\u0004\u0012\u00020\u00050\u00032\u0006\u0010\u001d\u001a\u00020\rH\'J\u0018\u0010\u001e\u001a\n\u0012\u0004\u0012\u00020\u0005\u0018\u00010\u00102\u0006\u0010\u001d\u001a\u00020\rH\'J\u001b\u0010\u001f\u001a\u00020\u00132\b\u0010 \u001a\u0004\u0018\u00010\u0005H\u00a7@\u00f8\u0001\u0000\u00a2\u0006\u0002\u0010\u0015J\u001a\u0010!\u001a\u00020\u00132\u0010\u0010\"\u001a\f\u0012\u0006\u0012\u0004\u0018\u00010\u0005\u0018\u00010\u0004H\'J\u0012\u0010#\u001a\u00020\u00132\b\u0010 \u001a\u0004\u0018\u00010\u0005H\'J)\u0010$\u001a\u00020\u00132\u0006\u0010%\u001a\u00020\u00112\u0006\u0010\u001d\u001a\u00020\r2\u0006\u0010&\u001a\u00020\'H\u00a7@\u00f8\u0001\u0000\u00a2\u0006\u0002\u0010(J\u0018\u0010)\u001a\u00020\u00132\u0006\u0010\u0019\u001a\u00020\u00112\u0006\u0010*\u001a\u00020+H\'R \u0010\u0002\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00050\u00040\u00038gX\u00a6\u0004\u00a2\u0006\u0006\u001a\u0004\b\u0006\u0010\u0007R\u001a\u0010\b\u001a\b\u0012\u0004\u0012\u00020\u00050\u00048gX\u00a6\u0004\u00a2\u0006\u0006\u001a\u0004\b\t\u0010\n\u0082\u0002\u0004\n\u0002\b\u0019\u00a8\u0006,"}, d2 = {"Lschool/mero/lms/courseCache/VideoCacheDao;", "", "allDownloads", "Lkotlinx/coroutines/flow/Flow;", "", "Lschool/mero/lms/courseCache/VideoCache;", "getAllDownloads", "()Lkotlinx/coroutines/flow/Flow;", "currentList", "getCurrentList", "()Ljava/util/List;", "checkIfAlreadyDownloaded", "proxy", "", "checkIfAlreadyFromUrl", "countDownloads", "Landroidx/lifecycle/LiveData;", "", "delete", "", "downloads", "(Lschool/mero/lms/courseCache/VideoCache;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "deleteAll", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "deleteAllWithCourse", "cid", "deleteDownloads", "dId", "getSingleDownloads", "url", "getSingleDownloadsLiveData", "insert", "notification", "insertAll", "ads", "insertSingle", "updateState", "state", "percent", "", "(ILjava/lang/String;DLkotlin/coroutines/Continuation;)Ljava/lang/Object;", "updateWithCourse", "exp_date", "", "app_release"})
public abstract interface VideoCacheDao {
    
    @org.jetbrains.annotations.Nullable()
    @androidx.room.Insert(onConflict = androidx.room.OnConflictStrategy.REPLACE)
    public abstract java.lang.Object insert(@org.jetbrains.annotations.Nullable()
    school.mero.lms.courseCache.VideoCache notification, @org.jetbrains.annotations.NotNull()
    kotlin.coroutines.Continuation<? super kotlin.Unit> continuation);
    
    @org.jetbrains.annotations.NotNull()
    @androidx.room.Query(value = "SELECT * from VideoCache")
    public abstract kotlinx.coroutines.flow.Flow<java.util.List<school.mero.lms.courseCache.VideoCache>> getAllDownloads();
    
    @org.jetbrains.annotations.NotNull()
    @androidx.room.Query(value = "SELECT * from VideoCache")
    public abstract java.util.List<school.mero.lms.courseCache.VideoCache> getCurrentList();
    
    @androidx.room.Insert(onConflict = androidx.room.OnConflictStrategy.REPLACE)
    public abstract void insertSingle(@org.jetbrains.annotations.Nullable()
    school.mero.lms.courseCache.VideoCache notification);
    
    @org.jetbrains.annotations.Nullable()
    @androidx.room.Query(value = "DELETE FROM VideoCache")
    public abstract java.lang.Object deleteAll(@org.jetbrains.annotations.NotNull()
    kotlin.coroutines.Continuation<? super kotlin.Unit> continuation);
    
    @org.jetbrains.annotations.Nullable()
    @androidx.room.Delete()
    public abstract java.lang.Object delete(@org.jetbrains.annotations.NotNull()
    school.mero.lms.courseCache.VideoCache downloads, @org.jetbrains.annotations.NotNull()
    kotlin.coroutines.Continuation<? super kotlin.Unit> continuation);
    
    @androidx.room.Query(value = "DELETE from VideoCache WHERE courseId =:cid")
    public abstract void deleteAllWithCourse(int cid);
    
    @androidx.room.Query(value = "DELETE from VideoCache WHERE url =:dId")
    public abstract void deleteDownloads(@org.jetbrains.annotations.NotNull()
    java.lang.String dId);
    
    @org.jetbrains.annotations.NotNull()
    @androidx.room.Query(value = "SELECT * from VideoCache WHERE url =:url limit 1")
    public abstract kotlinx.coroutines.flow.Flow<school.mero.lms.courseCache.VideoCache> getSingleDownloads(@org.jetbrains.annotations.NotNull()
    java.lang.String url);
    
    @org.jetbrains.annotations.NotNull()
    @androidx.room.Query(value = "SELECT * from VideoCache WHERE proxy =:proxy limit 1")
    public abstract school.mero.lms.courseCache.VideoCache checkIfAlreadyDownloaded(@org.jetbrains.annotations.NotNull()
    java.lang.String proxy);
    
    @org.jetbrains.annotations.NotNull()
    @androidx.room.Query(value = "SELECT * from VideoCache WHERE url =:proxy limit 1")
    public abstract school.mero.lms.courseCache.VideoCache checkIfAlreadyFromUrl(@org.jetbrains.annotations.NotNull()
    java.lang.String proxy);
    
    @org.jetbrains.annotations.Nullable()
    @androidx.room.Query(value = "SELECT * from VideoCache WHERE url =:url limit 1")
    public abstract androidx.lifecycle.LiveData<school.mero.lms.courseCache.VideoCache> getSingleDownloadsLiveData(@org.jetbrains.annotations.NotNull()
    java.lang.String url);
    
    @org.jetbrains.annotations.Nullable()
    @androidx.room.Query(value = "UPDATE VideoCache SET state=:state , percent=:percent WHERE url = :url")
    public abstract java.lang.Object updateState(int state, @org.jetbrains.annotations.NotNull()
    java.lang.String url, double percent, @org.jetbrains.annotations.NotNull()
    kotlin.coroutines.Continuation<? super kotlin.Unit> continuation);
    
    @androidx.room.Query(value = "UPDATE VideoCache SET expiry=:exp_date WHERE courseId =:cid")
    public abstract void updateWithCourse(int cid, long exp_date);
    
    @org.jetbrains.annotations.Nullable()
    @androidx.room.Query(value = "SELECT count(*) FROM VideoCache")
    public abstract androidx.lifecycle.LiveData<java.lang.Integer> countDownloads();
    
    @androidx.room.Insert(onConflict = androidx.room.OnConflictStrategy.REPLACE)
    public abstract void insertAll(@org.jetbrains.annotations.Nullable()
    java.util.List<school.mero.lms.courseCache.VideoCache> ads);
}