package school.mero.lms.JSONSchemas;

import java.lang.System;

@androidx.room.Entity(tableName = "SectionSchema")
@kotlin.Metadata(mv = {1, 5, 1}, k = 1, d1 = {"\u00000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u000b\n\u0002\u0010\u000e\n\u0002\b\u000e\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u000e\n\u0002\u0010\u000b\n\u0002\b\u0006\b\u0007\u0018\u00002\u00020\u0001B\u0005\u00a2\u0006\u0002\u0010\u0002R\u001e\u0010\u0003\u001a\u00020\u00048\u0006@\u0006X\u0087\u000e\u00a2\u0006\u000e\n\u0000\u001a\u0004\b\u0005\u0010\u0006\"\u0004\b\u0007\u0010\bR\"\u0010\t\u001a\u0004\u0018\u00010\u00048\u0006@\u0006X\u0087\u000e\u00a2\u0006\u0010\n\u0002\u0010\u000e\u001a\u0004\b\n\u0010\u000b\"\u0004\b\f\u0010\rR\u001e\u0010\u000f\u001a\u00020\u00108\u0006@\u0006X\u0087\u000e\u00a2\u0006\u000e\n\u0000\u001a\u0004\b\u0011\u0010\u0012\"\u0004\b\u0013\u0010\u0014R\u001e\u0010\u0015\u001a\u00020\u00048\u0006@\u0006X\u0087\u000e\u00a2\u0006\u000e\n\u0000\u001a\u0004\b\u0016\u0010\u0006\"\u0004\b\u0017\u0010\bR\"\u0010\u0018\u001a\u0004\u0018\u00010\u00048\u0006@\u0006X\u0087\u000e\u00a2\u0006\u0010\n\u0002\u0010\u000e\u001a\u0004\b\u0019\u0010\u000b\"\u0004\b\u001a\u0010\rR\u001e\u0010\u001b\u001a\u00020\u00048\u0006@\u0006X\u0087\u000e\u00a2\u0006\u000e\n\u0000\u001a\u0004\b\u001c\u0010\u0006\"\u0004\b\u001d\u0010\bR&\u0010\u001e\u001a\n\u0012\u0004\u0012\u00020 \u0018\u00010\u001f8\u0006@\u0006X\u0087\u000e\u00a2\u0006\u000e\n\u0000\u001a\u0004\b!\u0010\"\"\u0004\b#\u0010$R\"\u0010%\u001a\u0004\u0018\u00010\u00048\u0006@\u0006X\u0087\u000e\u00a2\u0006\u0010\n\u0002\u0010\u000e\u001a\u0004\b&\u0010\u000b\"\u0004\b\'\u0010\rR \u0010(\u001a\u0004\u0018\u00010\u00108\u0006@\u0006X\u0087\u000e\u00a2\u0006\u000e\n\u0000\u001a\u0004\b)\u0010\u0012\"\u0004\b*\u0010\u0014R \u0010+\u001a\u0004\u0018\u00010\u00108\u0006@\u0006X\u0087\u000e\u00a2\u0006\u000e\n\u0000\u001a\u0004\b,\u0010\u0012\"\u0004\b-\u0010\u0014R\"\u0010.\u001a\u0004\u0018\u00010/8\u0006@\u0006X\u0087\u000e\u00a2\u0006\u0010\n\u0002\u00104\u001a\u0004\b0\u00101\"\u0004\b2\u00103\u00a8\u00065"}, d2 = {"Lschool/mero/lms/JSONSchemas/SectionSchema;", "Ljava/io/Serializable;", "()V", "completed_lesson_number", "", "getCompleted_lesson_number", "()I", "setCompleted_lesson_number", "(I)V", "course_id", "getCourse_id", "()Ljava/lang/Integer;", "setCourse_id", "(Ljava/lang/Integer;)V", "Ljava/lang/Integer;", "encoded_token", "", "getEncoded_token", "()Ljava/lang/String;", "setEncoded_token", "(Ljava/lang/String;)V", "id", "getId", "setId", "lesson_counter_ends", "getLesson_counter_ends", "setLesson_counter_ends", "lesson_counter_starts", "getLesson_counter_starts", "setLesson_counter_starts", "lessons", "", "Lschool/mero/lms/JSONSchemas/LessonSchema;", "getLessons", "()Ljava/util/List;", "setLessons", "(Ljava/util/List;)V", "order", "getOrder", "setOrder", "title", "getTitle", "setTitle", "total_duration", "getTotal_duration", "setTotal_duration", "user_validity", "", "getUser_validity", "()Ljava/lang/Boolean;", "setUser_validity", "(Ljava/lang/Boolean;)V", "Ljava/lang/Boolean;", "app_debug"})
public final class SectionSchema implements java.io.Serializable {
    @androidx.room.ColumnInfo(name = "id")
    @androidx.room.PrimaryKey()
    private int id = 0;
    @org.jetbrains.annotations.Nullable()
    @androidx.room.ColumnInfo(name = "title")
    private java.lang.String title;
    @org.jetbrains.annotations.Nullable()
    @androidx.room.ColumnInfo(name = "course_id")
    private java.lang.Integer course_id;
    @org.jetbrains.annotations.Nullable()
    @androidx.room.ColumnInfo(name = "order")
    private java.lang.Integer order;
    @org.jetbrains.annotations.Nullable()
    @androidx.room.ColumnInfo(name = "lessons")
    private java.util.List<school.mero.lms.JSONSchemas.LessonSchema> lessons;
    @androidx.room.ColumnInfo(name = "completed_lesson_number")
    private int completed_lesson_number = 0;
    @org.jetbrains.annotations.Nullable()
    @androidx.room.ColumnInfo(name = "user_validity")
    private java.lang.Boolean user_validity;
    @org.jetbrains.annotations.Nullable()
    @androidx.room.ColumnInfo(name = "total_duration")
    private java.lang.String total_duration;
    @androidx.room.ColumnInfo(name = "lesson_counter_starts")
    private int lesson_counter_starts = 0;
    @org.jetbrains.annotations.Nullable()
    @androidx.room.ColumnInfo(name = "lesson_counter_ends")
    private java.lang.Integer lesson_counter_ends;
    @org.jetbrains.annotations.NotNull()
    @androidx.room.ColumnInfo(name = "encoded_token")
    private java.lang.String encoded_token = "";
    
    public SectionSchema() {
        super();
    }
    
    public final int getId() {
        return 0;
    }
    
    public final void setId(int p0) {
    }
    
    @org.jetbrains.annotations.Nullable()
    public final java.lang.String getTitle() {
        return null;
    }
    
    public final void setTitle(@org.jetbrains.annotations.Nullable()
    java.lang.String p0) {
    }
    
    @org.jetbrains.annotations.Nullable()
    public final java.lang.Integer getCourse_id() {
        return null;
    }
    
    public final void setCourse_id(@org.jetbrains.annotations.Nullable()
    java.lang.Integer p0) {
    }
    
    @org.jetbrains.annotations.Nullable()
    public final java.lang.Integer getOrder() {
        return null;
    }
    
    public final void setOrder(@org.jetbrains.annotations.Nullable()
    java.lang.Integer p0) {
    }
    
    @org.jetbrains.annotations.Nullable()
    public final java.util.List<school.mero.lms.JSONSchemas.LessonSchema> getLessons() {
        return null;
    }
    
    public final void setLessons(@org.jetbrains.annotations.Nullable()
    java.util.List<school.mero.lms.JSONSchemas.LessonSchema> p0) {
    }
    
    public final int getCompleted_lesson_number() {
        return 0;
    }
    
    public final void setCompleted_lesson_number(int p0) {
    }
    
    @org.jetbrains.annotations.Nullable()
    public final java.lang.Boolean getUser_validity() {
        return null;
    }
    
    public final void setUser_validity(@org.jetbrains.annotations.Nullable()
    java.lang.Boolean p0) {
    }
    
    @org.jetbrains.annotations.Nullable()
    public final java.lang.String getTotal_duration() {
        return null;
    }
    
    public final void setTotal_duration(@org.jetbrains.annotations.Nullable()
    java.lang.String p0) {
    }
    
    public final int getLesson_counter_starts() {
        return 0;
    }
    
    public final void setLesson_counter_starts(int p0) {
    }
    
    @org.jetbrains.annotations.Nullable()
    public final java.lang.Integer getLesson_counter_ends() {
        return null;
    }
    
    public final void setLesson_counter_ends(@org.jetbrains.annotations.Nullable()
    java.lang.Integer p0) {
    }
    
    @org.jetbrains.annotations.NotNull()
    public final java.lang.String getEncoded_token() {
        return null;
    }
    
    public final void setEncoded_token(@org.jetbrains.annotations.NotNull()
    java.lang.String p0) {
    }
}