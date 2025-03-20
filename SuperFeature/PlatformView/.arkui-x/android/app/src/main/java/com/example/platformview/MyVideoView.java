package com.example.platformview;

import android.content.Context;
import android.content.res.AssetFileDescriptor;
import android.content.res.AssetManager;
import android.graphics.SurfaceTexture;
import android.media.MediaPlayer;
import android.view.Surface;
import android.view.TextureView;
import android.view.View;

import java.io.IOException;

import ohos.ace.adapter.capability.platformview.IPlatformView;

/**
 * MyVideoView.
 *
 * @since 2025-03-21
 */
public class MyVideoView implements IPlatformView, TextureView.SurfaceTextureListener {
    private String id = "VideoView";
    private TextureView textureView;
    private MediaPlayer mediaPlayer;
    private Context context;

    MyVideoView(Context context) {
        this.context = context;
        textureView = new TextureView(context);
        textureView.setSurfaceTextureListener(this);
        initMediaPlayer();
    }

    private void initMediaPlayer() {
        mediaPlayer = new MediaPlayer();
        AssetManager am = context.getAssets();
        try {
            AssetFileDescriptor afd = am.openFd("arkui-x/entry/resources/rawfile/video.mp4");
            mediaPlayer.setDataSource(afd.getFileDescriptor(), afd.getStartOffset(), afd.getLength());
        } catch (IOException e) {
            e.printStackTrace();
        }
        mediaPlayer.setOnPreparedListener(mp -> {
            mediaPlayer.start();
        });
        mediaPlayer.setLooping(true);
        mediaPlayer.prepareAsync();
    }

    @Override
    public View getView() {
        return textureView;
    }

    @Override
    public void onDispose() {
        if (mediaPlayer != null) {
            mediaPlayer.release();
            mediaPlayer = null;
        }
    }

    @Override
    public String getPlatformViewID() {
        return id;
    }

    @Override
    public void onSurfaceTextureAvailable(SurfaceTexture surface, int width, int height) {
        mediaPlayer.setSurface(new Surface(surface));
    }

    @Override
    public void onSurfaceTextureSizeChanged(SurfaceTexture surface, int width, int height) {

    }

    @Override
    public boolean onSurfaceTextureDestroyed(SurfaceTexture surface) {
        return false;
    }

    @Override
    public void onSurfaceTextureUpdated(SurfaceTexture surface) {

    }
}