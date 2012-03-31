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




-(IBAction)playAVPlayer:(id)sender{
    
    UIButton *playButton = (UIButton *) sender; 
    NSString *vidTitle;
    if([playButton.titleLabel.text isEqualToString:@"Froggie"]){
        vidTitle = @"froggie-sophie";
    }
    if([playButton.titleLabel.text isEqualToString:@"Wheels"]){
        vidTitle = @"wheels";
    }
    
    
    /*
    //[avPlayer pause];
    
    UIButton *playButton = (UIButton *) sender; 
	
    NSString *vidTitle;
    if([playButton.titleLabel.text isEqualToString:@"Froggie"]){
        vidTitle = @"froggie-sophie";
    }
    if([playButton.titleLabel.text isEqualToString:@"Wheels"]){
        vidTitle = @"wheels";
    }
    
    NSString *filepath = [[NSBundle mainBundle] pathForResource:vidTitle ofType:@"mp4"];
    NSURL    *fileURL    =   [NSURL fileURLWithPath:filepath];
    
    AVPlayer *avPlayer = [[AVPlayer alloc] initWithURL:fileURL];
    //[avPlayer initWithURL:fileURL];
    
    //CALayer *superlayer = <#Get a CALayer#>;
    //AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:avPlayer];
    */
    
    [self playThatLayer:(vidTitle)];
}


- (void)playThatLayer:(NSString*)vidTitle {
	//self.view.backgroundColor = [UIColor darkGrayColor];
    
	// Setup AVPlayer
    // You've been rickrolled.
	NSString *moviePath = [[NSBundle mainBundle] pathForResource:vidTitle ofType:@"mp4"];
	self.player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:moviePath]];
	
    //AVPlayerItem *item = self.player.currentItem;
    //AVURLAsset *asset = self.player.currentItem.asset;
    
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
    
	// Create and configure AVPlayerLayer
	self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
	self.playerLayer.bounds = CGRectMake(0, 0, 852, 480);
	self.playerLayer.position = CGPointMake(435, 250);
	self.playerLayer.borderColor = [UIColor blueColor].CGColor;
    self.playerLayer.borderWidth = 10.0;
	self.playerLayer.shadowOffset = CGSizeMake(0, 3);
	self.playerLayer.shadowOpacity = 0.80;
    //self.playerLayer.player
    
    
    // Add perspective transform
	//self.view.layer.sublayerTransform = CATransform3DMakePerspective(1000);
 
	[self.view.layer addSublayer:self.playerLayer];	
    
    [self.player play];
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

    /*
     -(IBAction)playMovie:(id)sender{
     
     UIButton *playButton = (UIButton *) sender; 
     
     NSString *vidTitle;
     if([playButton.titleLabel.text isEqualToString:@"Froggie"]){
     vidTitle = @"froggie-sophie";
     }
     if([playButton.titleLabel.text isEqualToString:@"Wheels"]){
     vidTitle = @"wheels";
     }
     
     NSString *filepath = [[NSBundle mainBundle] pathForResource:vidTitle ofType:@"mp4"];
     NSURL    *fileURL    =   [NSURL fileURLWithPath:filepath];
     
     MPMoviePlayerController *moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:fileURL];
     
     [[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(moviePlaybackComplete:)
     name:MPMoviePlayerPlaybackDidFinishNotification
     object:moviePlayerController];
     
     [moviePlayerController.view setFrame:CGRectMake(playButton.frame.origin.x, 
     playButton.frame.origin.y, 
     playButton.frame.size.width, 
     playButton.frame.size.height)];
     
     [self.view addSubview:moviePlayerController.view];
     moviePlayerController.fullscreen = YES;
     moviePlayerController.useApplicationAudioSession = NO;
     
     //moviePlayerController.scalingMode = MPMovieScalingModeFill;
     
     [moviePlayerController play];
     
     }
     
     - (void)moviePlaybackComplete:(NSNotification *)notification{
     
     MPMoviePlayerController *moviePlayerController = [notification object];
     [[NSNotificationCenter defaultCenter] removeObserver:self
     name:MPMoviePlayerPlaybackDidFinishNotification
     object:moviePlayerController];
     
     [moviePlayerController.view removeFromSuperview];
     //[moviePlayerController release];
     }
     */
     
     
@end
