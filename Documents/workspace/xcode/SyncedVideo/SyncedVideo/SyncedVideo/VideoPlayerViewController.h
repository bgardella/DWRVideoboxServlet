//
//  VideoPlayerViewController.h
//  SyncedVideo
//
//  Created by Ben Gardella on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVPlayer.h>
#import <AVFoundation/AVPlayerLayer.h>
#import <AVFoundation/AVAudioSession.h>
#import <AVFoundation/AVAsset.h>
#import "VideoControlView.h"
#import "KaraokeView.h"

static void *AVSPPlayerLayerReadyForDisplay = &AVSPPlayerLayerReadyForDisplay;

@interface VideoPlayerViewController : UIViewController{
@private    
    NSString *froggieFP;
    NSURL    *froggieURL;
    
    NSString *wheelsFP;
    NSURL    *wheelsURL;
    
    AVPlayer *player;
    AVPlayerLayer *playerLayer;
    
    //seperate view elements
    VideoControlView *videoControlView;
    IBOutlet UIView *vidWait;
    KaraokeView *karaokeView;
    
    id timeObserver;
    id timeCodeObserver;
    BOOL isIPhone;
    
    //karaoke info
    NSMutableArray *karaokeTimeArr;
    NSMutableArray *karaokeLyricArr;
}

@property(nonatomic, retain) AVPlayer *player;
@property(nonatomic, retain) AVPlayerLayer *playerLayer;
@property (nonatomic, retain) IBOutlet VideoControlView *videoControlView;
@property (nonatomic, retain) IBOutlet KaraokeView *karaokeView;
@property (nonatomic, retain) id timeObserver;
@property (nonatomic, retain) id timeCodeObserver;
@property (nonatomic, assign) CMTime movieDuration;
@property (nonatomic, assign) BOOL isIPhone;

- (IBAction)pauseAVPlayer:(id)sender;
- (void)stopAVPlayer;
- (IBAction)restartAVPlayer:(id)sender;
- (IBAction)startScrubbing:(id)sender;
- (IBAction)stopScrubbing:(id)sender;
- (IBAction)scrubValueChanged:(id)sender;


- (IBAction)flipToHomeView:(id)sender;
- (IBAction)kViewDragButtonPressed:(id)sender withEvent:(UIEvent *) event;
- (IBAction)kViewDragButtonFinished:(id)sender withEvent:(UIEvent *) event;
- (IBAction)toggleFullScreen:(id)sender;

- (void)playThatLayer:(NSString*)input
                     :(NSString*)input2;

- (void)loadVideoByButtonPress:(UIButton *)buttonPressed;

@end


