//
//  SyncedVideoViewController.h
//  SyncedVideo
//
//  Created by Ben Gardella on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h> 
#import <AVFoundation/AVPlayer.h>
#import <AVFoundation/AVPlayerLayer.h>
#import <AVFoundation/AVAudioSession.h>
#import <AVFoundation/AVAsset.h>

static void *AVSPPlayerLayerReadyForDisplay = &AVSPPlayerLayerReadyForDisplay;

@interface SyncedVideoViewController : UIViewController {
    //AVPlayer *avPlayer;
    
    NSString *froggieFP;
    NSURL    *froggieURL;
    
    NSString *wheelsFP;
    NSURL    *wheelsURL;
    
    AVPlayer *player_;
    AVPlayerLayer *playerLayer_;
    UIView *playerView_;
}
@property(nonatomic, retain) AVPlayer *player;
@property(nonatomic, retain) AVPlayerLayer *playerLayer;
@property(nonatomic, retain) UIView *playerView;
@property(nonatomic, retain) UIActivityIndicatorView *vidWait; 

@property(retain) IBOutlet UIButton *stopButton;
@property(retain) IBOutlet UIButton *startButton;
@property(retain) IBOutlet UIButton *pauseButton;
@property(retain) IBOutlet UISlider *videoSlider;


//-(IBAction)playMovie:(id)sender;

-(IBAction)playAVPlayer:(id)sender;
-(IBAction)pauseAVPlayer:(id)sender;
-(IBAction)stopAVPlayer:(id)sender;
-(IBAction)restartAVPlayer:(id)sender;

- (void)playThatLayer:(NSString*)input;

@end
