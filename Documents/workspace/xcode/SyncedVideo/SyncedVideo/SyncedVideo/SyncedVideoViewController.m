//
//  SyncedVideoViewController.m
//  SyncedVideo
//
//  Created by Ben Gardella on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SyncedVideoViewController.h"

@implementation SyncedVideoViewController

//video player and layer
@synthesize player = player_;
@synthesize playerLayer = playerLayer_;

//ui controls
@synthesize vidWait= vidWait_;
@synthesize videoControlView;

-(IBAction)playAVPlayer:(id)sender{
    
    //check to see if the player is already playing or paused
    if(self.playerLayer.opacity == 0.99f){
        return;
    }
    if(self.player.rate != 0.0f){
        return;
    }
    
    [self messWithAudio];
    
    UIButton *playButton = (UIButton *) sender; 
    [self loadVideoByButtonPress:(playButton)];
}

- (void)loadVideoByButtonPress:(UIButton *)buttonPressed{
    NSString *vidTitle;
    NSString *subTitle;
    if([buttonPressed.titleLabel.text isEqualToString:@"Froggie"]){
        vidTitle = @"froggie-sophie";
        subTitle = @"froggie_lyrics";
    }
    if([buttonPressed.titleLabel.text isEqualToString:@"Wheels"]){
        vidTitle = @"wheels";
        subTitle = @"froggie_lyrics_01";
    }
    
    [self playThatLayer:(vidTitle)
                       :(subTitle)];
}


- (void)playThatLayer:(NSString *)vidTitle
                     :(NSString *)subTitle {
	
    NSString *moviePath = [[NSBundle mainBundle] pathForResource:vidTitle ofType:@"mp4"];
    
    // Setup AVPlayer
    //status check
    if(self.player){
        [self.player pause];
        [self.player release];
    }
    
    self.player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:moviePath]];
    
    //wait spinny animation
    self.vidWait = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	
	self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    
    //position the player
    [self positionPlayer];
	
	self.playerLayer.borderColor = [UIColor blackColor].CGColor;
    self.playerLayer.borderWidth = 8.0;
    self.playerLayer.backgroundColor = [UIColor blackColor].CGColor;
	self.playerLayer.shadowOffset = CGSizeMake(0, 3);
	self.playerLayer.shadowOpacity = 0.80;
    self.playerLayer.opacity = 1.0;
    
    //add observer onto playerLayer so we can cancel the spinny
    [self.playerLayer addObserver:self forKeyPath:@"readyForDisplay" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:AVSPPlayerLayerReadyForDisplay];
    
    [self.view.layer addSublayer:self.playerLayer];	
    
	[self.vidWait setHidesWhenStopped:YES];
    [self.vidWait startAnimating];
    [self.view addSubview:self.vidWait];
    
    [self.playerLayer setHidden:YES];
    
    [self.view bringSubviewToFront:self.videoControlView];
    
    [self.videoControlView togglePlayPauseButton:(YES)];
    [self.player play];
}

/** if you don't do this, the videos will have no sound!!!! **/
- (void)messWithAudio{
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:NULL];
}


//////////////////////////////////
//////////////////////////////////
//////////////////////////////////

-(IBAction)pauseAVPlayer:(id)sender{

    self.playerLayer.opacity = 0.99f;
    [self.player pause];
    [self.videoControlView togglePlayPauseButton:(NO)];
}

-(IBAction)restartAVPlayer:(id)sender{
    
    if(!self.playerLayer.hidden){
        self.playerLayer.opacity = 1.0f;
        [self.player play];
        [self.videoControlView togglePlayPauseButton:(YES)];
    }
}

-(IBAction)stopAVPlayer:(id)sender{

    [self.player pause];
    [self.player release];
    
    self.playerLayer.opacity = 0.0f;
    [self.playerLayer setHidden:YES];
    self.videoControlView.alpha = 0.0f;
}

//////////////////////////////////
//////////////////////////////////
//////////////////////////////////


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}


- (void)positionPlayer {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){ //ipad
        self.playerLayer.bounds = CGRectMake(0, 0, 852, 480);
        self.playerLayer.position = CGPointMake(520, 382);
        [self.vidWait setCenter:CGPointMake(400, 400)];
    }
    else{ //iphone
        self.playerLayer.bounds = CGRectMake(0, 0, 640, 300);
        self.playerLayer.position = CGPointMake(260, 150);
        [self.vidWait setCenter:CGPointMake(120, 120)];
    }
}


- (void)viewDidLoad {
	// Do any additional setup after loading the view, typically from a nib.
    
    self.videoControlView.alpha = 0.0f;

    //scrollable corkboard
    [scrollView setScrollEnabled:YES];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){ //ipad
        [scrollView setContentSize:CGSizeMake(1483, 483)];
    }else {
        [scrollView setContentSize:CGSizeMake(700, 128)];
    }
    
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

    if (context == AVSPPlayerLayerReadyForDisplay) {
		if ([[change objectForKey:NSKeyValueChangeNewKey] boolValue] == YES) {
			// The AVPlayerLayer is ready for display. Hide the loading spinner and show it.
			[self.playerLayer setHidden:NO];
            [self.vidWait setHidden:YES];
            
            self.videoControlView.alpha = 1.0f;
		}
	}
}

- (CMTime)playerItemDuration {
    return([self.player currentTime]);
}

- (void)dealloc {

    [self.player release];
    [videoControlView release];
    [super dealloc];
}
     
     
@end
