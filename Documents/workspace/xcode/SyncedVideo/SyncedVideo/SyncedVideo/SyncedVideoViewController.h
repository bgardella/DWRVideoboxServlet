//
//  SyncedVideoViewController.h
//  SyncedVideo
//
//  Created by Ben Gardella on 3/29/12.
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

@interface SyncedVideoViewController : UIViewController {
@private    
    NSString *froggieFP;
    NSURL    *froggieURL;
    
    NSString *wheelsFP;
    NSURL    *wheelsURL;
    
    AVPlayer *player;
    AVPlayerLayer *playerLayer;
    
    IBOutlet UIScrollView *scrollView;
    UISlider *slider;
    
    VideoControlView *videoControlView;
    
    id timeObserver;
}

@property(nonatomic, retain) AVPlayer *player;
@property(nonatomic, retain) AVPlayerLayer *playerLayer;
@property(nonatomic, retain) UIActivityIndicatorView *vidWait; 
@property (nonatomic, retain) IBOutlet VideoControlView *videoControlView;
@property (nonatomic, retain) id timeObserver;
@property (nonatomic, assign) CMTime movieDuration;
@property (nonatomic, retain) IBOutlet UISlider *slider;

- (IBAction)playAVPlayer:(id)sender;
- (IBAction)pauseAVPlayer:(id)sender;
- (IBAction)stopAVPlayer:(id)sender;
- (IBAction)restartAVPlayer:(id)sender;
- (IBAction)startScrubbing:(id)sender;
- (IBAction)stopScrubbing:(id)sender;
- (IBAction)scrubValueChanged:(id)sender;

- (void)playThatLayer:(NSString*)input
                     :(NSString*)input2;

-(void)flipToVideoView;

@end
