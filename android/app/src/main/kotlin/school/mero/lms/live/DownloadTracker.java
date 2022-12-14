/*
 * Copyright (C) 2017 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package school.mero.lms.live;

import static com.google.android.exoplayer2.util.Assertions.checkNotNull;

import android.content.Context;
import android.content.DialogInterface;
import android.net.Uri;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.FragmentManager;

import com.google.android.exoplayer2.Format;
import com.google.android.exoplayer2.MediaItem;
import com.google.android.exoplayer2.RenderersFactory;
import com.google.android.exoplayer2.drm.DrmInitData;
import com.google.android.exoplayer2.drm.DrmSession;
import com.google.android.exoplayer2.offline.Download;
import com.google.android.exoplayer2.offline.DownloadCursor;
import com.google.android.exoplayer2.offline.DownloadHelper;
import com.google.android.exoplayer2.offline.DownloadHelper.LiveContentUnsupportedException;
import com.google.android.exoplayer2.offline.DownloadIndex;
import com.google.android.exoplayer2.offline.DownloadManager;
import com.google.android.exoplayer2.offline.DownloadRequest;
import com.google.android.exoplayer2.offline.DownloadService;
import com.google.android.exoplayer2.source.TrackGroup;
import com.google.android.exoplayer2.source.TrackGroupArray;
import com.google.android.exoplayer2.trackselection.DefaultTrackSelector;
import com.google.android.exoplayer2.trackselection.MappingTrackSelector.MappedTrackInfo;
import com.google.android.exoplayer2.upstream.HttpDataSource;
import com.google.android.exoplayer2.util.Log;
import com.google.android.exoplayer2.util.Util;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.CopyOnWriteArraySet;

import school.mero.lms.R;
import school.mero.lms.courseCache.TrackSelectionDialog;

/** Tracks media that has been downloaded. */
public class DownloadTracker {

  /** Listens for changes in the tracked downloads. */
  public interface Listener {

    /** Called when the tracked downloads changed. */
    void onDownloadsChanged();
    void onDownloadsChanged(Download downloads);
    void dismiss();
  }

  private static final String TAG = "DownloadTracker";

  private final Context context;
  private final HttpDataSource.Factory httpDataSourceFactory;
  private final CopyOnWriteArraySet<Listener> listeners;
  private final HashMap<Uri, Download> downloads;
  private final DownloadIndex downloadIndex;
  private final DefaultTrackSelector.Parameters trackSelectorParameters;

//  @Nullable private StartDownloadDialogHelper startDownloadDialogHelper;
  @Nullable private StartDownloadWithOutHelper startDownloadWithOutHelper;

  public DownloadTracker(
      Context context,
      HttpDataSource.Factory httpDataSourceFactory,
      DownloadManager downloadManager) {
    this.context = context.getApplicationContext();
    this.httpDataSourceFactory = httpDataSourceFactory;
    listeners = new CopyOnWriteArraySet<>();
    downloads = new HashMap<>();
    downloadIndex = downloadManager.getDownloadIndex();
    trackSelectorParameters = DownloadHelper.getDefaultTrackSelectorParameters(context);
    
    
    downloadManager.addListener(new DownloadManagerListener());
    loadDownloads();
  }

  public void addListener(Listener listener) {
    checkNotNull(listener);
    listeners.add(listener);
  }

  public HashMap<Uri, Download> getDownloads() {
    return downloads;
  }

  public void removeListener(Listener listener) {
    listeners.remove(listener);
  }

  public boolean isDownloaded(MediaItem mediaItem) {
    @Nullable Download download = downloads.get(checkNotNull(mediaItem.playbackProperties).uri);
    return download != null && download.state != Download.STATE_FAILED;
  }


  public boolean isDownloadedUrl(Uri uri) {
    @Nullable Download download = downloads.get(uri);
    return download != null && download.state != Download.STATE_FAILED;
  }
  @Nullable
  public DownloadRequest getDownloadRequest(Uri uri) {
    @Nullable Download download = downloads.get(uri);
    return download != null && download.state != Download.STATE_FAILED ? download.request : null;
  }

//  public void toggleDownload(
//          FragmentManager fragmentManager, MediaItem mediaItem, RenderersFactory renderersFactory) {
//
//
//    @Nullable Download download = downloads.get(checkNotNull(mediaItem.playbackProperties).uri);
//
//    
//
//    if (download != null && download.state != Download.STATE_FAILED) {
//      DownloadService.sendRemoveDownload(
//          context, DemoDownloadService.class, download.request.id, /* foreground= */ false);
//    } else {
//
//
//      try {
//        if (startDownloadDialogHelper != null) {
//          startDownloadDialogHelper.release();
//        }
//      } catch (Exception e) {
//        e.printStackTrace();
//      }
//
//
//      startDownloadDialogHelper =
//          new StartDownloadDialogHelper(
//              fragmentManager,
//              DownloadHelper.forMediaItem(
//                  context, mediaItem, renderersFactory, httpDataSourceFactory),
//              mediaItem);
//    }
//  }


  public void startAutoDownload(MediaItem mediaItem, RenderersFactory renderersFactory, String token){





    @Nullable Download download = downloads.get(checkNotNull(mediaItem.playbackProperties).uri);

    if (download != null && download.state != Download.STATE_FAILED) {

      
    } else {
      Log.d("Download543", "Ready to start auto download");


      Map<String, String> map = new HashMap<String, String>();
      map.put("Authorization", ""+token);  //strickly add


      HttpDataSource.Factory factory = httpDataSourceFactory;
      factory.getDefaultRequestProperties().set(map);





      startDownloadWithOutHelper = new StartDownloadWithOutHelper(
                      DownloadHelper.forMediaItem(
                              context, mediaItem, renderersFactory, factory),
                      mediaItem);


    }
      //      DownloadRequest downloadRequest = buildDownloadRequest();
  }

  private void loadDownloads() {
    try (DownloadCursor loadedDownloads = downloadIndex.getDownloads()) {
      while (loadedDownloads.moveToNext()) {
        Download download = loadedDownloads.getDownload();
        downloads.put(download.request.uri, download);
      }
    } catch (IOException e) {
      Log.w(TAG, "Failed to query downloads", e);
    }
  }

  private class DownloadManagerListener implements DownloadManager.Listener {

    @Override
    public void onDownloadChanged(
        @NonNull DownloadManager downloadManager,
        @NonNull Download download,
        @Nullable Exception finalException) {
        downloads.put(download.request.uri, download);
        
      for (Listener listener : listeners) {
              listener.onDownloadsChanged();
              listener.onDownloadsChanged(download);
      }
      
      
    }
    
    
    

    @Override
    public void onDownloadRemoved(
            @NonNull DownloadManager downloadManager, @NonNull Download download) {
      downloads.remove(download.request.uri);
      for (Listener listener : listeners) {
        listener.onDownloadsChanged();
      }
    }
  }

//  private final class StartDownloadDialogHelper
//      implements DownloadHelper.Callback,
//          DialogInterface.OnClickListener,
//          DialogInterface.OnDismissListener {
//
//    private final FragmentManager fragmentManager;
//    private final DownloadHelper downloadHelper;
//    private final MediaItem mediaItem;
//
//    private TrackSelectionDialog trackSelectionDialog;
//    private MappedTrackInfo mappedTrackInfo;
//
//    @Nullable private byte[] keySetId;
//
//    public StartDownloadDialogHelper(
//            FragmentManager fragmentManager, DownloadHelper downloadHelper, MediaItem mediaItem) {
//      this.fragmentManager = fragmentManager;
//      this.downloadHelper = downloadHelper;
//      this.mediaItem = mediaItem;
//      downloadHelper.prepare(this);
//    }
//
//
//
//
//
//
//
//
//    public void release() {
//      try {
//        downloadHelper.release();
//        if (trackSelectionDialog != null) {
//          trackSelectionDialog.dismiss();
//
//        }
//      } catch (Exception e) {
//        e.printStackTrace();
//      }
//
//    }
//
//
//    // DownloadHelper.Callback implementation.
//
//    @Override
//    public void onPrepared(@NonNull DownloadHelper helper) {
//      @Nullable Format format = getFirstFormatWithDrmInitData(helper);
//      if (format == null) {
//        onDownloadPrepared(helper);
//        return;
//      }
//
//      // The content is DRM protected. We need to acquire an offline license.
//      if (Util.SDK_INT < 18) {
//
//        Toast.makeText(context, R.string.error_drm_unsupported_before_api_18, Toast.LENGTH_LONG)
//            .show();
//        Log.e(TAG, "Downloading DRM protected content is not supported on API versions below 18");
//        return;
//      }
//      // TODO(internal b/163107948): Support cases where DrmInitData are not in the manifest.
//      if (!hasSchemaData(format.drmInitData)) {
//        Toast.makeText(context, R.string.download_start_error_offline_license, Toast.LENGTH_LONG)
//            .show();
//        Log.e(
//            TAG,
//            "Downloading content where DRM scheme data is not located in the manifest is not"
//                + " supported");
//        return;
//      }
//
//    }
//
//    @Override
//    public void onPrepareError(@NonNull DownloadHelper helper, @NonNull IOException e) {
//      boolean isLiveContent = e instanceof LiveContentUnsupportedException;
//      int toastStringId =
//          isLiveContent ? R.string.download_live_unsupported : R.string.download_start_error;
//      String logMessage =
//          isLiveContent ? "Downloading live content unsupported" : "Failed to start download";
//      Toast.makeText(context, toastStringId, Toast.LENGTH_LONG).show();
//      Log.e(TAG, logMessage, e);
//    }
//
//    // DialogInterface.OnClickListener implementation.
//
//    @Override
//    public void onClick(DialogInterface dialog, int which) {
//      for (int periodIndex = 0; periodIndex < downloadHelper.getPeriodCount(); periodIndex++) {
//        downloadHelper.clearTrackSelections(periodIndex);
//        for (int i = 0; i < mappedTrackInfo.getRendererCount(); i++) {
//          if (!trackSelectionDialog.getIsDisabled(/* rendererIndex= */ i)) {
//            downloadHelper.addTrackSelectionForSingleRenderer(
//                periodIndex,
//                /* rendererIndex= */ i,
//                trackSelectorParameters,
//                trackSelectionDialog.getOverrides(/* rendererIndex= */ i));
//          }
//        }
//      }
//      DownloadRequest downloadRequest = buildDownloadRequest();
//      if (downloadRequest.streamKeys.isEmpty()) {
//        // All tracks were deselected in the dialog. Don't start the download.
//        return;
//      }
//      startDownload(downloadRequest);
//    }
//
//    // DialogInterface.OnDismissListener implementation.
//
//    @Override
//    public void onDismiss(DialogInterface dialogInterface) {
//      trackSelectionDialog = null;
//      downloadHelper.release();
//
//
//      for (Listener listener : listeners) {
//        listener.dismiss();
//
//      }
//
//
//    }
//
//    // Internal methods.
//
//    /**
//     * Returns the first {@link Format} with a non-null {@link Format#drmInitData} found in the
//     * content's tracks, or null if none is found.
//     */
//    @Nullable
//    private Format getFirstFormatWithDrmInitData(DownloadHelper helper) {
//      for (int periodIndex = 0; periodIndex < helper.getPeriodCount(); periodIndex++) {
//        MappedTrackInfo mappedTrackInfo = helper.getMappedTrackInfo(periodIndex);
//        for (int rendererIndex = 0;
//            rendererIndex < mappedTrackInfo.getRendererCount();
//            rendererIndex++) {
//          TrackGroupArray trackGroups = mappedTrackInfo.getTrackGroups(rendererIndex);
//          for (int trackGroupIndex = 0; trackGroupIndex < trackGroups.length; trackGroupIndex++) {
//            TrackGroup trackGroup = trackGroups.get(trackGroupIndex);
//            for (int formatIndex = 0; formatIndex < trackGroup.length; formatIndex++) {
//              Format format = trackGroup.getFormat(formatIndex);
//              if (format.drmInitData != null) {
//                return format;
//              }
//            }
//          }
//        }
//      }
//      return null;
//    }
//
//    private void onOfflineLicenseFetched(DownloadHelper helper, byte[] keySetId) {
//      this.keySetId = keySetId;
//      onDownloadPrepared(helper);
//    }
//
//    private void onOfflineLicenseFetchedError(DrmSession.DrmSessionException e) {
//      Toast.makeText(context, R.string.download_start_error_offline_license, Toast.LENGTH_LONG)
//          .show();
//      Log.e(TAG, "Failed to fetch offline DRM license", e);
//    }
//
//    private void onDownloadPrepared(DownloadHelper helper) {
//      try {
//        if (helper.getPeriodCount() == 0) {
//          Log.d(TAG, "No periods found. Downloading entire stream.");
//          startDownload();
//          downloadHelper.release();
//          return;
//        }
//
//        mappedTrackInfo = downloadHelper.getMappedTrackInfo(/* periodIndex= */ 0);
//        if (!TrackSelectionDialog.willHaveContent(mappedTrackInfo)) {
//          Log.d(TAG, "No dialog content. Downloading entire stream.");
//          startDownload();
//          downloadHelper.release();
//          return;
//        }
//        trackSelectionDialog =
//            TrackSelectionDialog.createForMappedTrackInfoAndParameters(
//                /* titleId= */ R.string.exo_download_description,
//                mappedTrackInfo,
//                trackSelectorParameters,
//                /* allowAdaptiveSelections =*/ false,
//                /* allowMultipleOverrides= */ false,  //here is true for multiple
//                /* onClickListener= */ this,
//                /* onDismissListener= */ this);
//        trackSelectionDialog.show(fragmentManager, /* tag= */ null);
//      } catch (Exception e) {
//        e.printStackTrace();
//      }
//    }
//
//    /**
//     * Returns whether any the {@link DrmInitData.SchemeData} contained in {@code drmInitData} has
//     * non-null {@link DrmInitData.SchemeData#data}.
//     */
//    private boolean hasSchemaData(DrmInitData drmInitData) {
//      for (int i = 0; i < drmInitData.schemeDataCount; i++) {
//        if (drmInitData.get(i).hasData()) {
//          return true;
//        }
//      }
//      return false;
//    }
//
//    private void startDownload() {
//      startDownload(buildDownloadRequest());
//    }
//
//    private void startDownload(DownloadRequest downloadRequest) {
//
//      DownloadService.sendAddDownload(
//          context, DemoDownloadService.class, downloadRequest, /* foreground= */ false);
//    }
//
//    private DownloadRequest buildDownloadRequest() {
//      return downloadHelper
//          .getDownloadRequest(Util.getUtf8Bytes(checkNotNull(mediaItem.mediaMetadata.title).toString()))
//          .copyWithKeySetId(keySetId);
//    }
//  }
//


  private final class StartDownloadWithOutHelper
          implements DownloadHelper.Callback
          {

    private final DownloadHelper downloadHelper;
    private final MediaItem mediaItem;

    @Nullable private byte[] keySetId;

    public StartDownloadWithOutHelper(
           DownloadHelper downloadHelper, MediaItem mediaItem) {
      this.downloadHelper = downloadHelper;
      this.mediaItem = mediaItem;
      downloadHelper.prepare(this); 
    }








    public void release() {
      downloadHelper.release();

    }


    // DownloadHelper.Callback implementation.

    @Override
    public void onPrepared(@NonNull DownloadHelper helper) {



      @Nullable Format format = getFirstFormatWithDrmInitData(helper);
      if (format == null) {
        onDownloadPrepared(helper);
        return;
      }

    }

    @Override
    public void onPrepareError(@NonNull DownloadHelper helper, @NonNull IOException e) {
      boolean isLiveContent = e instanceof LiveContentUnsupportedException;
      int toastStringId =
              isLiveContent ? R.string.download_live_unsupported : R.string.download_start_error;
      String logMessage =
              isLiveContent ? "Downloading live content unsupported" : "Failed to start download";
      Toast.makeText(context, toastStringId, Toast.LENGTH_LONG).show();
      Log.e(TAG, logMessage, e);
    }


    // Internal methods.

    /**
     * Returns the first {@link Format} with a non-null {@link Format#drmInitData} found in the
     * content's tracks, or null if none is found.
     */
    @Nullable
    private Format getFirstFormatWithDrmInitData(DownloadHelper helper) {
      for (int periodIndex = 0; periodIndex < helper.getPeriodCount(); periodIndex++) {
        MappedTrackInfo mappedTrackInfo = helper.getMappedTrackInfo(periodIndex);
        for (int rendererIndex = 0;
             rendererIndex < mappedTrackInfo.getRendererCount();
             rendererIndex++) {
          TrackGroupArray trackGroups = mappedTrackInfo.getTrackGroups(rendererIndex);
          for (int trackGroupIndex = 0; trackGroupIndex < trackGroups.length; trackGroupIndex++) {
            TrackGroup trackGroup = trackGroups.get(trackGroupIndex);
            for (int formatIndex = 0; formatIndex < trackGroup.length; formatIndex++) {
              Format format = trackGroup.getFormat(formatIndex);
              if (format.drmInitData != null) {
                return format;
              }
            }
          }
        }
      }
      return null;
    }


    private void onDownloadPrepared(DownloadHelper helper) {
      if (helper.getPeriodCount() == 0) {
        Log.d(TAG, "No periods found. Downloading entire stream.");
        startDownload();
        downloadHelper.release();
        return;
      }


      startDownload();
      downloadHelper.release();

    }

    private void startDownload() {
      startDownload(buildDownloadRequest());
    }

    private void startDownload(DownloadRequest downloadRequest) {

      Log.d("DownloadCLicke", "start dowload");

      DownloadService.sendAddDownload(
              context, DemoDownloadService.class, downloadRequest, /* foreground= */ true);
    }

    private DownloadRequest buildDownloadRequest() {
      Log.d("buildDownloadRequest", "buildDownloadRequest "+ keySetId + " "+ mediaItem.mediaMetadata.title);
      return downloadHelper
              .getDownloadRequest(Util.getUtf8Bytes(checkNotNull(mediaItem.mediaMetadata.title).toString()))
              .copyWithKeySetId(keySetId);
    }
  }



}
