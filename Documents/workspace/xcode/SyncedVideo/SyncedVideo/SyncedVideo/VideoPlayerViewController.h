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

static void *AVSPPlayerLayerReadyForDisplay = &AVSPPlayerLayerReadyForDisplay;

@interface VideoPlayerViewController : UIViewController{
@private    
    NSString *froggieFP;
    NSURL    *froggieURL;
    
    NSString *wheelsFP;
    NSURL    *wheelsURL;
    
    AVPlayer *player;
    AVPlayerLayer *playerLayer;
    
    VideoControlView *videoControlView;
    IBOutlet UIView *vidWait;
    
    id timeObserver;
    BOOL isIPhone;
}

@property(nonatomic, retain) AVPlayer *player;
@property(nonatomic, retain) AVPlayerLayer *playerLayer;
@property (nonatomic, retain) IBOutlet VideoControlView *videoControlView;
@property (nonatomic, retain) id timeObserver;
@property (nonatomic, assign) CMTime movieDuration;
@property (nonatomic, assign) BOOL isIPhone;

- (IBAction)pauseAVPlayer:(id)sender;
- (void)stopAVPlayer;
- (IBAction)restartAVPlayer:(id)sender;
- (IBAction)startScrubbing:(id)sender;
- (IBAction)stopScrubbing:(id)sender;
- (IBAction)scrubValueChanged:(id)sender;


- (IBAction)flipToHomeView:(id)sender;

- (void)playThatLayer:(NSString*)input
                     :(NSString*)input2;

- (void)loadVideoByButtonPress:(UIButton *)buttonPressed;

@end


