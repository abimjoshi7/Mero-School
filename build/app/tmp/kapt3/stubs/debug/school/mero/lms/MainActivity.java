package school.mero.lms;

import java.lang.System;

@kotlin.Metadata(mv = {1, 5, 1}, k = 1, d1 = {"\u0000^\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u0002\n\u0002\b\u000b\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\t\n\u0000\u0018\u00002\u00020\u0001B\u0005\u00a2\u0006\u0002\u0010\u0002J`\u0010\u001d\u001a\u00020\u001e2\b\u0010\u001f\u001a\u0004\u0018\u00010\u00042\b\u0010 \u001a\u0004\u0018\u00010\u00042\b\u0010!\u001a\u0004\u0018\u00010\u00042\b\u0010\"\u001a\u0004\u0018\u00010\u00042\b\u0010#\u001a\u0004\u0018\u00010\u00042\b\u0010$\u001a\u0004\u0018\u00010\u00042\b\u0010%\u001a\u0004\u0018\u00010\u00042\b\u0010&\u001a\u0004\u0018\u00010\u00042\b\u0010\'\u001a\u0004\u0018\u00010\u0004J\u0012\u0010(\u001a\u00020\u001e2\b\b\u0001\u0010)\u001a\u00020*H\u0016J\u0006\u0010+\u001a\u00020\u001eJ\u000e\u0010,\u001a\u00020\u001e2\u0006\u0010\u001f\u001a\u00020\u0004J\u0012\u0010-\u001a\u00020\u001e2\b\u0010.\u001a\u0004\u0018\u00010/H\u0014J\u000e\u00100\u001a\u00020\u001e2\u0006\u00101\u001a\u000202J\u001a\u00103\u001a\u00020\u001e2\u0012\u00104\u001a\u000e\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020\u000405J\n\u00106\u001a\u00020\u0004*\u000207J\n\u00106\u001a\u000207*\u00020\u0004R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082D\u00a2\u0006\u0002\n\u0000R\u001c\u0010\u0005\u001a\u0004\u0018\u00010\u0006X\u0086\u000e\u00a2\u0006\u000e\n\u0000\u001a\u0004\b\u0007\u0010\b\"\u0004\b\t\u0010\nR\u001c\u0010\u000b\u001a\u0004\u0018\u00010\fX\u0086\u000e\u00a2\u0006\u000e\n\u0000\u001a\u0004\b\r\u0010\u000e\"\u0004\b\u000f\u0010\u0010R\u001b\u0010\u0011\u001a\u00020\u00128BX\u0082\u0084\u0002\u00a2\u0006\f\n\u0004\b\u0015\u0010\u0016\u001a\u0004\b\u0013\u0010\u0014R\u001a\u0010\u0017\u001a\u00020\u0018X\u0086\u000e\u00a2\u0006\u000e\n\u0000\u001a\u0004\b\u0019\u0010\u001a\"\u0004\b\u001b\u0010\u001c\u00a8\u00068"}, d2 = {"Lschool/mero/lms/MainActivity;", "Lio/flutter/embedding/android/FlutterFragmentActivity;", "()V", "NATIVE_CHANNEL", "", "downloadTracker", "Lschool/mero/lms/live/DownloadTracker;", "getDownloadTracker", "()Lschool/mero/lms/live/DownloadTracker;", "setDownloadTracker", "(Lschool/mero/lms/live/DownloadTracker;)V", "savingDialog", "Lschool/mero/lms/SavingDialog;", "getSavingDialog", "()Lschool/mero/lms/SavingDialog;", "setSavingDialog", "(Lschool/mero/lms/SavingDialog;)V", "videoCacheViewModel", "Lschool/mero/lms/courseCache/VideoCacheViewModel;", "getVideoCacheViewModel", "()Lschool/mero/lms/courseCache/VideoCacheViewModel;", "videoCacheViewModel$delegate", "Lkotlin/Lazy;", "weAnalytics", "Lcom/webengage/sdk/android/Analytics;", "getWeAnalytics", "()Lcom/webengage/sdk/android/Analytics;", "setWeAnalytics", "(Lcom/webengage/sdk/android/Analytics;)V", "clickedDownload", "", "url", "token", "title", "thumbnail", "proxy", "duration", "course", "expiry", "course_title", "configureFlutterEngine", "flutterEngine", "Lio/flutter/embedding/engine/FlutterEngine;", "downloadView", "logDownloadComplete", "onCreate", "savedInstanceState", "Landroid/os/Bundle;", "printHashKey", "pContext", "Landroid/content/Context;", "removeTheInValidIdsOfflineData", "activeIds", "Ljava/util/HashMap;", "toExpiryDate", "", "app_debug"})
public final class MainActivity extends io.flutter.embedding.android.FlutterFragmentActivity {
    private final java.lang.String NATIVE_CHANNEL = "native_channel";
    @org.jetbrains.annotations.Nullable()
    private school.mero.lms.live.DownloadTracker downloadTracker;
    @org.jetbrains.annotations.Nullable()
    private school.mero.lms.SavingDialog savingDialog;
    @org.jetbrains.annotations.NotNull()
    private com.webengage.sdk.android.Analytics weAnalytics;
    private final kotlin.Lazy videoCacheViewModel$delegate = null;
    private java.util.HashMap _$_findViewCache;
    
    public MainActivity() {
        super();
    }
    
    @org.jetbrains.annotations.Nullable()
    public final school.mero.lms.live.DownloadTracker getDownloadTracker() {
        return null;
    }
    
    public final void setDownloadTracker(@org.jetbrains.annotations.Nullable()
    school.mero.lms.live.DownloadTracker p0) {
    }
    
    @org.jetbrains.annotations.Nullable()
    public final school.mero.lms.SavingDialog getSavingDialog() {
        return null;
    }
    
    public final void setSavingDialog(@org.jetbrains.annotations.Nullable()
    school.mero.lms.SavingDialog p0) {
    }
    
    @org.jetbrains.annotations.NotNull()
    public final com.webengage.sdk.android.Analytics getWeAnalytics() {
        return null;
    }
    
    public final void setWeAnalytics(@org.jetbrains.annotations.NotNull()
    com.webengage.sdk.android.Analytics p0) {
    }
    
    private final school.mero.lms.courseCache.VideoCacheViewModel getVideoCacheViewModel() {
        return null;
    }
    
    @java.lang.Override()
    protected void onCreate(@org.jetbrains.annotations.Nullable()
    android.os.Bundle savedInstanceState) {
    }
    
    @java.lang.Override()
    public void configureFlutterEngine(@org.jetbrains.annotations.NotNull()
    @androidx.annotation.NonNull()
    io.flutter.embedding.engine.FlutterEngine flutterEngine) {
    }
    
    public final void clickedDownload(@org.jetbrains.annotations.Nullable()
    java.lang.String url, @org.jetbrains.annotations.Nullable()
    java.lang.String token, @org.jetbrains.annotations.Nullable()
    java.lang.String title, @org.jetbrains.annotations.Nullable()
    java.lang.String thumbnail, @org.jetbrains.annotations.Nullable()
    java.lang.String proxy, @org.jetbrains.annotations.Nullable()
    java.lang.String duration, @org.jetbrains.annotations.Nullable()
    java.lang.String course, @org.jetbrains.annotations.Nullable()
    java.lang.String expiry, @org.jetbrains.annotations.Nullable()
    java.lang.String course_title) {
    }
    
    public final void downloadView() {
    }
    
    public final long toExpiryDate(@org.jetbrains.annotations.NotNull()
    java.lang.String $this$toExpiryDate) {
        return 0L;
    }
    
    @org.jetbrains.annotations.NotNull()
    public final java.lang.String toExpiryDate(long $this$toExpiryDate) {
        return null;
    }
    
    public final void logDownloadComplete(@org.jetbrains.annotations.NotNull()
    java.lang.String url) {
    }
    
    public final void removeTheInValidIdsOfflineData(@org.jetbrains.annotations.NotNull()
    java.util.HashMap<java.lang.String, java.lang.String> activeIds) {
    }
    
    public final void printHashKey(@org.jetbrains.annotations.NotNull()
    android.content.Context pContext) {
    }
}