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
@synthesize stopButton = stopButton_;
@synthesize startButton = startButton_;
@synthesize pauseButton = pauseButton_;
@synthesize videoSlider = videoSlider_;
@synthesize vidWait= vidWait_;

-(IBAction)playAVPlayer:(id)sender{
    
    [self messWithAudio];
    
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

    //wait spinny animation
    self.vidWait = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	
    // Create and configure AVPlayerLayer
    //self.view.backgroundColor = [UIColor darkGrayColor];
	self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        self.playerLayer.bounds = CGRectMake(0, 0, 852, 480);
        self.playerLayer.position = CGPointMake(435, 450);
        [self.vidWait setCenter:CGPointMake(400, 400)];
    }
    else
    {
        self.playerLayer.bounds = CGRectMake(0, 0, 452, 220);
        self.playerLayer.position = CGPointMake(135, 150);
        [self.vidWait setCenter:CGPointMake(120, 120)];
    }
	
	
    self.playerLayer.borderColor = [UIColor blueColor].CGColor;
    self.playerLayer.borderWidth = 10.0;
    self.playerLayer.backgroundColor = [UIColor blackColor].CGColor;
	self.playerLayer.shadowOffset = CGSizeMake(0, 3);
	self.playerLayer.shadowOpacity = 0.80;
    
    //add observer onto playerLayer so we can cancel the spinny
    [self.playerLayer addObserver:self forKeyPath:@"readyForDisplay" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:AVSPPlayerLayerReadyForDisplay];
    
    
    //create UIView for playerLayer
    CGRect  viewRect = CGRectMake(10, 10, 100, 100);
    self.playerView = [[UIView alloc] initWithFrame:viewRect];
    
    
    //[self.playerView.layer addSublayer:self.playerLayer];    
    //set touch events to view
    //[self.playerView touchesBegan:touches withEvent:event];
    
    
    //
	[self.view.layer addSublayer:self.playerLayer];	
    

	[self.vidWait setHidesWhenStopped:YES];
    [self.vidWait startAnimating];
    [self.view addSubview:self.vidWait];
    
    [self.playerLayer setHidden:YES];
    [self.pauseButton setHidden:NO];
    [self.startButton setHidden:YES];
    [self.stopButton setHidden:NO];
    
    
    
    [self.player play];
    
}

/** if you don't do this, your videos will have no sound **/
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
    [self.videoSlider setHidden:NO];
    [self.pauseButton setHidden:YES];
    [self.startButton setHidden:NO];
    [self.stopButton setHidden:NO];
    [self.player pause];
}

-(IBAction)restartAVPlayer:(id)sender{
    if(!self.playerLayer.hidden){
        [self.videoSlider setHidden:YES];
        [self.pauseButton setHidden:NO];
        [self.startButton setHidden:YES];
        [self.player play];
    }
}

-(IBAction)stopAVPlayer:(id)sender{
    [self.videoSlider setHidden:YES];
    [self.pauseButton setHidden:YES];
    [self.startButton setHidden:YES];
    [self.stopButton setHidden:YES];
    [self.player pause]; 
    [self.playerLayer setHidden:YES];
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
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self.pauseButton setHidden:YES];
    [self.startButton setHidden:YES];
    [self.stopButton setHidden:YES];
    [self.videoSlider setHidden:YES];
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
            [self.vidWait setHidden:YES];
		}
	}
    
}


- (void)dealloc {
    [super dealloc];
    [self.player release];
}
     
     
@end
