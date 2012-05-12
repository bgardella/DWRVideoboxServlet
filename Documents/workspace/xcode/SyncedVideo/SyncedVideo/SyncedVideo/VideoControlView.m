//
//  VideoControlView.m
//  SyncedVideo
//
//  Created by Ben Gardella on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VideoControlView.h"

@implementation VideoControlView


@synthesize startButton;
@synthesize stopButton;
@synthesize pauseButton;
@synthesize videoSlider;

- (void)drawRect:(CGRect)rect {
	UIImage *image = [UIImage imageNamed:@"movie_lower-controls_background"];
    
	[image drawAtPoint:self.bounds.origin blendMode:kCGBlendModeNormal alpha:1.0];
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


/*
 
 
 [self.pauseButton setHidden:NO];
 [self.startButton setHidden:YES];
 [self.stopButton setHidden:NO];
 
 //add controls to the player view
 [self.pauseButton setBounds:CGRectMake(10,10,100,100)];
 [self.pauseButton setCenter:CGPointMake(10, 10)];
 [self.playerLayer addSubview:self.pauseButton];
 
 
 
 -(IBAction)pauseAVPlayer:(id)sender{
 [self.videoSlider setHidden:NO];
 [self.pauseButton setHidden:YES];
 [self.startButton setHidden:NO];
 [self.stopButton setHidden:NO];
 [self.player pause];
 //[self.subPlayer pause];
 }
 
 -(IBAction)restartAVPlayer:(id)sender{
 if(!self.playerLayer.hidden){
 [self.videoSlider setHidden:YES];
 [self.pauseButton setHidden:NO];
 [self.startButton setHidden:YES];
 [self.player play];
 //[self.subPlayer play];
 }
 }
 
 -(IBAction)stopAVPlayer:(id)sender{
 [self.videoSlider setHidden:YES];
 [self.pauseButton setHidden:YES];
 [self.startButton setHidden:YES];
 [self.stopButton setHidden:YES];
 [self.player pause]; 
 [self.playerLayer setHidden:YES];
 //[self.subPlayer pause]; 
 //[self.subPlayerLayer setHidden:YES];
 }
 
 - (void)viewDidLoad
 {
 // Do any additional setup after loading the view, typically from a nib.
 
 [self.pauseButton setHidden:YES];
 [self.startButton setHidden:YES];
 [self.stopButton setHidden:YES];
 [self.videoSlider setHidden:YES];
 }
 
 
 */


@end
