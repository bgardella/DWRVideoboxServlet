//
//  VideoControlView.h
//  SyncedVideo
//
//  Created by Ben Gardella on 5/11/12.
//  Copyright (c) 2012 Emmett's Older Brother Prod. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoControlView : UIView {

@protected
    UIButton *stopButton;
    UIButton *startButton;
    UIButton *pauseButton;
    UISlider *videoSlider;
    
    UILabel *timeElapsed;
	UILabel *timeRemaining;
}

@property(retain) IBOutlet UIButton *stopButton;
@property(retain) IBOutlet UIButton *startButton;
@property(retain) IBOutlet UIButton *pauseButton;
@property(retain) IBOutlet UISlider *videoSlider;

@property (nonatomic, retain) IBOutlet UILabel *timeElapsed;
@property (nonatomic, retain) IBOutlet UILabel *timeRemaining;

@property (nonatomic, assign) int16_t visibleCounter;


- (void)togglePlayPauseButton:(BOOL)isPlayerPaused;
- (void)fadeInControls;
- (void)fadeOutControls;
- (void)resetCounter;

@end