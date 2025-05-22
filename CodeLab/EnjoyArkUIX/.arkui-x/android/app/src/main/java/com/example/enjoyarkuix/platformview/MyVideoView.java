/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
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

package com.example.enjoyarkuix.platformview;

import android.content.Context;
import android.content.res.AssetFileDescriptor;
import android.content.res.AssetManager;
import android.graphics.SurfaceTexture;
import android.media.MediaPlayer;
import android.util.Log;
import android.view.Surface;
import android.view.TextureView;
import android.view.View;

import java.io.IOException;

import ohos.ace.adapter.capability.platformview.IPlatformView;

/**
 * MyVideoView.
 *
 * @since 20
 */
public class MyVideoView implements IPlatformView, TextureView.SurfaceTextureListener {
    private String id = "VideoView";
    private TextureView textureView;
    private MediaPlayer mediaPlayer;
    private Context context;

    public MyVideoView(Context context) {
        this.context = context;
        textureView = new TextureView(context);
        textureView.setSurfaceTextureListener(this);
        initMediaPlayer();
    }

    private void initMediaPlayer() {
        mediaPlayer = new MediaPlayer();
        AssetManager am = context.getAssets();
        try {
            AssetFileDescriptor afd = am.openFd("arkui-x/PlatformView/resources/rawfile/video.mp4");
            mediaPlayer.setDataSource(afd.getFileDescriptor(), afd.getStartOffset(), afd.getLength());
        } catch (IOException e) {
            Log.e("MediaPlayer", "Error setting data source", e);
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