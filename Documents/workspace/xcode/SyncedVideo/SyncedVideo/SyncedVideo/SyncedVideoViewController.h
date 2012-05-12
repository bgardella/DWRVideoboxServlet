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
#import "VideoControlView.h"

static void *AVSPPlayerLayerReadyForDisplay = &AVSPPlayerLayerReadyForDisplay;

@interface SyncedVideoViewController : UIViewController {
    
    NSString *froggieFP;
    NSURL    *froggieURL;
    
    NSString *wheelsFP;
    NSURL    *wheelsURL;
    
    AVPlayer *player_;
    AVPlayerLayer *playerLayer_;
    //UIView *playerView_;
    
    IBOutlet UIScrollView *scrollView;
    
    VideoControlView *videoControlView;
}
@property(nonatomic, retain) AVPlayer *player;
@property(nonatomic, retain) AVPlayerLayer *playerLayer;
//@property(nonatomic, retain) UIView *playerView;

@property(nonatomic, retain) UIActivityIndicatorView *vidWait; 

//@property(nonatomic, retain) NSObject *playerObserver;

@property (nonatomic, retain) IBOutlet VideoControlView *videoControlView;

-(IBAction)playAVPlayer:(id)sender;
-(IBAction)pauseAVPlayer:(id)sender;
-(IBAction)stopAVPlayer:(id)sender;
-(IBAction)restartAVPlayer:(id)sender;

- (void)playThatLayer:(NSString*)input
                     :(NSString*)input2;

@end
