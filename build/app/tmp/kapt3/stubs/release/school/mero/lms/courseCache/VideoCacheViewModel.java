package school.mero.lms.courseCache;

import java.lang.System;

@kotlin.Metadata(mv = {1, 5, 1}, k = 1, d1 = {"\u0000>\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\b\n\u0002\b\u0005\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u000b\n\u0002\u0010\u0006\n\u0000\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u00a2\u0006\u0002\u0010\u0004J\u0010\u0010\u0013\u001a\u0004\u0018\u00010\u000e2\u0006\u0010\u0014\u001a\u00020\u0015J\u0006\u0010\u0016\u001a\u00020\u0017J\u000e\u0010\u0018\u001a\u00020\u00172\u0006\u0010\u0019\u001a\u00020\u000eJ\u001b\u0010\u001a\u001a\u0004\u0018\u00010\u000e2\u0006\u0010\u001b\u001a\u00020\u0015H\u0086@\u00f8\u0001\u0000\u00a2\u0006\u0002\u0010\u001cJ\u0016\u0010\u001d\u001a\n\u0012\u0004\u0012\u00020\u000e\u0018\u00010\u00062\u0006\u0010\u001b\u001a\u00020\u0015J\u000e\u0010\u001e\u001a\u00020\u00172\u0006\u0010\u001f\u001a\u00020\u000eJ\u001e\u0010 \u001a\u00020\u00172\u0006\u0010!\u001a\u00020\u00072\u0006\u0010\u001b\u001a\u00020\u00152\u0006\u0010\"\u001a\u00020#R$\u0010\u0005\u001a\f\u0012\u0006\u0012\u0004\u0018\u00010\u0007\u0018\u00010\u0006X\u0086\u000e\u00a2\u0006\u000e\n\u0000\u001a\u0004\b\b\u0010\t\"\u0004\b\n\u0010\u000bR&\u0010\f\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u000e0\r0\u0006X\u0086\u000e\u00a2\u0006\u000e\n\u0000\u001a\u0004\b\u000f\u0010\t\"\u0004\b\u0010\u0010\u000bR\u0011\u0010\u0002\u001a\u00020\u0003\u00a2\u0006\b\n\u0000\u001a\u0004\b\u0011\u0010\u0012\u0082\u0002\u0004\n\u0002\b\u0019\u00a8\u0006$"}, d2 = {"Lschool/mero/lms/courseCache/VideoCacheViewModel;", "Landroidx/lifecycle/ViewModel;", "repo", "Lschool/mero/lms/courseCache/VideoCacheRepo;", "(Lschool/mero/lms/courseCache/VideoCacheRepo;)V", "count", "Landroidx/lifecycle/LiveData;", "", "getCount", "()Landroidx/lifecycle/LiveData;", "setCount", "(Landroidx/lifecycle/LiveData;)V", "downloads", "", "Lschool/mero/lms/courseCache/VideoCache;", "getDownloads", "setDownloads", "getRepo", "()Lschool/mero/lms/courseCache/VideoCacheRepo;", "checkAlreadyDownloaded", "proxy", "", "deleteAll", "Lkotlinx/coroutines/Job;", "deleteFromDb", "notification", "getSingleItemRepo", "url", "(Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getSingleItemRepoFlow", "insertIntoDb", "download", "updateState", "state", "byteDownloaded", "", "app_release"})
public final class VideoCacheViewModel extends androidx.lifecycle.ViewModel {
    @org.jetbrains.annotations.NotNull()
    private final school.mero.lms.courseCache.VideoCacheRepo repo = null;
    @org.jetbrains.annotations.NotNull()
    private androidx.lifecycle.LiveData<java.util.List<school.mero.lms.courseCache.VideoCache>> downloads;
    @org.jetbrains.annotations.Nullable()
    private androidx.lifecycle.LiveData<java.lang.Integer> count;
    
    public VideoCacheViewModel(@org.jetbrains.annotations.NotNull()
    school.mero.lms.courseCache.VideoCacheRepo repo) {
        super();
    }
    
    @org.jetbrains.annotations.NotNull()
    public final school.mero.lms.courseCache.VideoCacheRepo getRepo() {
        return null;
    }
    
    @org.jetbrains.annotations.NotNull()
    public final androidx.lifecycle.LiveData<java.util.List<school.mero.lms.courseCache.VideoCache>> getDownloads() {
        return null;
    }
    
    public final void setDownloads(@org.jetbrains.annotations.NotNull()
    androidx.lifecycle.LiveData<java.util.List<school.mero.lms.courseCache.VideoCache>> p0) {
    }
    
    @org.jetbrains.annotations.Nullable()
    public final androidx.lifecycle.LiveData<java.lang.Integer> getCount() {
        return null;
    }
    
    public final void setCount(@org.jetbrains.annotations.Nullable()
    androidx.lifecycle.LiveData<java.lang.Integer> p0) {
    }
    
    @org.jetbrains.annotations.Nullable()
    public final java.lang.Object getSingleItemRepo(@org.jetbrains.annotations.NotNull()
    java.lang.String url, @org.jetbrains.annotations.NotNull()
    kotlin.coroutines.Continuation<? super school.mero.lms.courseCache.VideoCache> continuation) {
        return null;
    }
    
    @org.jetbrains.annotations.Nullable()
    public final androidx.lifecycle.LiveData<school.mero.lms.courseCache.VideoCache> getSingleItemRepoFlow(@org.jetbrains.annotations.NotNull()
    java.lang.String url) {
        return null;
    }
    
    @org.jetbrains.annotations.Nullable()
    public final school.mero.lms.courseCache.VideoCache checkAlreadyDownloaded(@org.jetbrains.annotations.NotNull()
    java.lang.String proxy) {
        return null;
    }
    
    @org.jetbrains.annotations.NotNull()
    public final kotlinx.coroutines.Job insertIntoDb(@org.jetbrains.annotations.NotNull()
    school.mero.lms.courseCache.VideoCache download) {
        return null;
    }
    
    @org.jetbrains.annotations.NotNull()
    public final kotlinx.coroutines.Job updateState(int state, @org.jetbrains.annotations.NotNull()
    java.lang.String url, double byteDownloaded) {
        return null;
    }
    
    @org.jetbrains.annotations.NotNull()
    public final kotlinx.coroutines.Job deleteAll() {
        return null;
    }
    
    @org.jetbrains.annotations.NotNull()
    public final kotlinx.coroutines.Job deleteFromDb(@org.jetbrains.annotations.NotNull()
    school.mero.lms.courseCache.VideoCache notification) {
        return null;
    }
}