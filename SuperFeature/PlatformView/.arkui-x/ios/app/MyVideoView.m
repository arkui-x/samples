#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

#import "MyVideoView.h"


@interface MyVideoView () <AVCaptureVideoDataOutputSampleBufferDelegate>
@property (nonatomic, strong) AVPlayerItemVideoOutput *videoOutput;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayer *player;
@end


@implementation MyVideoView {
    UIView *view;
    NSString* viewTag;
}

- (instancetype)initWithFrame
{
    self = [super init];
    if (self) {
        viewTag = @"VideoView";
        view = [UIView new];
        NSURL *urlString = [[NSBundle mainBundle] URLForResource:@"arkui-x/entry/resources/rawfile/video" withExtension:@"mp4"];
        _player = [[AVPlayer alloc] initWithURL:urlString];
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        _playerLayer.backgroundColor = [UIColor blackColor].CGColor;
        
        _videoOutput = [[AVPlayerItemVideoOutput alloc] initWithPixelBufferAttributes:nil];
        [_player.currentItem addOutput:_videoOutput];
        
        [view.layer addSublayer:_playerLayer];
        
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.player play];
        });
        
        [[NSNotificationCenter defaultCenter] addObserverForName:AVPlayerItemDidPlayToEndTimeNotification
                                                          object:nil
                                                           queue:nil
                                                      usingBlock:^(NSNotification *note){
            [weakSelf.player seekToTime:kCMTimeZero];
            [weakSelf.player play];
        }];
    }
    return self;
}

#pragma mark - protocol
- (UIView*)view {
    return view;
}

- (void)onDispose {
    [_player pause];
    [_playerLayer removeFromSuperlayer];
    _playerLayer.player = nil;
    _playerLayer = nil;

    if (_player.currentItem && _videoOutput) {
        [_player.currentItem removeOutput:_videoOutput];
    }
    _videoOutput = nil;
    _player = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    view = nil;
}

- (NSString*) getPlatformViewID {
    return viewTag;
}
@end
