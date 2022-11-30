package school.mero.lms.JSONSchemas;

import java.lang.System;

@kotlin.Metadata(mv = {1, 5, 1}, k = 1, d1 = {"\u0000\u001c\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0006\n\u0002\u0010\u000e\n\u0002\b&\u0018\u00002\u00020\u0001B\u0005\u00a2\u0006\u0002\u0010\u0002R\u001e\u0010\u0003\u001a\u0004\u0018\u00010\u0004X\u0086\u000e\u00a2\u0006\u0010\n\u0002\u0010\t\u001a\u0004\b\u0005\u0010\u0006\"\u0004\b\u0007\u0010\bR\u001a\u0010\n\u001a\u00020\u000bX\u0086\u000e\u00a2\u0006\u000e\n\u0000\u001a\u0004\b\f\u0010\r\"\u0004\b\u000e\u0010\u000fR\u001a\u0010\u0010\u001a\u00020\u000bX\u0086\u000e\u00a2\u0006\u000e\n\u0000\u001a\u0004\b\u0011\u0010\r\"\u0004\b\u0012\u0010\u000fR\u001e\u0010\u0013\u001a\u0004\u0018\u00010\u0004X\u0086\u000e\u00a2\u0006\u0010\n\u0002\u0010\t\u001a\u0004\b\u0014\u0010\u0006\"\u0004\b\u0015\u0010\bR\u001a\u0010\u0016\u001a\u00020\u0004X\u0086\u000e\u00a2\u0006\u000e\n\u0000\u001a\u0004\b\u0016\u0010\u0017\"\u0004\b\u0018\u0010\u0019R\u001c\u0010\u001a\u001a\u0004\u0018\u00010\u000bX\u0086\u000e\u00a2\u0006\u000e\n\u0000\u001a\u0004\b\u001a\u0010\r\"\u0004\b\u001b\u0010\u000fR\u001a\u0010\u001c\u001a\u00020\u000bX\u0086\u000e\u00a2\u0006\u000e\n\u0000\u001a\u0004\b\u001d\u0010\r\"\u0004\b\u001e\u0010\u000fR\u001c\u0010\u001f\u001a\u0004\u0018\u00010\u000bX\u0086\u000e\u00a2\u0006\u000e\n\u0000\u001a\u0004\b \u0010\r\"\u0004\b!\u0010\u000fR\u001a\u0010\"\u001a\u00020\u000bX\u0086\u000e\u00a2\u0006\u000e\n\u0000\u001a\u0004\b#\u0010\r\"\u0004\b$\u0010\u000fR\u001a\u0010%\u001a\u00020\u000bX\u0086\u000e\u00a2\u0006\u000e\n\u0000\u001a\u0004\b&\u0010\r\"\u0004\b\'\u0010\u000fR\u001c\u0010(\u001a\u0004\u0018\u00010\u000bX\u0086\u000e\u00a2\u0006\u000e\n\u0000\u001a\u0004\b)\u0010\r\"\u0004\b*\u0010\u000fR\u001a\u0010+\u001a\u00020\u000bX\u0086\u000e\u00a2\u0006\u000e\n\u0000\u001a\u0004\b,\u0010\r\"\u0004\b-\u0010\u000fR\u001c\u0010.\u001a\u0004\u0018\u00010\u000bX\u0086\u000e\u00a2\u0006\u000e\n\u0000\u001a\u0004\b/\u0010\r\"\u0004\b0\u0010\u000f\u00a8\u00061"}, d2 = {"Lschool/mero/lms/JSONSchemas/LessonSchema;", "Ljava/io/Serializable;", "()V", "course_id", "", "getCourse_id", "()Ljava/lang/Integer;", "setCourse_id", "(Ljava/lang/Integer;)V", "Ljava/lang/Integer;", "duration", "", "getDuration", "()Ljava/lang/String;", "setDuration", "(Ljava/lang/String;)V", "extra_token", "getExtra_token", "setExtra_token", "id", "getId", "setId", "is_completed", "()I", "set_completed", "(I)V", "is_lesson_free", "set_lesson_free", "lesson_title", "getLesson_title", "setLesson_title", "lesson_type", "getLesson_type", "setLesson_type", "title", "getTitle", "setTitle", "video_type", "getVideo_type", "setVideo_type", "video_type_for_mobile_application", "getVideo_type_for_mobile_application", "setVideo_type_for_mobile_application", "video_url", "getVideo_url", "setVideo_url", "video_url_for_mobile_application", "getVideo_url_for_mobile_application", "setVideo_url_for_mobile_application", "app_release"})
public final class LessonSchema implements java.io.Serializable {
    @org.jetbrains.annotations.Nullable()
    private java.lang.Integer id;
    @org.jetbrains.annotations.NotNull()
    private java.lang.String title = "";
    @org.jetbrains.annotations.NotNull()
    private java.lang.String lesson_title = "";
    @org.jetbrains.annotations.NotNull()
    private java.lang.String duration = "";
    @org.jetbrains.annotations.Nullable()
    private java.lang.Integer course_id;
    @org.jetbrains.annotations.NotNull()
    private java.lang.String video_type = "";
    @org.jetbrains.annotations.NotNull()
    private java.lang.String video_url = "";
    @org.jetbrains.annotations.Nullable()
    private java.lang.String video_type_for_mobile_application;
    @org.jetbrains.annotations.Nullable()
    private java.lang.String video_url_for_mobile_application;
    @org.jetbrains.annotations.Nullable()
    private java.lang.String lesson_type;
    private int is_completed = 0;
    @org.jetbrains.annotations.Nullable()
    private java.lang.String is_lesson_free;
    @org.jetbrains.annotations.NotNull()
    private java.lang.String extra_token = "";
    
    public LessonSchema() {
        super();
    }
    
    @org.jetbrains.annotations.Nullable()
    public final java.lang.Integer getId() {
        return null;
    }
    
    public final void setId(@org.jetbrains.annotations.Nullable()
    java.lang.Integer p0) {
    }
    
    @org.jetbrains.annotations.NotNull()
    public final java.lang.String getTitle() {
        return null;
    }
    
    public final void setTitle(@org.jetbrains.annotations.NotNull()
    java.lang.String p0) {
    }
    
    @org.jetbrains.annotations.NotNull()
    public final java.lang.String getLesson_title() {
        return null;
    }
    
    public final void setLesson_title(@org.jetbrains.annotations.NotNull()
    java.lang.String p0) {
    }
    
    @org.jetbrains.annotations.NotNull()
    public final java.lang.String getDuration() {
        return null;
    }
    
    public final void setDuration(@org.jetbrains.annotations.NotNull()
    java.lang.String p0) {
    }
    
    @org.jetbrains.annotations.Nullable()
    public final java.lang.Integer getCourse_id() {
        return null;
    }
    
    public final void setCourse_id(@org.jetbrains.annotations.Nullable()
    java.lang.Integer p0) {
    }
    
    @org.jetbrains.annotations.NotNull()
    public final java.lang.String getVideo_type() {
        return null;
    }
    
    public final void setVideo_type(@org.jetbrains.annotations.NotNull()
    java.lang.String p0) {
    }
    
    @org.jetbrains.annotations.NotNull()
    public final java.lang.String getVideo_url() {
        return null;
    }
    
    public final void setVideo_url(@org.jetbrains.annotations.NotNull()
    java.lang.String p0) {
    }
    
    @org.jetbrains.annotations.Nullable()
    public final java.lang.String getVideo_type_for_mobile_application() {
        return null;
    }
    
    public final void setVideo_type_for_mobile_application(@org.jetbrains.annotations.Nullable()
    java.lang.String p0) {
    }
    
    @org.jetbrains.annotations.Nullable()
    public final java.lang.String getVideo_url_for_mobile_application() {
        return null;
    }
    
    public final void setVideo_url_for_mobile_application(@org.jetbrains.annotations.Nullable()
    java.lang.String p0) {
    }
    
    @org.jetbrains.annotations.Nullable()
    public final java.lang.String getLesson_type() {
        return null;
    }
    
    public final void setLesson_type(@org.jetbrains.annotations.Nullable()
    java.lang.String p0) {
    }
    
    public final int is_completed() {
        return 0;
    }
    
    public final void set_completed(int p0) {
    }
    
    @org.jetbrains.annotations.Nullable()
    public final java.lang.String is_lesson_free() {
        return null;
    }
    
    public final void set_lesson_free(@org.jetbrains.annotations.Nullable()
    java.lang.String p0) {
    }
    
    @org.jetbrains.annotations.NotNull()
    public final java.lang.String getExtra_token() {
        return null;
    }
    
    public final void setExtra_token(@org.jetbrains.annotations.NotNull()
    java.lang.String p0) {
    }
}