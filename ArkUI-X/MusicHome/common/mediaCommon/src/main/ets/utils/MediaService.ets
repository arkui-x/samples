/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { media } from '@kit.MediaKit';
import { common, wantAgent } from '@kit.AbilityKit';
import { avSession } from '@kit.AVSessionKit';
import { formBindingData, formProvider } from '@kit.FormKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { resourceManager } from '@kit.LocalizationKit';
import { SongConstants } from '@ohos/constantsCommon';
import { AudioPlayerState, MusicPlayMode } from '../viewmodel/MusicData';
import { SongItem } from '../viewmodel/SongData';
import { CardData } from '../viewmodel/CardData';
import { BackgroundTaskManager } from './BackgroundTaskManager/BackgroundTaskManager';
import SongItemBuilder from './SongItemBuilder';
import { PreferencesUtil } from './PreferencesUtil';
import { MediaTools } from './MediaTools';
import { Logger } from './Logger';

const TAG = 'MediaService';

export class MediaService {
  public avPlayer?: media.AVPlayer;
  private context: common.UIAbilityContext | undefined = AppStorage.get('context');
  private session?: avSession.AVSession;
  private songItemBuilder: SongItemBuilder = new SongItemBuilder();
  private songItem: SongItem = new SongItem();
  private playMode: MusicPlayMode = MusicPlayMode.ORDER;
  private state: AudioPlayerState = AudioPlayerState.IDLE;
  private isFirst: boolean = true;
  private isPrepared: boolean = false;
  private musicIndex: number = 0;
  private songList: SongItem[] = [];
  private formIds: string[] = [];
  private isCurrent: boolean = true;
  private seekCall: (seekDoneTime: number) => void = (seekDoneTime: number) => {
    this.isCurrent = true;
    Logger.info(TAG, `AVPlayer seek succeeded, seek time is ${seekDoneTime}`);
    this.setPlayState({
      position: {
        elapsedTime: this.getCurrentTime(),
        updateTime: new Date().getTime()
      }
    });
  };
  private errorCall: (err: BusinessError) => void = (err: BusinessError) => {
    Logger.error(TAG, `Invoke avPlayer failed, code is ${err.code}, message is ${err.message}`);
    this.avPlayer?.reset();
  };
  private updateTimeCall: (updateTime: number) => void = (updateTime: number) => {
    if (this.isCurrent) {
      AppStorage.setOrCreate('currentTime', MediaTools.msToCountdownTime(updateTime));
      AppStorage.setOrCreate<number>('progress', updateTime);
    }
  };
  private stateCall: (state: string) => Promise<void> = async (state: string) => {
    switch (state) {
      case 'idle':
        Logger.info(TAG, 'AVPlayer state idle called.');
        this.state = AudioPlayerState.IDLE;
        this.songItem = await this.songItemBuilder.build(this.songList[this.musicIndex]);
        let url = this.songItemBuilder.getRealUrl();
        if (this.avPlayer && url) {
          let avFileDescriptor: media.AVFileDescriptor = { fd: url.fd, offset: url.offset, length: url.length };
          this.avPlayer.fdSrc = avFileDescriptor;
          Logger.info(TAG, 'loadAsset avPlayer.url:' + this.avPlayer.fdSrc);
        }
        break;
      case 'initialized':
        Logger.info(TAG, 'AVPlayer state initialized called.');
        this.state = AudioPlayerState.INITIALIZED;
        if (this.avPlayer) {
          this.avPlayer.prepare().then(() => {
            Logger.info(TAG, 'AVPlayer prepare succeeded.');
          }, (err: BusinessError) => {
            Logger.error(TAG, `Invoke prepare failed, code is ${err.code}, message is ${err.message}`);
          });
        }
        break;
      case 'prepared':
        Logger.info(TAG, 'AVPlayer state prepared called.');
        this.state = AudioPlayerState.PREPARED;
        this.isPrepared = true;
        if (this.avPlayer) {
          this.avPlayer.play();
        }
        this.setAVMetadata();
        Logger.info(TAG, 'AVPlayer prepared succeeded.');
        break;
      case 'playing':
        Logger.info(TAG, 'AVPlayer state playing called.');
        this.state = AudioPlayerState.PLAY;
        break;
      case 'paused':
        Logger.info(TAG, 'AVPlayer state paused called.');
        this.state = AudioPlayerState.PAUSE;
        break;
      case 'completed':
        Logger.info(TAG, 'AVPlayer state completed called.');
        this.state = AudioPlayerState.COMPLETED;
        this.playNextAuto(false);
        break;
      case 'stopped':
        Logger.info(TAG, 'AVPlayer state stopped called.');
        this.state = AudioPlayerState.STOP;
        if (this.avPlayer) {
          this.avPlayer.reset();
        }
        break;
      case 'released':
        Logger.info(TAG, 'AVPlayer state released called.');
        this.state = AudioPlayerState.RELEASED;
        break;
      default:
        Logger.info(TAG, 'AVPlayer state unknown called.');
        this.state = AudioPlayerState.UNKNOWN;
        break;
    }
    this.updateCardData();
    this.updateIsPlay(this.state === AudioPlayerState.PLAY);
  };
  private playCall: () => void = () => {
    Logger.info(TAG, `on play , do play task`);
    if (this.isFirst) {
      this.loadAssent(0);
    } else {
      this.play();
    }
  };
  private pauseCall: () => void = () => {
    Logger.info(TAG, `on pause , do pause task`);
    this.pause();
  };
  private playNextCall: () => void = () => {
    Logger.info(TAG, `on playNext , do playNext task`);
    this.playNextAuto(true);
  };
  private playPreviousCall: () => void = () => {
    Logger.info(TAG, `on playPrevious , do playPrevious task`);
    this.playPrevious();
  };
  private durationUpdateCall: (time: number) => void = (time: number) => {
    if (time > 0) {
      AppStorage.setOrCreate('totalTime', MediaTools.msToCountdownTime(time));
      AppStorage.setOrCreate('progressMax', time);
    } else {
      Logger.info(TAG, `on durationUpdate , get time failed or now is currently live.`);
    }
  };

  private setAVPlayerCallback() {
    if (!this.avPlayer) {
      return;
    }
    this.avPlayer.on('seekDone', this.seekCall);

    this.avPlayer.on('error', this.errorCall);

    this.avPlayer.on('timeUpdate', this.updateTimeCall);

    this.avPlayer.on('stateChange', this.stateCall);

    this.avPlayer.on('durationUpdate', this.durationUpdateCall);
  }

  private async createSession() {
    if (!this.context) {
      return;
    }
    this.session = await avSession.createAVSession(this.context, 'SESSION_NAME', 'audio');
    this.session.activate();
    Logger.info(TAG, `session create done : sessionId : ${this.session.sessionId}`);
    this.setAVMetadata();
    let wantAgentInfo: wantAgent.WantAgentInfo = {
      wants: [
        {
          bundleName: this.context.abilityInfo.bundleName,
          abilityName: this.context.abilityInfo.name
        }
      ],
      operationType: wantAgent.OperationType.START_ABILITIES,
      requestCode: 0,
      wantAgentFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG]
    }
    wantAgent.getWantAgent(wantAgentInfo).then((agent) => {
      if (this.session) {
        this.session.setLaunchAbility(agent);
      }
    })
    this.setListenerForMesFromController();
  }

  private initAudioPlayer() {
    media.createAVPlayer().then(async avPlayer => {
      if (avPlayer !== null) {
        this.avPlayer = avPlayer;
        this.setAVPlayerCallback();
        this.createSession();
      }
    }).catch((error: BusinessError) => {
      Logger.error(TAG, 'this avPlayer: ', `catch error happened,error code is ${error.code}`)
    })
  }

  private async setListenerForMesFromController() {
    if (!this.session) {
      return;
    }
    this.session.on('play', this.playCall);
    this.session.on('pause', this.pauseCall);
    this.session.on('playNext', this.playNextCall);
    this.session.on('playPrevious', this.playPreviousCall);
  }

  private async unregisterSessionListener() {
    if (!this.session) {
      return;
    }
    this.session.off('play');
    this.session.off('pause');
    this.session.off('playNext');
    this.session.off('playPrevious');
  }

  private async setAVMetadata() {
    let id = this.musicIndex;
    try {
      if (this.context) {
        let mediaImage = await MediaTools.getPixelMapFromResource(this.context,
          this.songList[this.musicIndex].label as resourceManager.Resource);
        Logger.info(TAG, 'getPixelMapFromResource success' + JSON.stringify(mediaImage));
        let metadata: avSession.AVMetadata = {
          assetId: `${id}`,
          title: this.songList[this.musicIndex].title,
          artist: this.songList[this.musicIndex].singer,
          mediaImage: mediaImage,
          duration: this.getDuration()
        };
        if (this.session) {
          this.session.setAVMetadata(metadata).then(() => {
            Logger.info(TAG, 'SetAVMetadata successfully');
          }).catch((err: BusinessError) => {
            Logger.error(TAG, `SetAVMetadata BusinessError: code: ${err.code}, message: ${err.message}`);
          });
        }
      }
    } catch (error) {
      Logger.error(TAG, `SetAVMetadata try: code: ${(error as BusinessError).code},
       message: ${(error as BusinessError).message}`);
    }
  }

  private updateIsPlay(isPlay: boolean) {
    AppStorage.setOrCreate<boolean>('isPlay', isPlay);
    this.setPlayState({
      state: isPlay ? avSession.PlaybackState.PLAYBACK_STATE_PLAY : avSession.PlaybackState.PLAYBACK_STATE_PAUSE,
      position: {
        elapsedTime: this.getCurrentTime(),
        updateTime: new Date().getTime()
      }
    });
  }

  private getCurrentTime() {
    if (this.isPrepared && this.avPlayer) {
      return this.avPlayer.currentTime;
    }
    return 0;
  }

  private getDuration() {
    if (this.isPrepared && this.avPlayer) {
      return this.avPlayer.duration;
    }
    return 0;
  }

  private start(seekMs?: number) {
    Logger.info(TAG, 'AVPlayer play() isPrepared:' + this.isPrepared + ', state:' + this.state + '，seek:' + seekMs);
    if (this.avPlayer) {
      this.avPlayer.prepare().then(() => {
      }).catch((error: BusinessError) => {
        Logger.error(TAG, `start error ${JSON.stringify(error)}`)
        this.state = AudioPlayerState.ERROR;
        this.updateIsPlay(false);
        this.isPrepared = false;
      });
    }
  }

  private playNext() {
    Logger.info(TAG, 'playNext Index:' + this.musicIndex + ', length-1:' + (this.songList.length - 1));
    if (this.musicIndex === this.songList.length - 1) {
      this.loadAssent(0);
    } else {
      this.loadAssent(this.musicIndex + 1);
    }
  }

  private playRandom() {
    let num = Math.round(Math.random() * (this.songList.length - 1));
    if (this.musicIndex === num) {
      this.playRandom();
    } else {
      this.updateMusicIndex(num);
      this.loadAssent(num);
    }
    Logger.info(TAG, 'play Random:' + this.musicIndex);
  }

  private async reset() {
    Logger.info(TAG, 'reset()');
    await this.songItemBuilder.release();
    if (this.avPlayer) {
      await this.avPlayer.reset();
    }
    this.isPrepared = false;
  }

  private updateMusicIndex(musicIndex: number) {
    Logger.info(TAG, 'updateMusicIndex ===> ' + musicIndex);
    AppStorage.setOrCreate('selectIndex', musicIndex);
    if (this.musicIndex !== musicIndex) {
      this.musicIndex = musicIndex;
    }
    Logger.info(TAG, 'this.session !== undefined ===> ' + (this.session != undefined));
    if (this.session !== undefined) {
      this.setAVMetadata();
    }
  }

  private async setPlayState(playbackState: avSession.AVPlaybackState) {
    if (this.session) {
      this.session.setAVPlaybackState(playbackState, (err: BusinessError) => {
        if (err) {
          Logger.info(TAG, `SetAVPlaybackState BusinessError: code: ${err.code}, message: ${err.message}`);
        } else {
          Logger.info(TAG, 'SetAVPlaybackState successfully');
        }
      });
    }
  }

  private constructor() {
    let list: SongItem[] | undefined = AppStorage.get('songList');
    if (list) {
      this.songList = list;
    }
    this.songItemBuilder = new SongItemBuilder();
    this.initAudioPlayer();
  }

  public static getInstance(): MediaService {
    let mediaService: MediaService | undefined = AppStorage.get('mediaService');
    if (!mediaService) {
      mediaService = new MediaService();
      AppStorage.setOrCreate('mediaService', mediaService);
    }
    return mediaService;
  }

  /**
   * Play music by index.
   *
   * @param musicIndex
   */
  public async loadAssent(musicIndex: number) {
    if (musicIndex >= this.songList.length) {
      Logger.error(TAG, `current musicIndex ${musicIndex}`);
      return;
    }
    if (this.context != undefined) {
      BackgroundTaskManager.getBackgroundTaskManager().startContinuousTask(this.context);
    }
    this.updateMusicIndex(musicIndex);
    if (this.isFirst && this.avPlayer) {
      this.isFirst = false;
      this.songItem = await this.songItemBuilder.build(this.songList[this.musicIndex]);
      let url = this.songItemBuilder.getRealUrl();
      if (url) {
        let avFileDescriptor: media.AVFileDescriptor = { fd: url.fd, offset: url.offset, length: url.length };
        this.avPlayer.fdSrc = avFileDescriptor;
        Logger.info(TAG, 'loadAsset avPlayer.url:' + this.avPlayer.fdSrc);
      }
    } else {
      await this.stop();
    }
  }

  /**
   * Get whether the music is played for the first.
   *
   * @returns isFirst
   */
  public getFirst() {
    return this.isFirst;
  }

  /**
   * Set music play mode.
   *
   * @param playMode
   */
  public setPlayModel(playMode: MusicPlayMode) {
    this.playMode = playMode;
    Logger.info(TAG, 'setPlayModel mode: ' + this.playMode);
  }

  /**
   * Get music play mode.
   *
   * @returns playMode.
   */
  public getPlayMode() {
    return this.playMode;
  }

  /**
   * Seek play music.
   *
   * @param ms.
   */
  public seek(ms: number) {
    if (this.isPrepared && this.state != AudioPlayerState.ERROR && this.avPlayer) {
      let seekMode = this.getCurrentTime() < ms ? 0 : 1;
      let realTime = (ms <= 0 ? 0 : (ms >= this.getDuration() ? this.getDuration() : ms));
      this.isCurrent = false;
      this.avPlayer.seek(realTime, seekMode);
    }
  }

  /**
   * Play music.
   */
  public async play() {
    Logger.info(TAG, 'AVPlayer play() isPrepared:' + this.isPrepared + ', state:' + this.state);
    if (this.context != undefined) {
      BackgroundTaskManager.getBackgroundTaskManager().startContinuousTask(this.context);
    }
    if (!this.isPrepared) {
      this.start(0);
    } else if (this.avPlayer) {
      this.avPlayer.play().then(() => {
        Logger.info(TAG, 'progressTime play() current time:' + this.getCurrentTime());
        this.seek(this.getCurrentTime());
        this.updateIsPlay(true);
        this.state = AudioPlayerState.PLAY;
      })
    }
  }

  /**
   * Pause music.
   */
  public pause() {
    Logger.info(TAG, 'AVPlayer pause() isPrepared:' + this.isPrepared + ', state:' + this.state);
    if (this.isPrepared && this.state === AudioPlayerState.PLAY && this.avPlayer) {
      this.avPlayer.pause().then(() => {
        this.state = AudioPlayerState.PAUSE;
        this.updateIsPlay(false);
      });
    }
  }

  /**
   * Play next music.
   *
   * @param isFromControl
   */
  public playNextAuto(isFromControl: boolean) {
    Logger.info(TAG, 'playNextAuto mode:' + this.playMode);
    switch (this.playMode) {
      case MusicPlayMode.SINGLE_CYCLE:
        if (isFromControl) {
          this.playNext();
        } else if (this.avPlayer) {
          this.avPlayer.play();
        }
        break;
      case MusicPlayMode.ORDER:
        this.playNext();
        break;
      case MusicPlayMode.RANDOM:
        this.playRandom();
        break;
      default:
        break;
    }
  }

  /**
   * Play previous music.
   */
  public playPrevious() {
    switch (this.playMode) {
      case MusicPlayMode.RANDOM:
        this.playRandom();
        break;
      case MusicPlayMode.ORDER:
      case MusicPlayMode.SINGLE_CYCLE:
        if (this.musicIndex === 0) {
          this.updateMusicIndex(this.songList.length - 1);
        } else {
          this.updateMusicIndex(this.musicIndex - 1);
        }
        Logger.info(TAG, 'setLastIndex:' + this.musicIndex);
        this.loadAssent(this.musicIndex);
        break;
      default:
        break;
    }
  }

  /**
   * Stop music
   */
  public async stop() {
    Logger.info(TAG, 'stop()');
    if (this.isPrepared && this.avPlayer) {
      await this.avPlayer.stop();
      this.updateIsPlay(false);
      this.state = AudioPlayerState.PAUSE;
    }
  }

  /**
   * release avPlayer.
   */
  public release() {
    if (this.avPlayer && this.session && this.context) {
      this.updateIsPlay(false);
      this.stop();
      this.reset();
      this.avPlayer.release();
      this.state = AudioPlayerState.IDLE;
      if (this.context != undefined) {
        BackgroundTaskManager.getBackgroundTaskManager().stopContinuousTask(this.context);
      }
      this.unregisterSessionListener();
      this.session.destroy((err: BusinessError) => {
        if (err) {
          Logger.error(TAG, `Failed to destroy session. Code: ${err.code}, message: ${err.message}`);
        } else {
          Logger.info(TAG, `Destroy : SUCCESS `);
        }
      });
    }
  }

  /**
   * Update card data.
   */
  public async updateCardData() {
    try {
      if (!this.context) {
        return;
      }
      PreferencesUtil.getInstance().removePreferencesFromCache(this.context);
      this.formIds = await PreferencesUtil.getInstance().getFormIds(this.context);
      if (this.formIds === null || this.formIds === undefined) {
        Logger.error(TAG, 'WANG formIds is null');
        return;
      }

      let cardSongList: Array<SongItem> = [];
      if (this.musicIndex + SongConstants.ADD_INDEX_ONE === this.songList.length) {
        cardSongList = this.songList.slice(SongConstants.SLICE_START_ZERO, SongConstants.SLICE_END_THREE);
      } else if (this.musicIndex + SongConstants.ADD_INDEX_TWO === this.songList.length) {
        cardSongList.push(this.songList[this.songList.length - 1]);
        cardSongList.push(this.songList[0]);
        cardSongList.push(this.songList[1]);
      } else if (this.musicIndex + SongConstants.ADD_INDEX_THREE === this.songList.length) {
        cardSongList = this.songList.slice(this.songList.length - SongConstants.SLICE_INDEX_TWO,
          this.songList.length);
        cardSongList.push(this.songList[0]);
      } else {
        cardSongList = this.songList.slice(this.musicIndex + SongConstants.SLICE_INDEX_ONE,
          this.musicIndex + SongConstants.SLICE_INDEX_FOUR);
      }
      let formData: CardData = {
        isPlay: this.state === AudioPlayerState.PLAY,
        musicName: this.songList[this.musicIndex].title,
        musicCover: this.songList[this.musicIndex].label,
        musicSinger: this.songList[this.musicIndex].singer,
        cardSongList: cardSongList
      }
      let formInfo = formBindingData.createFormBindingData(formData);

      this.formIds.forEach(formId => {
        formProvider.updateForm(formId, formInfo).then(() => {
          Logger.info(TAG, 'WANG updateForm data succeed' + ', formId:' + formId);
        }).catch((error: BusinessError) => {
          Logger.error(TAG, 'updateForm err:' + JSON.stringify(error));
          if (error.code === SongConstants.ID_NO_EXIT && this.context) {
            PreferencesUtil.getInstance().removeFormId(this.context, formId);
          }
        })
      })
    } catch (error) {
      Logger.error(TAG, `updateCardData err: ${(error as BusinessError).code}`);
    }
  }

  /**
   * Update card data on destroy.
   */
  public async updateOnDestroy() {
    if (this.formIds === null || this.formIds === undefined) {
      Logger.error(TAG, 'formIds is null');
      return;
    }
    let formData: Record<string, boolean> = {
      'isPlay': false
    }
    let formInfo = formBindingData.createFormBindingData(formData);
    for (let index = 0; index < this.formIds.length; index++) {
      await formProvider.updateForm(this.formIds[index], formInfo);
    }
  }
}