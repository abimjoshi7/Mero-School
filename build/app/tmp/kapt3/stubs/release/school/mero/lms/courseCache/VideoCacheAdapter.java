package school.mero.lms.courseCache;

import java.lang.System;

@kotlin.Metadata(mv = {1, 5, 1}, k = 1, d1 = {"\u0000@\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\t\n\u0002\u0010\u000e\n\u0002\b\u0004\u0018\u00002\u000e\u0012\u0004\u0012\u00020\u0002\u0012\u0004\u0012\u00020\u00030\u0001:\u0003\u0017\u0018\u0019B\u0005\u00a2\u0006\u0002\u0010\u0004J\u0018\u0010\u000b\u001a\u00020\f2\u0006\u0010\r\u001a\u00020\u00032\u0006\u0010\u000e\u001a\u00020\u000fH\u0016J\u0018\u0010\u0010\u001a\u00020\u00032\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u000fH\u0016J\n\u0010\u0014\u001a\u00020\u0015*\u00020\u0016R\u001c\u0010\u0005\u001a\u0004\u0018\u00010\u0006X\u0086\u000e\u00a2\u0006\u000e\n\u0000\u001a\u0004\b\u0007\u0010\b\"\u0004\b\t\u0010\n\u00a8\u0006\u001a"}, d2 = {"Lschool/mero/lms/courseCache/VideoCacheAdapter;", "Landroidx/recyclerview/widget/ListAdapter;", "Lschool/mero/lms/courseCache/VideoCache;", "Lschool/mero/lms/courseCache/VideoCacheAdapter$DownloadViewHolder;", "()V", "downloadStatusChange", "Lschool/mero/lms/courseCache/VideoCacheAdapter$DownloadStatusChangesInterface;", "getDownloadStatusChange", "()Lschool/mero/lms/courseCache/VideoCacheAdapter$DownloadStatusChangesInterface;", "setDownloadStatusChange", "(Lschool/mero/lms/courseCache/VideoCacheAdapter$DownloadStatusChangesInterface;)V", "onBindViewHolder", "", "holder", "position", "", "onCreateViewHolder", "parent", "Landroid/view/ViewGroup;", "viewType", "toExpiryDate", "", "", "DownloadStatusChangesInterface", "DownloadViewHolder", "VideoCacheComparator", "app_release"})
public final class VideoCacheAdapter extends androidx.recyclerview.widget.ListAdapter<school.mero.lms.courseCache.VideoCache, school.mero.lms.courseCache.VideoCacheAdapter.DownloadViewHolder> {
    @org.jetbrains.annotations.Nullable()
    private school.mero.lms.courseCache.VideoCacheAdapter.DownloadStatusChangesInterface downloadStatusChange;
    
    public VideoCacheAdapter() {
        super(null);
    }
    
    @org.jetbrains.annotations.Nullable()
    public final school.mero.lms.courseCache.VideoCacheAdapter.DownloadStatusChangesInterface getDownloadStatusChange() {
        return null;
    }
    
    public final void setDownloadStatusChange(@org.jetbrains.annotations.Nullable()
    school.mero.lms.courseCache.VideoCacheAdapter.DownloadStatusChangesInterface p0) {
    }
    
    @org.jetbrains.annotations.NotNull()
    @java.lang.Override()
    public school.mero.lms.courseCache.VideoCacheAdapter.DownloadViewHolder onCreateViewHolder(@org.jetbrains.annotations.NotNull()
    android.view.ViewGroup parent, int viewType) {
        return null;
    }
    
    @java.lang.Override()
    public void onBindViewHolder(@org.jetbrains.annotations.NotNull()
    school.mero.lms.courseCache.VideoCacheAdapter.DownloadViewHolder holder, int position) {
    }
    
    public final long toExpiryDate(@org.jetbrains.annotations.NotNull()
    java.lang.String $this$toExpiryDate) {
        return 0L;
    }
    
    @kotlin.Metadata(mv = {1, 5, 1}, k = 1, d1 = {"\u0000L\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u0006\n\u0002\b\u0003\u0018\u0000 !2\u00020\u0001:\u0001!B\u0017\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u00a2\u0006\u0002\u0010\u0006J\u000e\u0010\u0017\u001a\u00020\u00182\u0006\u0010\u0019\u001a\u00020\bJ\u001f\u0010\u001a\u001a\u00020\u001b2\b\u0010\u001c\u001a\u0004\u0018\u00010\u001d2\b\u0010\u001e\u001a\u0004\u0018\u00010\u001f\u00a2\u0006\u0002\u0010 R\u001c\u0010\u0007\u001a\u0004\u0018\u00010\bX\u0086\u000e\u00a2\u0006\u000e\n\u0000\u001a\u0004\b\t\u0010\n\"\u0004\b\u000b\u0010\fR\u000e\u0010\r\u001a\u00020\u000eX\u0082\u0004\u00a2\u0006\u0002\n\u0000R\u000e\u0010\u000f\u001a\u00020\u000eX\u0082\u0004\u00a2\u0006\u0002\n\u0000R\u000e\u0010\u0010\u001a\u00020\u000eX\u0082\u0004\u00a2\u0006\u0002\n\u0000R\u000e\u0010\u0011\u001a\u00020\u000eX\u0082\u0004\u00a2\u0006\u0002\n\u0000R\u000e\u0010\u0012\u001a\u00020\u0013X\u0082\u0004\u00a2\u0006\u0002\n\u0000R\u000e\u0010\u0014\u001a\u00020\u0013X\u0082\u0004\u00a2\u0006\u0002\n\u0000R\u000e\u0010\u0015\u001a\u00020\u0013X\u0082\u0004\u00a2\u0006\u0002\n\u0000R\u000e\u0010\u0016\u001a\u00020\u0013X\u0082\u0004\u00a2\u0006\u0002\n\u0000\u00a8\u0006\""}, d2 = {"Lschool/mero/lms/courseCache/VideoCacheAdapter$DownloadViewHolder;", "Landroidx/recyclerview/widget/RecyclerView$ViewHolder;", "itemView", "Landroid/view/View;", "clickListener", "Lschool/mero/lms/courseCache/VideoCacheAdapter$DownloadStatusChangesInterface;", "(Landroid/view/View;Lschool/mero/lms/courseCache/VideoCacheAdapter$DownloadStatusChangesInterface;)V", "data", "Lschool/mero/lms/courseCache/VideoCache;", "getData", "()Lschool/mero/lms/courseCache/VideoCache;", "setData", "(Lschool/mero/lms/courseCache/VideoCache;)V", "icPause", "Landroidx/appcompat/widget/AppCompatImageView;", "icPlay", "icRefresh", "icStop", "statusTextView", "Landroid/widget/TextView;", "txtDuration", "txtSubtitle", "txtTitle", "bind", "", "downloads", "getStateName", "", "state", "", "percent", "", "(Ljava/lang/Integer;Ljava/lang/Double;)Ljava/lang/String;", "Companion", "app_release"})
    public static final class DownloadViewHolder extends androidx.recyclerview.widget.RecyclerView.ViewHolder {
        private final android.widget.TextView txtTitle = null;
        private final android.widget.TextView txtSubtitle = null;
        private final android.widget.TextView txtDuration = null;
        private final android.widget.TextView statusTextView = null;
        private final androidx.appcompat.widget.AppCompatImageView icPlay = null;
        private final androidx.appcompat.widget.AppCompatImageView icPause = null;
        private final androidx.appcompat.widget.AppCompatImageView icStop = null;
        private final androidx.appcompat.widget.AppCompatImageView icRefresh = null;
        @org.jetbrains.annotations.Nullable()
        private school.mero.lms.courseCache.VideoCache data;
        @org.jetbrains.annotations.NotNull()
        public static final school.mero.lms.courseCache.VideoCacheAdapter.DownloadViewHolder.Companion Companion = null;
        
        public DownloadViewHolder(@org.jetbrains.annotations.NotNull()
        android.view.View itemView, @org.jetbrains.annotations.Nullable()
        school.mero.lms.courseCache.VideoCacheAdapter.DownloadStatusChangesInterface clickListener) {
            super(null);
        }
        
        @org.jetbrains.annotations.Nullable()
        public final school.mero.lms.courseCache.VideoCache getData() {
            return null;
        }
        
        public final void setData(@org.jetbrains.annotations.Nullable()
        school.mero.lms.courseCache.VideoCache p0) {
        }
        
        @org.jetbrains.annotations.NotNull()
        public final java.lang.String getStateName(@org.jetbrains.annotations.Nullable()
        java.lang.Integer state, @org.jetbrains.annotations.Nullable()
        java.lang.Double percent) {
            return null;
        }
        
        public final void bind(@org.jetbrains.annotations.NotNull()
        school.mero.lms.courseCache.VideoCache downloads) {
        }
        
        @kotlin.Metadata(mv = {1, 5, 1}, k = 1, d1 = {"\u0000\u001e\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002\u00a2\u0006\u0002\u0010\u0002J\u0018\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00062\b\u0010\u0007\u001a\u0004\u0018\u00010\b\u00a8\u0006\t"}, d2 = {"Lschool/mero/lms/courseCache/VideoCacheAdapter$DownloadViewHolder$Companion;", "", "()V", "create", "Lschool/mero/lms/courseCache/VideoCacheAdapter$DownloadViewHolder;", "parent", "Landroid/view/ViewGroup;", "clickListener", "Lschool/mero/lms/courseCache/VideoCacheAdapter$DownloadStatusChangesInterface;", "app_release"})
        public static final class Companion {
            
            private Companion() {
                super();
            }
            
            @org.jetbrains.annotations.NotNull()
            public final school.mero.lms.courseCache.VideoCacheAdapter.DownloadViewHolder create(@org.jetbrains.annotations.NotNull()
            android.view.ViewGroup parent, @org.jetbrains.annotations.Nullable()
            school.mero.lms.courseCache.VideoCacheAdapter.DownloadStatusChangesInterface clickListener) {
                return null;
            }
        }
    }
    
    @kotlin.Metadata(mv = {1, 5, 1}, k = 1, d1 = {"\u0000\u0018\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\u0004\u0018\u00002\b\u0012\u0004\u0012\u00020\u00020\u0001B\u0005\u00a2\u0006\u0002\u0010\u0003J\u0018\u0010\u0004\u001a\u00020\u00052\u0006\u0010\u0006\u001a\u00020\u00022\u0006\u0010\u0007\u001a\u00020\u0002H\u0016J\u0018\u0010\b\u001a\u00020\u00052\u0006\u0010\u0006\u001a\u00020\u00022\u0006\u0010\u0007\u001a\u00020\u0002H\u0016\u00a8\u0006\t"}, d2 = {"Lschool/mero/lms/courseCache/VideoCacheAdapter$VideoCacheComparator;", "Landroidx/recyclerview/widget/DiffUtil$ItemCallback;", "Lschool/mero/lms/courseCache/VideoCache;", "()V", "areContentsTheSame", "", "oldItem", "newItem", "areItemsTheSame", "app_release"})
    public static final class VideoCacheComparator extends androidx.recyclerview.widget.DiffUtil.ItemCallback<school.mero.lms.courseCache.VideoCache> {
        
        public VideoCacheComparator() {
            super();
        }
        
        @java.lang.Override()
        public boolean areItemsTheSame(@org.jetbrains.annotations.NotNull()
        school.mero.lms.courseCache.VideoCache oldItem, @org.jetbrains.annotations.NotNull()
        school.mero.lms.courseCache.VideoCache newItem) {
            return false;
        }
        
        @java.lang.Override()
        public boolean areContentsTheSame(@org.jetbrains.annotations.NotNull()
        school.mero.lms.courseCache.VideoCache oldItem, @org.jetbrains.annotations.NotNull()
        school.mero.lms.courseCache.VideoCache newItem) {
            return false;
        }
    }
    
    @kotlin.Metadata(mv = {1, 5, 1}, k = 1, d1 = {"\u0000\u001e\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0005\bf\u0018\u00002\u00020\u0001J\u0018\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u00052\u0006\u0010\u0006\u001a\u00020\u0007H&J\u0018\u0010\b\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u00052\u0006\u0010\u0006\u001a\u00020\u0007H&J\u0018\u0010\t\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u00052\u0006\u0010\u0006\u001a\u00020\u0007H&J\u0018\u0010\n\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u00052\u0006\u0010\u0006\u001a\u00020\u0007H&J\u0018\u0010\u000b\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u00052\u0006\u0010\u0006\u001a\u00020\u0007H&\u00a8\u0006\f"}, d2 = {"Lschool/mero/lms/courseCache/VideoCacheAdapter$DownloadStatusChangesInterface;", "", "delete", "", "downloads", "Lschool/mero/lms/courseCache/VideoCache;", "pos", "", "pause", "play", "refresh", "updateProgress", "app_release"})
    public static abstract interface DownloadStatusChangesInterface {
        
        public abstract void updateProgress(@org.jetbrains.annotations.NotNull()
        school.mero.lms.courseCache.VideoCache downloads, int pos);
        
        public abstract void delete(@org.jetbrains.annotations.NotNull()
        school.mero.lms.courseCache.VideoCache downloads, int pos);
        
        public abstract void play(@org.jetbrains.annotations.NotNull()
        school.mero.lms.courseCache.VideoCache downloads, int pos);
        
        public abstract void pause(@org.jetbrains.annotations.NotNull()
        school.mero.lms.courseCache.VideoCache downloads, int pos);
        
        public abstract void refresh(@org.jetbrains.annotations.NotNull()
        school.mero.lms.courseCache.VideoCache downloads, int pos);
    }
}