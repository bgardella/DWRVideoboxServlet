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
#import <AVFoundation/AVAudioMix.h>
#import <AVFoundation/AVAsset.h>

@interface SyncedVideoViewController : UIViewController {
    //AVPlayer *avPlayer;
    
    NSString *froggieFP;
    NSURL    *froggieURL;
    
    NSString *wheelsFP;
    NSURL    *wheelsURL;
    
    AVPlayer *player_;
    AVPlayerLayer *playerLayer_;
    
}
@property(nonatomic, retain) AVPlayer *player;
@property(nonatomic, retain) AVPlayerLayer *playerLayer;


//-(IBAction)playMovie:(id)sender;

-(IBAction)playAVPlayer:(id)sender;

- (void)playThatLayer:(NSString*)input;

@end
