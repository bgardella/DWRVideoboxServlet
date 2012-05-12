//
//  SyncedVideoViewController.m
//  SyncedVideo
//
//  Created by Ben Gardella on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SyncedVideoViewController.h"

@implementation SyncedVideoViewController

//video players
@synthesize player = player_;
@synthesize playerLayer = playerLayer_;
//@synthesize playerView = playerView_;

//ui controls
@synthesize vidWait= vidWait_;
@synthesize videoControlView;

-(IBAction)playAVPlayer:(id)sender{
    
    //check to see if the player is already playing or paused
    if(self.playerLayer.opacity > 0.0f){
        return;
    }
    if(self.player.rate != 0.0f){
        return;
    }
    
    [self messWithAudio];
    
    UIButton *playButton = (UIButton *) sender; 
    NSString *vidTitle;
    NSString *subTitle;
    if([playButton.titleLabel.text isEqualToString:@"Froggie"]){
        vidTitle = @"froggie-sophie";
        subTitle = @"froggie_lyrics";
    }
    if([playButton.titleLabel.text isEqualToString:@"Wheels"]){
        vidTitle = @"wheels";
        subTitle = @"froggie_lyrics_01";
    }
    
    [self playThatLayer:(vidTitle)
                       :(subTitle)];
}


- (void)playThatLayer:(NSString*)vidTitle
                     :(NSString*)subTitle {
	
    NSString *moviePath = [[NSBundle mainBundle] pathForResource:vidTitle ofType:@"mp4"];
    //NSString *subPath = [[NSBundle mainBundle] pathForResource:subTitle ofType:@"m4v"];
    
    // Setup AVPlayer
    //status check
    if(self.player){
        [self.player pause];
        [self.player release];
    }
    //if(self.subPlayer){
    //    [self.subPlayer pause];
    //    [self.subPlayer release];
    //}
    
    self.player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:moviePath]];
    //self.subPlayer = [AVPlayer playerWithURL:[NSURL fileURLWithPath:subPath]];
    
    //wait spinny animation
    self.vidWait = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	
    // Create and configure AVPlayerLayer
    //self.view.backgroundColor = [UIColor darkGrayColor];
	self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    //self.subPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.subPlayer];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) //ipad
    {
        self.playerLayer.bounds = CGRectMake(0, 0, 852, 480);
        self.playerLayer.position = CGPointMake(520, 382);
        [self.vidWait setCenter:CGPointMake(400, 400)];
        
        //self.subPlayerLayer.bounds = CGRectMake(0, 0, 452, 80);
        //self.subPlayerLayer.position = CGPointMake(435, 650);
    }
    else //iphone
    {
        self.playerLayer.bounds = CGRectMake(0, 0, 452, 220);
        self.playerLayer.position = CGPointMake(135, 150);
        
        [self.vidWait setCenter:CGPointMake(120, 120)];
    
        //self.subPlayerLayer.bounds = CGRectMake(0, 0, 452, 120);
        //self.subPlayerLayer.position = CGPointMake(135, 150);
    }
	
	self.playerLayer.borderColor = [UIColor blackColor].CGColor;
    self.playerLayer.borderWidth = 8.0;
    self.playerLayer.backgroundColor = [UIColor blackColor].CGColor;
	self.playerLayer.shadowOffset = CGSizeMake(0, 3);
	self.playerLayer.shadowOpacity = 0.80;
    self.playerLayer.opacity = 1.0;
    
    //self.subPlayerLayer.borderColor = [UIColor greenColor].CGColor;
    //self.subPlayerLayer.borderWidth = 4.0;
    //self.subPlayerLayer.backgroundColor = [UIColor blackColor].CGColor;
	//self.subPlayerLayer.shadowOffset = CGSizeMake(0, 3);
	//self.subPlayerLayer.shadowOpacity = 0.80;
    
    //add observer onto playerLayer so we can cancel the spinny
    [self.playerLayer addObserver:self forKeyPath:@"readyForDisplay" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:AVSPPlayerLayerReadyForDisplay];
    
    //create UIView for playerLayer
//    CGRect viewRect = CGRectMake(10, 10, 100, 100);
//    self.playerView = [[UIView alloc] initWithFrame:viewRect];
    
    //[self.playerView.layer addSublayer:self.playerLayer];    
    //set touch events to view
    //[self.playerView touchesBegan:touches withEvent:event];
    
    [self.view.layer addSublayer:self.playerLayer];	
    //[self.view.layer addSublayer:self.subPlayerLayer];	
    

	[self.vidWait setHidesWhenStopped:YES];
    [self.vidWait startAnimating];
    [self.view addSubview:self.vidWait];
    
    [self.playerLayer setHidden:YES];
    //[self.subPlayerLayer setHidden:YES];
    

    //[self.playerView insertSubview:self.startButton atIndex:1];
    //[self.playerView insertSubview:self.stopButton atIndex:2];
    
    [self.view bringSubviewToFront:self.videoControlView];
    
    [self.videoControlView.startButton setAlpha:0.1];
    
    [self.player play];
   
}

/** if you don't do this, the videos will have no sound!!!! **/
- (void)messWithAudio{
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:NULL];
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

//////////////////////////////////
//////////////////////////////////
//////////////////////////////////

-(IBAction)pauseAVPlayer:(id)sender{

    self.playerLayer.opacity = 0.5f;
    [self.player pause];
    [self.videoControlView.pauseButton setAlpha:0.1];
}

-(IBAction)restartAVPlayer:(id)sender{
    if(!self.playerLayer.hidden){
        self.playerLayer.opacity = 1.0f;
        [self.player play];
        [self.videoControlView.startButton setAlpha:0.1];
    }
}

-(IBAction)stopAVPlayer:(id)sender{

    [self.player pause];
    [self.player release];
    
    self.playerLayer.opacity = 0.0f;
    [self.playerLayer setHidden:YES];
    self.videoControlView.alpha = 0.0f;
    
    [self.videoControlView.stopButton setAlpha:0.1];
}

//////////////////////////////////
//////////////////////////////////
//////////////////////////////////


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}


- (void)viewDidLoad
{
	// Do any additional setup after loading the view, typically from a nib.
    
    self.videoControlView.alpha = 0.0f;
    
    //scrollable corkboard
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(1483, 483)];
    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == AVSPPlayerLayerReadyForDisplay)
	{
		if ([[change objectForKey:NSKeyValueChangeNewKey] boolValue] == YES)
		{
			// The AVPlayerLayer is ready for display. Hide the loading spinner and show it.
			[self.playerLayer setHidden:NO];
            //[self.subPlayerLayer setHidden:NO];
            [self.vidWait setHidden:YES];
            
            self.videoControlView.alpha = 1.0f;
            
            //[self.subPlayer play];
		}
	}
    /*
    if (context == )
	{
        CMTime playerDuration = [self playerItemDuration];
    }
    */
}

- (CMTime)playerItemDuration
{
    return([self.player currentTime]);
    
	//AVPlayerItem *playerItem = [self.player currentItem];
    //return([playerItem duration]);
    
    //return NSTimeIntervalSince1970;
}

- (void)dealloc {
    [super dealloc];
    [self.player release];
    //[self.subPlayer release];
    
    [videoControlView release];
}
     
     
@end
