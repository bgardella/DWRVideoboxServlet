//
//  SyncedVideoViewController.m
//  SyncedVideo
//
//  Created by Ben Gardella on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SyncedVideoViewController.h"

@implementation SyncedVideoViewController

@synthesize player = player_;
@synthesize playerLayer = playerLayer_;
@synthesize playerView = playerView_;

-(IBAction)playAVPlayer:(id)sender{
    
    UIButton *playButton = (UIButton *) sender; 
    NSString *vidTitle;
    if([playButton.titleLabel.text isEqualToString:@"Froggie"]){
        vidTitle = @"froggie-sophie";
    }
    if([playButton.titleLabel.text isEqualToString:@"Wheels"]){
        vidTitle = @"wheels";
    }
    
    [self playThatLayer:(vidTitle)];
}


- (void)playThatLayer:(NSString*)vidTitle {
	
    NSString *moviePath = [[NSBundle mainBundle] pathForResource:vidTitle ofType:@"mp4"];
    
    // Setup AVPlayer
    //status check
    if(self.player){
        [self.player pause];
        
        //[self.playerLayer release];
        [self.player release];
        
        //[self.playerView release];
    }
    
    self.player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:moviePath]];

    
	// Create and configure AVPlayerLayer
    //self.view.backgroundColor = [UIColor darkGrayColor];
	self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        self.playerLayer.bounds = CGRectMake(0, 0, 852, 480);
        self.playerLayer.position = CGPointMake(435, 450);
    }
    else
    {
        self.playerLayer.bounds = CGRectMake(0, 0, 452, 220);
        self.playerLayer.position = CGPointMake(135, 150);
    }
	
	
    self.playerLayer.borderColor = [UIColor blueColor].CGColor;
    self.playerLayer.borderWidth = 10.0;
	self.playerLayer.shadowOffset = CGSizeMake(0, 3);
	self.playerLayer.shadowOpacity = 0.80;
    
    //create UIView for playerLayer
    CGRect  viewRect = CGRectMake(10, 10, 100, 100);
    self.playerView = [[UIView alloc] initWithFrame:viewRect];
    [self.playerView.layer addSublayer:self.playerLayer];
    
    //set touch events to view
//    [self.playerView touchesBegan:touches withEvent:event];
    
    
    //
	[self.view.layer addSublayer:self.playerLayer];	
    
    [self.player play];
}

- (void)messWithAudio{
    
    //*** DEAL WITH AUDIO ****/
    /*
     NSMutableArray *allAudioParams = [NSMutableArray array];
     for (AVAssetTrack *track in audioTracks) {
     AVMutableAudioMixInputParameters *audioInputParams =[AVMutableAudioMixInputParameters audioMixInputParameters];
     [audioInputParams setVolume:0.0 atTime:kCMTimeZero];
     [audioInputParams setTrackID:[track trackID]];
     [allAudioParams addObject:audioInputParams];
     }
     
     AVMutableAudioMix *audioZeroMix = [AVMutableAudioMix audioMix];
     AVMutableAudioMixInputParameters *params = [[AVMutableAudioMixInputParameters alloc] init]; 
     [params setVolume:10 atTime:];
     */
    //[audioZeroMix setInputParameters:params];
    //[playerItem setAudioMix:audioZeroMix];
    
}

/*
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    NSSet *touchList = [event allTouches];
    for (UITouch *myTouch in touchList){
        
        //NSLog( myTouch.description );
        
        //CGPoint touchLocation = [myTouch locationInView];
        
        
    }
    
    id value;    
    NSEnumerator *touchesEnum = [touches objectEnumerator];
    while ((value = [touchesEnum nextObject])) {
        //code that acts on the set’s values 
        
    }
}
*/

-(IBAction)pauseAVPlayer:(id)sender{
    [self.player pause];
}

-(IBAction)restartAVPlayer:(id)sender{
    if(!self.playerLayer.hidden){
        [self.player play];
    }
}

-(IBAction)stopAVPlayer:(id)sender{
    [self.player pause];
    
    [self.playerLayer setHidden:YES];
    [self.playerView setHidden:YES];
    //self.playerView.hidden = YES;
    //[self.playerView removeFromSuperview];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


//- (void)dealloc {
//    [super dealloc];
//}
     
     
@end
