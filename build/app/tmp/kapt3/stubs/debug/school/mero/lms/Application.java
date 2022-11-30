package school.mero.lms;

import java.lang.System;

@kotlin.Metadata(mv = {1, 5, 1}, k = 1, d1 = {"\u00000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\u0018\u0000 \u00142\u00020\u00012\u00020\u0002:\u0001\u0014B\u0005\u00a2\u0006\u0002\u0010\u0003J\b\u0010\u000f\u001a\u00020\u0010H\u0016J\u0010\u0010\u0011\u001a\u00020\u00102\u0006\u0010\u0012\u001a\u00020\u0013H\u0016R\u001b\u0010\u0004\u001a\u00020\u00058FX\u0086\u0084\u0002\u00a2\u0006\f\n\u0004\b\b\u0010\t\u001a\u0004\b\u0006\u0010\u0007R\u001b\u0010\n\u001a\u00020\u000b8FX\u0086\u0084\u0002\u00a2\u0006\f\n\u0004\b\u000e\u0010\t\u001a\u0004\b\f\u0010\r\u00a8\u0006\u0015"}, d2 = {"Lschool/mero/lms/Application;", "Lio/flutter/app/FlutterApplication;", "Lio/flutter/plugin/common/PluginRegistry$PluginRegistrantCallback;", "()V", "database", "Lschool/mero/lms/live/DownlaodDatabase;", "getDatabase", "()Lschool/mero/lms/live/DownlaodDatabase;", "database$delegate", "Lkotlin/Lazy;", "videoCacheRepo", "Lschool/mero/lms/courseCache/VideoCacheRepo;", "getVideoCacheRepo", "()Lschool/mero/lms/courseCache/VideoCacheRepo;", "videoCacheRepo$delegate", "onCreate", "", "registerWith", "registry", "Lio/flutter/plugin/common/PluginRegistry;", "Companion", "app_debug"})
public final class Application extends io.flutter.app.FlutterApplication implements io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback {
    @org.jetbrains.annotations.NotNull()
    public static final school.mero.lms.Application.Companion Companion = null;
    private static school.mero.lms.live.DownloadTracker globalDownloadTracker;
    @org.jetbrains.annotations.NotNull()
    private final kotlin.Lazy database$delegate = null;
    @org.jetbrains.annotations.NotNull()
    private final kotlin.Lazy videoCacheRepo$delegate = null;
    
    public Application() {
        super();
    }
    
    @org.jetbrains.annotations.NotNull()
    public final school.mero.lms.live.DownlaodDatabase getDatabase() {
        return null;
    }
    
    @org.jetbrains.annotations.NotNull()
    public final school.mero.lms.courseCache.VideoCacheRepo getVideoCacheRepo() {
        return null;
    }
    
    @java.lang.Override()
    public void onCreate() {
    }
    
    @java.lang.Override()
    public void registerWith(@org.jetbrains.annotations.NotNull()
    io.flutter.plugin.common.PluginRegistry registry) {
    }
    
    @kotlin.Metadata(mv = {1, 5, 1}, k = 1, d1 = {"\u0000\u0014\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0006\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002\u00a2\u0006\u0002\u0010\u0002R$\u0010\u0005\u001a\u00020\u00042\u0006\u0010\u0003\u001a\u00020\u0004@BX\u0086.\u00a2\u0006\u000e\n\u0000\u001a\u0004\b\u0006\u0010\u0007\"\u0004\b\b\u0010\t\u00a8\u0006\n"}, d2 = {"Lschool/mero/lms/Application$Companion;", "", "()V", "<set-?>", "Lschool/mero/lms/live/DownloadTracker;", "globalDownloadTracker", "getGlobalDownloadTracker", "()Lschool/mero/lms/live/DownloadTracker;", "setGlobalDownloadTracker", "(Lschool/mero/lms/live/DownloadTracker;)V", "app_debug"})
    public static final class Companion {
        
        private Companion() {
            super();
        }
        
        @org.jetbrains.annotations.NotNull()
        public final school.mero.lms.live.DownloadTracker getGlobalDownloadTracker() {
            return null;
        }
        
        private final void setGlobalDownloadTracker(school.mero.lms.live.DownloadTracker p0) {
        }
    }
}