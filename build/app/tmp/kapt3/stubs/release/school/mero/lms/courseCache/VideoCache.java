package school.mero.lms.courseCache;

import java.lang.System;

@androidx.room.Entity(tableName = "VideoCache")
@kotlin.Metadata(mv = {1, 5, 1}, k = 1, d1 = {"\u00002\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\n\n\u0002\u0010\t\n\u0002\b\t\n\u0002\u0010\u0006\n\u0002\b\u0015\n\u0002\u0010\u000b\n\u0002\b\u0004\b\u0087\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u00a2\u0006\u0002\u0010\u0004J\t\u0010.\u001a\u00020\u0003H\u00c6\u0003J\u0013\u0010/\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003H\u00c6\u0001J\u0013\u00100\u001a\u0002012\b\u00102\u001a\u0004\u0018\u00010\u0001H\u00d6\u0003J\t\u00103\u001a\u00020\u0006H\u00d6\u0001J\t\u00104\u001a\u00020\u0003H\u00d6\u0001R\"\u0010\u0005\u001a\u0004\u0018\u00010\u00068\u0006@\u0006X\u0087\u000e\u00a2\u0006\u0010\n\u0002\u0010\u000b\u001a\u0004\b\u0007\u0010\b\"\u0004\b\t\u0010\nR \u0010\f\u001a\u0004\u0018\u00010\u00038\u0006@\u0006X\u0087\u000e\u00a2\u0006\u000e\n\u0000\u001a\u0004\b\r\u0010\u000e\"\u0004\b\u000f\u0010\u0004R\"\u0010\u0010\u001a\u0004\u0018\u00010\u00118\u0006@\u0006X\u0087\u000e\u00a2\u0006\u0010\n\u0002\u0010\u0016\u001a\u0004\b\u0012\u0010\u0013\"\u0004\b\u0014\u0010\u0015R \u0010\u0017\u001a\u0004\u0018\u00010\u00038\u0006@\u0006X\u0087\u000e\u00a2\u0006\u000e\n\u0000\u001a\u0004\b\u0018\u0010\u000e\"\u0004\b\u0019\u0010\u0004R\"\u0010\u001a\u001a\u0004\u0018\u00010\u001b8\u0006@\u0006X\u0087\u000e\u00a2\u0006\u0010\n\u0002\u0010 \u001a\u0004\b\u001c\u0010\u001d\"\u0004\b\u001e\u0010\u001fR \u0010!\u001a\u0004\u0018\u00010\u00038\u0006@\u0006X\u0087\u000e\u00a2\u0006\u000e\n\u0000\u001a\u0004\b\"\u0010\u000e\"\u0004\b#\u0010\u0004R\"\u0010$\u001a\u0004\u0018\u00010\u00068\u0006@\u0006X\u0087\u000e\u00a2\u0006\u0010\n\u0002\u0010\u000b\u001a\u0004\b%\u0010\b\"\u0004\b&\u0010\nR \u0010\'\u001a\u0004\u0018\u00010\u00038\u0006@\u0006X\u0087\u000e\u00a2\u0006\u000e\n\u0000\u001a\u0004\b(\u0010\u000e\"\u0004\b)\u0010\u0004R \u0010*\u001a\u0004\u0018\u00010\u00038\u0006@\u0006X\u0087\u000e\u00a2\u0006\u000e\n\u0000\u001a\u0004\b+\u0010\u000e\"\u0004\b,\u0010\u0004R\u0016\u0010\u0002\u001a\u00020\u00038\u0006X\u0087\u0004\u00a2\u0006\b\n\u0000\u001a\u0004\b-\u0010\u000e\u00a8\u00065"}, d2 = {"Lschool/mero/lms/courseCache/VideoCache;", "", "url", "", "(Ljava/lang/String;)V", "courseId", "", "getCourseId", "()Ljava/lang/Integer;", "setCourseId", "(Ljava/lang/Integer;)V", "Ljava/lang/Integer;", "duration", "getDuration", "()Ljava/lang/String;", "setDuration", "expiry", "", "getExpiry", "()Ljava/lang/Long;", "setExpiry", "(Ljava/lang/Long;)V", "Ljava/lang/Long;", "json", "getJson", "setJson", "percent", "", "getPercent", "()Ljava/lang/Double;", "setPercent", "(Ljava/lang/Double;)V", "Ljava/lang/Double;", "proxy", "getProxy", "setProxy", "state", "getState", "setState", "thumbnail", "getThumbnail", "setThumbnail", "title", "getTitle", "setTitle", "getUrl", "component1", "copy", "equals", "", "other", "hashCode", "toString", "app_release"})
public final class VideoCache {
    @org.jetbrains.annotations.NotNull()
    @androidx.room.ColumnInfo(name = "url")
    @androidx.room.PrimaryKey()
    private final java.lang.String url = null;
    @org.jetbrains.annotations.Nullable()
    @androidx.room.ColumnInfo(name = "title")
    private java.lang.String title;
    @org.jetbrains.annotations.Nullable()
    @androidx.room.ColumnInfo(name = "state")
    private java.lang.Integer state;
    @org.jetbrains.annotations.Nullable()
    @androidx.room.ColumnInfo(name = "proxy")
    private java.lang.String proxy;
    @org.jetbrains.annotations.Nullable()
    @androidx.room.ColumnInfo(name = "duration")
    private java.lang.String duration;
    @org.jetbrains.annotations.Nullable()
    @androidx.room.ColumnInfo(name = "thumbnail")
    private java.lang.String thumbnail;
    @org.jetbrains.annotations.Nullable()
    @androidx.room.ColumnInfo(name = "json")
    private java.lang.String json;
    @org.jetbrains.annotations.Nullable()
    @androidx.room.ColumnInfo(name = "courseId")
    private java.lang.Integer courseId;
    @org.jetbrains.annotations.Nullable()
    @androidx.room.ColumnInfo(name = "percent")
    private java.lang.Double percent;
    @org.jetbrains.annotations.Nullable()
    @androidx.room.ColumnInfo(name = "expiry")
    private java.lang.Long expiry;
    
    @org.jetbrains.annotations.NotNull()
    public final school.mero.lms.courseCache.VideoCache copy(@org.jetbrains.annotations.NotNull()
    java.lang.String url) {
        return null;
    }
    
    @java.lang.Override()
    public boolean equals(@org.jetbrains.annotations.Nullable()
    java.lang.Object other) {
        return false;
    }
    
    @java.lang.Override()
    public int hashCode() {
        return 0;
    }
    
    @org.jetbrains.annotations.NotNull()
    @java.lang.Override()
    public java.lang.String toString() {
        return null;
    }
    
    public VideoCache(@org.jetbrains.annotations.NotNull()
    java.lang.String url) {
        super();
    }
    
    @org.jetbrains.annotations.NotNull()
    public final java.lang.String component1() {
        return null;
    }
    
    @org.jetbrains.annotations.NotNull()
    public final java.lang.String getUrl() {
        return null;
    }
    
    @org.jetbrains.annotations.Nullable()
    public final java.lang.String getTitle() {
        return null;
    }
    
    public final void setTitle(@org.jetbrains.annotations.Nullable()
    java.lang.String p0) {
    }
    
    @org.jetbrains.annotations.Nullable()
    public final java.lang.Integer getState() {
        return null;
    }
    
    public final void setState(@org.jetbrains.annotations.Nullable()
    java.lang.Integer p0) {
    }
    
    @org.jetbrains.annotations.Nullable()
    public final java.lang.String getProxy() {
        return null;
    }
    
    public final void setProxy(@org.jetbrains.annotations.Nullable()
    java.lang.String p0) {
    }
    
    @org.jetbrains.annotations.Nullable()
    public final java.lang.String getDuration() {
        return null;
    }
    
    public final void setDuration(@org.jetbrains.annotations.Nullable()
    java.lang.String p0) {
    }
    
    @org.jetbrains.annotations.Nullable()
    public final java.lang.String getThumbnail() {
        return null;
    }
    
    public final void setThumbnail(@org.jetbrains.annotations.Nullable()
    java.lang.String p0) {
    }
    
    @org.jetbrains.annotations.Nullable()
    public final java.lang.String getJson() {
        return null;
    }
    
    public final void setJson(@org.jetbrains.annotations.Nullable()
    java.lang.String p0) {
    }
    
    @org.jetbrains.annotations.Nullable()
    public final java.lang.Integer getCourseId() {
        return null;
    }
    
    public final void setCourseId(@org.jetbrains.annotations.Nullable()
    java.lang.Integer p0) {
    }
    
    @org.jetbrains.annotations.Nullable()
    public final java.lang.Double getPercent() {
        return null;
    }
    
    public final void setPercent(@org.jetbrains.annotations.Nullable()
    java.lang.Double p0) {
    }
    
    @org.jetbrains.annotations.Nullable()
    public final java.lang.Long getExpiry() {
        return null;
    }
    
    public final void setExpiry(@org.jetbrains.annotations.Nullable()
    java.lang.Long p0) {
    }
}