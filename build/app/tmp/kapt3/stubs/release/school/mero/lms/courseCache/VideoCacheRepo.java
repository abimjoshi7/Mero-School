package school.mero.lms.courseCache;

import java.lang.System;

@kotlin.Metadata(mv = {1, 5, 1}, k = 1, d1 = {"\u0000D\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0010\b\n\u0002\b\u0006\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\u0002\n\u0002\b\r\n\u0002\u0010\u0006\n\u0002\b\u0002\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u00a2\u0006\u0002\u0010\u0004J\u0010\u0010\u0012\u001a\u0004\u0018\u00010\b2\u0006\u0010\u0013\u001a\u00020\u0014J\u0019\u0010\u0015\u001a\u00020\u00162\u0006\u0010\u0017\u001a\u00020\bH\u0087@\u00f8\u0001\u0000\u00a2\u0006\u0002\u0010\u0018J\u0011\u0010\u0019\u001a\u00020\u0016H\u0087@\u00f8\u0001\u0000\u00a2\u0006\u0002\u0010\u001aJ\u001b\u0010\u001b\u001a\u0004\u0018\u00010\b2\u0006\u0010\u001c\u001a\u00020\u0014H\u0086@\u00f8\u0001\u0000\u00a2\u0006\u0002\u0010\u001dJ\u0016\u0010\u001e\u001a\n\u0012\u0004\u0012\u00020\b\u0018\u00010\f2\u0006\u0010\u001c\u001a\u00020\u0014J\u0019\u0010\u001f\u001a\u00020\u00162\u0006\u0010\u0017\u001a\u00020\bH\u0087@\u00f8\u0001\u0000\u00a2\u0006\u0002\u0010\u0018J\u000e\u0010 \u001a\u00020\u00162\u0006\u0010\u0017\u001a\u00020\bJ)\u0010!\u001a\u00020\u00162\u0006\u0010\"\u001a\u00020\r2\u0006\u0010\u001c\u001a\u00020\u00142\u0006\u0010#\u001a\u00020$H\u0087@\u00f8\u0001\u0000\u00a2\u0006\u0002\u0010%R\u001d\u0010\u0005\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\b0\u00070\u0006\u00a2\u0006\b\n\u0000\u001a\u0004\b\t\u0010\nR\u001b\u0010\u000b\u001a\f\u0012\u0006\u0012\u0004\u0018\u00010\r\u0018\u00010\f\u00a2\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u000fR\u0011\u0010\u0002\u001a\u00020\u0003\u00a2\u0006\b\n\u0000\u001a\u0004\b\u0010\u0010\u0011\u0082\u0002\u0004\n\u0002\b\u0019\u00a8\u0006&"}, d2 = {"Lschool/mero/lms/courseCache/VideoCacheRepo;", "", "dao", "Lschool/mero/lms/courseCache/VideoCacheDao;", "(Lschool/mero/lms/courseCache/VideoCacheDao;)V", "allDownloads", "Lkotlinx/coroutines/flow/Flow;", "", "Lschool/mero/lms/courseCache/VideoCache;", "getAllDownloads", "()Lkotlinx/coroutines/flow/Flow;", "count", "Landroidx/lifecycle/LiveData;", "", "getCount", "()Landroidx/lifecycle/LiveData;", "getDao", "()Lschool/mero/lms/courseCache/VideoCacheDao;", "checkIfAlreadyDownloaded", "proxy", "", "delete", "", "down", "(Lschool/mero/lms/courseCache/VideoCache;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "deleteAll", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getSingleDownload", "url", "(Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getSingleDownloadFlowable", "insert", "insertSingle", "updateState", "state", "percent", "", "(ILjava/lang/String;DLkotlin/coroutines/Continuation;)Ljava/lang/Object;", "app_release"})
public final class VideoCacheRepo {
    @org.jetbrains.annotations.NotNull()
    private final school.mero.lms.courseCache.VideoCacheDao dao = null;
    @org.jetbrains.annotations.Nullable()
    private final androidx.lifecycle.LiveData<java.lang.Integer> count = null;
    @org.jetbrains.annotations.NotNull()
    private final kotlinx.coroutines.flow.Flow<java.util.List<school.mero.lms.courseCache.VideoCache>> allDownloads = null;
    
    public VideoCacheRepo(@org.jetbrains.annotations.NotNull()
    school.mero.lms.courseCache.VideoCacheDao dao) {
        super();
    }
    
    @org.jetbrains.annotations.NotNull()
    public final school.mero.lms.courseCache.VideoCacheDao getDao() {
        return null;
    }
    
    @org.jetbrains.annotations.Nullable()
    public final androidx.lifecycle.LiveData<java.lang.Integer> getCount() {
        return null;
    }
    
    @org.jetbrains.annotations.NotNull()
    public final kotlinx.coroutines.flow.Flow<java.util.List<school.mero.lms.courseCache.VideoCache>> getAllDownloads() {
        return null;
    }
    
    @org.jetbrains.annotations.Nullable()
    @androidx.annotation.WorkerThread()
    @kotlin.Suppress(names = {"RedundantSuspendModifier"})
    public final java.lang.Object insert(@org.jetbrains.annotations.NotNull()
    school.mero.lms.courseCache.VideoCache down, @org.jetbrains.annotations.NotNull()
    kotlin.coroutines.Continuation<? super kotlin.Unit> continuation) {
        return null;
    }
    
    public final void insertSingle(@org.jetbrains.annotations.NotNull()
    school.mero.lms.courseCache.VideoCache down) {
    }
    
    @org.jetbrains.annotations.Nullable()
    @androidx.annotation.WorkerThread()
    @kotlin.Suppress(names = {"RedundantSuspendModifier"})
    public final java.lang.Object updateState(int state, @org.jetbrains.annotations.NotNull()
    java.lang.String url, double percent, @org.jetbrains.annotations.NotNull()
    kotlin.coroutines.Continuation<? super kotlin.Unit> continuation) {
        return null;
    }
    
    @org.jetbrains.annotations.Nullable()
    @kotlin.Suppress(names = {"RedundantSuspendModifier"})
    public final java.lang.Object getSingleDownload(@org.jetbrains.annotations.NotNull()
    java.lang.String url, @org.jetbrains.annotations.NotNull()
    kotlin.coroutines.Continuation<? super school.mero.lms.courseCache.VideoCache> continuation) {
        return null;
    }
    
    @org.jetbrains.annotations.Nullable()
    @kotlin.Suppress(names = {"RedundantSuspendModifier"})
    public final androidx.lifecycle.LiveData<school.mero.lms.courseCache.VideoCache> getSingleDownloadFlowable(@org.jetbrains.annotations.NotNull()
    java.lang.String url) {
        return null;
    }
    
    @org.jetbrains.annotations.Nullable()
    @kotlin.Suppress(names = {"RedundantSuspendModifier"})
    public final school.mero.lms.courseCache.VideoCache checkIfAlreadyDownloaded(@org.jetbrains.annotations.NotNull()
    java.lang.String proxy) {
        return null;
    }
    
    @org.jetbrains.annotations.Nullable()
    @androidx.annotation.WorkerThread()
    @kotlin.Suppress(names = {"RedundantSuspendModifier"})
    public final java.lang.Object deleteAll(@org.jetbrains.annotations.NotNull()
    kotlin.coroutines.Continuation<? super kotlin.Unit> continuation) {
        return null;
    }
    
    @org.jetbrains.annotations.Nullable()
    @androidx.annotation.WorkerThread()
    @kotlin.Suppress(names = {"RedundantSuspendModifier"})
    public final java.lang.Object delete(@org.jetbrains.annotations.NotNull()
    school.mero.lms.courseCache.VideoCache down, @org.jetbrains.annotations.NotNull()
    kotlin.coroutines.Continuation<? super kotlin.Unit> continuation) {
        return null;
    }
}