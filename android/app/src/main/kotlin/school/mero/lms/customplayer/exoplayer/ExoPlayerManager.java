/*
 * Copyright 2016 The Android Open Source Project
 * Copyright 2017 Rúben Sousa
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package school.mero.lms.customplayer.exoplayer;

import static school.mero.lms.ConstKt.SHOW_SPRITES;

import android.util.Log;
import android.widget.ImageView;
import android.widget.Toast;

import com.bumptech.glide.Glide;
import com.github.rubensousa.previewseekbar.PreviewBar;
import com.github.rubensousa.previewseekbar.PreviewLoader;
import com.github.rubensousa.previewseekbar.exoplayer.PreviewTimeBar;

import com.google.android.exoplayer2.ExoPlaybackException;
import com.google.android.exoplayer2.MediaItem;
import com.google.android.exoplayer2.PlaybackException;
import com.google.android.exoplayer2.PlaybackParameters;
import com.google.android.exoplayer2.Player;
import com.google.android.exoplayer2.SeekParameters;
import com.google.android.exoplayer2.SimpleExoPlayer;
import com.google.android.exoplayer2.source.MediaSourceFactory;
import com.google.android.exoplayer2.trackselection.TrackSelector;
import com.google.android.exoplayer2.ui.PlayerControlView;
import com.google.android.exoplayer2.ui.PlayerView;

import school.mero.lms.R;
import school.mero.lms.customplayer.glide.GlideThumbnailTransformation;



public class ExoPlayerManager implements PreviewLoader, PreviewBar.OnScrubListener {

//    private ExoPlayerMediaSourceBuilder mediaSourceBuilder;

    MediaSourceFactory mediaSourceFactory;
    private PlayerView playerView;
    private SimpleExoPlayer player;
    private PreviewTimeBar previewTimeBar;
    private String thumbnailsUrl;

    TrackSelector trackSelector;


    StateListener stateListener;

    private ImageView imageView;
    private boolean resumeVideoOnPreviewStop;






    private  Player.Listener playerListener = new Player.Listener(){

        @Override
        public void onPlaybackStateChanged(int state) {
            if(state == Player.STATE_READY){
                previewTimeBar.hidePreview();
            }
        }


        @Override
        public void onPlayerError(PlaybackException error) {
            try {
                if(error.errorCode == 401){

                    Toast.makeText(playerView.getContext().getApplicationContext(), error.getMessage() + playerView.getContext().getString(R.string.tempory_player_token_expired_please_refresh_the_player), Toast.LENGTH_LONG).show();

                }else{
                    Toast.makeText(playerView.getContext().getApplicationContext(), ""+ error.getMessage(), Toast.LENGTH_SHORT).show();

                }
            } catch (Exception e) {
                Toast.makeText(playerView.getContext().getApplicationContext(), ""+ error.getMessage(), Toast.LENGTH_SHORT).show();
                e.printStackTrace();
            }
        }


    };



    public ExoPlayerManager(PlayerView playerView, MediaSourceFactory mediaSourceFactory, TrackSelector trackSelector,
                            PreviewTimeBar previewTimeBar, ImageView imageView,
                            String thumbnailsUrl, PlayerControlView.VisibilityListener visibilityListener ,StateListener stateListener) {


        this.playerView = playerView;
        this.imageView = imageView;
        this.previewTimeBar = previewTimeBar;
        this.mediaSourceFactory =mediaSourceFactory;
        this.thumbnailsUrl = thumbnailsUrl;
        this.previewTimeBar.addOnScrubListener(this);
        this.previewTimeBar.setPreviewLoader(this);
        this.resumeVideoOnPreviewStop = true;
        this.trackSelector = trackSelector;
        this.stateListener = stateListener;
        this.playerView.setControllerVisibilityListener(visibilityListener);


        createPlayers();







    }


    MediaItem currentMediaItem;

    public  MediaItem currentMediaItem(){
        return  currentMediaItem;
    }

    public void play(MediaItem mediaItem, String thumbnailsUrl) {


        currentMediaItem = mediaItem;


        if(thumbnailsUrl!=null && thumbnailsUrl.contains("master.m3u8")){

            String imageUrl = thumbnailsUrl.replace("master.m3u8", "sprite.jpg");

            Log.d("thumbinalUrl", ""+ imageUrl);

            this.thumbnailsUrl = imageUrl;

        }


        try {
            if(mediaItem != null){
                player.setMediaItem(mediaItem);
                player.prepare();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }


    }

    public void onStart() {
//        if (Util.SDK_INT > 23) {
//            createPlayers();
//        }

        createPlayers();

    }

    public  void playContinue(){
        if(player!=null){
            player.play();
        }
    }


    public void onResume() {
//        if (Util.SDK_INT <= 23) {
//            createPlayers();
//        }

        Log.d("ExoPlayerManager", "OnResume Called");



//        if(player != null){
////            player.play();
//        }else{
//            Log.d("ExoPlayerManager", "OnResume no player initialized");
//
//
//        }

//        createPlayers();

    }

    public void onPause() {
//        if (Util.SDK_INT <= 23) {
//        }
        Log.d("ExoPlayerManager", "on Pause Called");

//        releasePlayers();


        if(player!= null){
            player.pause();

        }



    }

    public void onStop() {
//        if (Util.SDK_INT > 23) {
//        }
        releasePlayers();

    }

    public void setResumeVideoOnPreviewStop(boolean resume) {
        this.resumeVideoOnPreviewStop = resume;
    }

    private void releasePlayers() {
        if (player != null) {
            player.release();
            player = null;
        }
    }

    private void createPlayers() {
        if (player != null) {
            player.release();
        }
        player = createPlayer();
        playerView.setPlayer(player);
        playerView.setControllerShowTimeoutMs(3000);

    }

    private SimpleExoPlayer createPlayer() {
//        SimpleExoPlayer player = new SimpleExoPlayer.Builder(playerView.getContext()).build();
//        player.prepare(mediaSourceBuilder.getMediaSource(false));

        player = new SimpleExoPlayer.Builder(playerView.getContext())
                .setTrackSelector(trackSelector)
                .setMediaSourceFactory(mediaSourceFactory)
                .build();






        player.setSeekParameters(SeekParameters.CLOSEST_SYNC);

        ////Set media controller
        playerView.setUseController(true); //set to true or false to see controllers

        player.setPlayWhenReady(true);

        player.addListener(playerListener);




        return player;
    }




    public void  changeSpeed(float speed){
        try {
            PlaybackParameters parameters = new PlaybackParameters(speed);
            player.setPlaybackParameters(parameters);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void fastForward(){
        try {


            player.seekTo(player.getCurrentPosition() + 5000);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    public void fastBackward(){
        try {

            player.seekTo(player.getCurrentPosition() - 5000);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }





    @Override
    public void loadPreview(long currentPosition, long max) {


        if(SHOW_SPRITES){

            int totalSprite = 10 * 30;

        int possibleInterval  = (int) max / totalSprite;
        int intPos = (int ) currentPosition / possibleInterval;


//
//


            Log.d("thumbUrl", ""+thumbnailsUrl);
        Glide.with(imageView)
                .load(thumbnailsUrl)
                .override(71 * 30, 40 * 10)
                .transform(new GlideThumbnailTransformation(intPos))
                .into(imageView);


        }
//
//
//

    }

    @Override
    public void onScrubStart(PreviewBar previewBar) {
        try {
            player.setPlayWhenReady(true);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onScrubMove(PreviewBar previewBar, int progress, boolean fromUser) {

    }

    @Override
    public void onScrubStop(PreviewBar previewBar) {

//        if(SHOW_SPRITES){
//
//
//        }


        if (resumeVideoOnPreviewStop) {
            player.setPlayWhenReady(true);
        }

//
    }


   public interface  StateListener{
        void onStateChange(int state);
    }
}
