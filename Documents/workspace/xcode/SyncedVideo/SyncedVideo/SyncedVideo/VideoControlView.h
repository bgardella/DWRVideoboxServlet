//
//  VideoControlView.h
//  SyncedVideo
//
//  Created by Ben Gardella on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface VideoControlView : UIView {

@protected
    UIButton *stopButton;
    UIButton *startButton;
    UIButton *pauseButton;
    UISlider *videoSlider;
    
}

@property(retain) IBOutlet UIButton *stopButton;
@property(retain) IBOutlet UIButton *startButton;
@property(retain) IBOutlet UIButton *pauseButton;
@property(retain) IBOutlet UISlider *videoSlider;

- (void)togglePlayPauseButton:(BOOL)isPlayerPaused;


@end