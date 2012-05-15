//
//  VideoPlayerViewController.m
//  SyncedVideo
//
//  Created by Ben Gardella on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VideoPlayerViewController.h"
#import "SyncedVideoAppDelegate.h"

@interface VideoPlayerViewController ()

@end

@implementation VideoPlayerViewController

static int VIDEO_BTN_IDX = 1001;

//video player and layer
@synthesize player;
@synthesize playerLayer;

//ui controls
@synthesize vidWait= vidWait_;
@synthesize videoControlView;
@synthesize timeObserver;
@synthesize movieDuration;

@synthesize isIPhone;

- (IBAction)flipToHomeView:(id)sender {
    
    [self stopAVPlayer]; 
    
    SyncedVideoAppDelegate * myDel = 
    ( SyncedVideoAppDelegate * ) [ [ UIApplication sharedApplication ] delegate ];
    
    [myDel flipToHomeView];
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
    
    [self messWithAudio];
    
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
    
    self.player = [[[AVPlayer alloc] initWithURL:[NSURL fileURLWithPath:moviePath]] autorelease];
    
    
    //wait spinny animation
    self.vidWait = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	
	self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    
    //position the player
    [self positionPlayer];
    
    
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
    
    if(isIPhone){
        [self.videoControlView resetCounter];
    }
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
    if(isIPhone){
        [self.videoControlView resetCounter];
    }
}

-(IBAction)restartAVPlayer:(id)sender{
    
    if(!self.playerLayer.hidden){
        self.playerLayer.opacity = 1.0f;
        [self.videoControlView togglePlayPauseButton:(YES)];
        if(isIPhone){
            [self.videoControlView resetCounter];
        }
        [self.player play];
    }
}

-(void)stopAVPlayer{
    
    if(self.player != nil){
        [self.player pause];
    }
    
    [self removeTimeObserver];
    
    if(self.playerLayer != nil){
        self.playerLayer.opacity = 0.0f;
        [self.playerLayer setHidden:YES];
    }
}

/*
-(void)removeVideoEventButton{
    UIView *v = [self.view viewWithTag:VIDEO_BTN_IDX];
    v.hidden = YES;
    [self.view bringSubviewToFront:v];
    [v removeFromSuperview];
}
*/


- (void)positionPlayer {
    
    if (isIPhone){ 
        self.playerLayer.bounds = CGRectMake(0, 0, 640, 300);
        self.playerLayer.position = CGPointMake(260, 150);
        [self.vidWait setCenter:CGPointMake(120, 120)];
    }
    else{ //ipad
        self.playerLayer.bounds = CGRectMake(0, 0, 852, 480);
        self.playerLayer.position = CGPointMake(520, 382);
        [self.vidWait setCenter:CGPointMake(400, 400)];
    }
    
    self.playerLayer.borderColor = [UIColor blackColor].CGColor;
    self.playerLayer.borderWidth = 8.0;
    self.playerLayer.backgroundColor = [UIColor blackColor].CGColor;
	self.playerLayer.shadowOffset = CGSizeMake(0, 3);
	self.playerLayer.shadowOpacity = 0.80;
    self.playerLayer.opacity = 1.0;

    self.videoControlView.alpha = 1.0;

    if(isIPhone){
        [self addTouchLayerToVideo];
    }
}

- (void)addTouchLayerToVideo{
    //add invisible touch button to view
    UIButton *evtButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [evtButton addTarget:self 
                  action:@selector(videoTouched) forControlEvents:UIControlEventTouchUpInside];
    
    evtButton.frame = self.playerLayer.frame;
    //evtButton.backgroundColor = [UIColor greenColor];
    evtButton.bounds = self.playerLayer.bounds;
    evtButton.tag = VIDEO_BTN_IDX;
    [self.view addSubview:evtButton];
}

-(void)videoTouched{
    // NSLog(@"video layer touched!");
    [self.videoControlView fadeInControls];
}


- (CMTime)playerItemDuration {
    return([self.player currentTime]);
}

- (void)updateControls {
	[self updateTimeElapsed];
	[self updateTimeRemaining];
	[self updateSlider];
    if(isIPhone){
        [self checkVideoControlViewFade];
    }
}

- (void)updateControlsForSlider {
	[self updateTimeElapsed];
	[self updateTimeRemaining];
	[self updateSlider];
}

- (void)updateTimeElapsed {
    self.videoControlView.timeElapsed.text = timeStringForSeconds([self currentTimeInSeconds]);
}

- (void)checkVideoControlViewFade {
    if(self.videoControlView.alpha == 1.0){
        self.videoControlView.visibleCounter++;
    }
    if( self.videoControlView.visibleCounter > 3 ){
        [self.videoControlView fadeOutControls];
    }
}

- (void)updateTimeRemaining {
	self.videoControlView.timeRemaining.text = [NSString stringWithFormat:@"-%@", timeStringForSeconds([self timeRemainingInSeconds])];
	//NSLog(@"time remaining...");
}

/////////////////////////
/////////////////////////
// scrubbing and slider

- (void)updateSlider {
	self.videoControlView.videoSlider.maximumValue = [self durationInSeconds];
	self.videoControlView.videoSlider.value = [self currentTimeInSeconds];
}

- (IBAction)startScrubbing:(id)sender {
	if (self.timeObserver != nil) {
		[self.player removeTimeObserver:self.timeObserver];
		self.timeObserver = nil;
	}
	[self.player pause];
    [self.videoControlView togglePlayPauseButton:YES];
}


- (IBAction)stopScrubbing:(id)sender {
    if(isIPhone){
        [self.videoControlView resetCounter];
    }
	[self addTimeObserver];
    [self.player play];
}

- (IBAction)scrubValueChanged:(id)sender {
	[self seekToSeconds:((UISlider *)sender).value];
}

- (void)seekToSeconds:(Float64)seconds {
	[self.player seekToTime:CMTimeMakeWithSeconds(seconds, NSEC_PER_SEC)];
	[self updateControlsForSlider];
}

static NSString *timeStringForSeconds(Float64 seconds) {
	NSUInteger minutes = seconds / 60;
	NSUInteger secondsLeftOver = seconds - (minutes * 60);
	return [NSString stringWithFormat:@"%02ld:%02ld", minutes, secondsLeftOver];
}

static Float64 secondsWithCMTimeOrZeroIfInvalid(CMTime time) {
	return CMTIME_IS_INVALID(time) ? 0.0f : CMTimeGetSeconds(time);
}
- (Float64)durationInSeconds {
	return secondsWithCMTimeOrZeroIfInvalid(self.movieDuration);
}
- (Float64)currentTimeInSeconds {
	return secondsWithCMTimeOrZeroIfInvalid([self.player currentTime]);
}

- (Float64)timeRemainingInSeconds {
	return [self durationInSeconds] - [self currentTimeInSeconds];
}


///////////////////////
///////////////////////
// observerers

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (context == AVSPPlayerLayerReadyForDisplay) {
		if ([[change objectForKey:NSKeyValueChangeNewKey] boolValue] == YES) {
			// The AVPlayerLayer is ready for display. Hide the loading spinner and show it.
			[self.playerLayer setHidden:NO];
            [self.vidWait setHidden:YES];
            
            [self addTimeObserver];
            self.movieDuration = self.player.currentItem.asset.duration;
		}
	}
}


- (void)removeTimeObserver {
	if (self.timeObserver != nil) {
		[self.player removeTimeObserver:self.timeObserver];
		self.timeObserver = nil;
	}
}


- (void)addTimeObserver {
	[self removeTimeObserver];
	self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1, NSEC_PER_SEC) queue:nil usingBlock:^(CMTime time) {
		[self updateControls];
		//[self checkIfAtEndOfMovie];
	}];
	
}

///////////////////////////
///////////////////////////
///////////////////////////


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.isIPhone = UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad;
    }
    return self;
}

- (void)viewDidLoad
{
    if(isIPhone){
        self.videoControlView.alpha = 0.0f;
    }
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // turn off portrait support
    
    if (interfaceOrientation == UIInterfaceOrientationPortrait)
        return NO;
    else
        return YES;
}


- (void)dealloc {
    [self removeTimeObserver];
    [self.player release];
    [self.playerLayer release];
    [videoControlView release];
    [super dealloc];
}

@end
