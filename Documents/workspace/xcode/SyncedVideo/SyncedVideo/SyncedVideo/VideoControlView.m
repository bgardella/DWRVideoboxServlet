//
//  VideoControlView.m
//  SyncedVideo
//
//  Created by Ben Gardella on 5/11/12.
//  Copyright (c) 2012 Sophie World LLC. All rights reserved.
//

#import "VideoControlView.h"

@implementation VideoControlView

@synthesize startButton;
@synthesize stopButton;
@synthesize pauseButton;
@synthesize videoSlider;

@synthesize timeElapsed;
@synthesize timeRemaining;

@synthesize visibleCounter;


- (void)drawRect:(CGRect)rect {
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        UIImage *image = [UIImage imageNamed:@"control_panel"];
        [image drawAtPoint:self.bounds.origin blendMode:kCGBlendModeNormal alpha:1.0];
    }
    self.alpha = 1.0;
}


- (void)togglePlayPauseButton:(BOOL)isPlayerPaused {

    if(isPlayerPaused){
        self.startButton.hidden = YES;
        self.pauseButton.hidden = NO;
    } else {
        self.startButton.hidden = NO;
        self.pauseButton.hidden = YES;
    }
}

- (void)fadeOutControls{
    
    if(self.alpha == 1.0){
        self.alpha = 1.0;
        [UIView beginAnimations:@"Fade-in" context:NULL];
        [UIView setAnimationDuration:1.0];
        self.alpha = 0.0;
        [UIView commitAnimations];
        
        visibleCounter = 0;
    }
}

- (void)fadeInControls{
    
    if(self.alpha == 0.0){
        self.alpha = 0.0;
        [UIView beginAnimations:@"Fade-in" context:NULL];
        [UIView setAnimationDuration:0.6];
        self.alpha = 1.0;
        [UIView commitAnimations];
        
        visibleCounter = 0;
    }
}

- (void)resetCounter {
    visibleCounter = 0;
}

- (void)dealloc {
    [startButton release];
    [stopButton release];
    [pauseButton release];
	[timeElapsed release];
	[timeRemaining release];
	[super dealloc];
}

@end
