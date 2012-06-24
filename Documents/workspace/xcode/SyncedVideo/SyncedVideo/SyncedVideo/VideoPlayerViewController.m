//
//  VideoPlayerViewController.m
//  SyncedVideo
//
//  Created by Ben Gardella on 5/13/12.
//  Copyright (c) 2012 Emmett's Older Brother Prod. All rights reserved.
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
@synthesize videoControlView;
@synthesize karaokeView;
@synthesize timeObserver;
@synthesize timeCodeObserver;
@synthesize movieDuration;

@synthesize isIPhone;

- (IBAction)kViewDragButtonPressed:(id)sender withEvent:(UIEvent *) event{

    UIButton *btn = (UIButton *)sender;
    CGPoint point = [[[event allTouches] anyObject] locationInView:btn];
    float yPoint = karaokeView.center.y+point.y;
    
    [karaokeView dragMove:yPoint];
}

- (IBAction)kViewDragButtonFinished:(id)sender withEvent:(UIEvent *) event{
    
    UIButton *btn = (UIButton *)sender;
    CGPoint point = [[[event allTouches] anyObject] locationInView:btn];
    float yPoint = karaokeView.center.y+point.y;
    
    [karaokeView dragFinished:yPoint];
}

- (IBAction)flipToHomeView:(id)sender {
    
    [self stopAVPlayer]; 
    
    SyncedVideoAppDelegate * myDel = 
    ( SyncedVideoAppDelegate * ) [ [ UIApplication sharedApplication ] delegate ];
    
    [myDel flipToHomeView];
}


- (void)loadVideoByButtonPress:(UIButton *)buttonPressed{
    //NSString *vidTitle;
    //NSString *lrcTitle;
    /*
    if([buttonPressed.titleLabel.text isEqualToString:@"Froggie"]){
        vidTitle = @"froggie";
        lrcTitle = @"froggie";
    }
    if([buttonPressed.titleLabel.text isEqualToString:@"Wheels"]){
        vidTitle = @"wheels";
        lrcTitle = @"wheels";
    }
    */
    
    NSString *titleString = buttonPressed.titleLabel.text.lowercaseString;
    
    [self messWithAudio];
    
    [self playThatLayer:(titleString)
                       :(titleString)];
}


- (void)playThatLayer:(NSString *)vidTitle
                     :(NSString *)lrcTitle {
	
    [self parseLRCFile:lrcTitle];
    
    int counter = 0;
    while(karaokeTimeArr.count == 0 || karaokeLyricArr.count == 0){
        NSLog(@"KARAOKE LYRICS DID NOT LOAD!!!!!");
        [self parseLRCFile:lrcTitle];
        counter++;
        if(counter > 5){
            break;
        }
    }
    
    NSString *moviePath = [[NSBundle mainBundle] pathForResource:vidTitle ofType:@"mp4"];
    if(moviePath == nil){
        moviePath = [NSString stringWithFormat:@"%@/%@.%@", [self documentFilePath], vidTitle, @"mp4"];
    }
    
    // Setup AVPlayer
    //status check
    if(self.player){
        [self.player pause];
        [self.player release];
    }
    
    self.player = [[[AVPlayer alloc] initWithURL:[NSURL fileURLWithPath:moviePath]] autorelease];
    
	self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    
    //position the player
    [self positionPlayer];
    
    //add observer onto playerLayer so we can cancel the spinny
    [self.playerLayer addObserver:self forKeyPath:@"readyForDisplay" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:AVSPPlayerLayerReadyForDisplay];
    
    [self.view.layer addSublayer:self.playerLayer];	
    
	vidWait.alpha = 1.0;
    
    [self.playerLayer setHidden:YES];
    
    [self.karaokeView setText:@""];
    [self.karaokeView slideOut];
    [self.view bringSubviewToFront:self.karaokeView];
    [self.view bringSubviewToFront:self.videoControlView];    
    [self.videoControlView togglePlayPauseButton:(YES)];
    
    [self.player play];
    
    if(isIPhone){
        [self.videoControlView resetCounter];
    }
    
}

- (NSString *)documentFilePath{
    NSArray *dirArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [dirArray objectAtIndex:0];
}


- (void)parseLRCFile:(NSString *)lrcTitle{
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:lrcTitle ofType:@"lrc"];
    if(filePath == nil){
        filePath = [NSString stringWithFormat:@"%@/%@.%@", [self documentFilePath], lrcTitle, @"lrc"];
    }
    
    NSData *fileContents = [NSData dataWithContentsOfFile:filePath];
    NSString *content = [NSString stringWithUTF8String:[fileContents bytes]];
    NSArray *values = [content componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    karaokeTimeArr = [[NSMutableArray alloc] initWithCapacity:values.count];
    karaokeLyricArr = [[NSMutableArray alloc] initWithCapacity:values.count];
    
    NSUInteger counter = 0;
    
    for (NSString *lineStr in values) {
        
        NSRange range1 = [lineStr rangeOfString:@"["];
        NSRange range2 = [lineStr rangeOfString:@"]"];
        if ((range1.length == 1) && (range2.length == 1) && (range2.location > range1.location)) {
            NSRange range3;
            range3.location = range1.location+1;
            range3.length = (range2.location - range1.location)-1;
            NSString *timeStampStr = [lineStr substringWithRange:range3];
            
            if(range3.length < lineStr.length-2){
                NSRange range4;
                range4.location = range2.location+1;
                range4.length = (lineStr.length - range4.location);
                
                //NSLog(@"range4 loc: %d, len: %d, strlen: %d", range4.location, range4.length, lineStr.length);
                NSString *lyricStr = [lineStr substringWithRange:range4];
                
                if (![lyricStr hasPrefix:@"---"]){
                    NSNumber *num = timeForKaraokeTimeString(timeStampStr);
                    NSLog(@"original: %@, parsed: %llu", timeStampStr, num.longLongValue);
                    [karaokeTimeArr insertObject:num atIndex:counter];
                    [karaokeLyricArr insertObject:lyricStr atIndex:counter];
                    
                    //NSLog(@"line: %@", lyricStr);
                    counter++;
                }
            }
        }
        
    }
/*
    NSLog(@"***************************");
    counter = 0;
    for(NSString *key in keyArr){
        NSString *tsCode = [keyArr objectAtIndex:counter];
        NSString *lyric = [valArr objectAtIndex:counter];
        
        NSLog(@"tc: %@ || lyric:%@", tsCode,lyric);
        counter++;
    }
    NSLog(@"***************************");
    
    karaokeDictionary =  [[NSDictionary alloc] initWithObjects:valArr forKeys:keyArr];
*/
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
    [self removeTimeCodeObserver];
    
    if(self.playerLayer != nil){
        self.playerLayer.opacity = 0.0f;
        [self.playerLayer setHidden:YES];
    }
}

- (IBAction)toggleFullScreen:(id)sender{
    if (!isIPhone) {
        if(self.playerLayer.bounds.size.width == 852){
            self.playerLayer.bounds = CGRectMake(0, 0, 1024, 577);
            self.playerLayer.position = CGPointMake(512, 354);
        }else {
            self.playerLayer.bounds = CGRectMake(0, 0, 852, 480);
            self.playerLayer.position = CGPointMake(520, 322);
        }
    }
}

- (void)positionPlayer {
    
    if (isIPhone) {
        self.playerLayer.bounds = CGRectMake(0, 0, 640, 300);
        self.playerLayer.position = CGPointMake(260, 150);
    }
    else { //ipad
        self.playerLayer.bounds = CGRectMake(0, 0, 852, 480); //start windowed-view
        self.playerLayer.position = CGPointMake(520, 322);
    }
    
    self.playerLayer.borderColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6].CGColor;
    self.playerLayer.borderWidth = 2.0;
    /* 
    self.playerLayer.backgroundColor = [UIColor blackColor].CGColor;
	self.playerLayer.shadowOffset = CGSizeMake(0, 3);
	self.playerLayer.shadowOpacity = 0.80;
    self.playerLayer.opacity = 1.0;
    */
    self.videoControlView.alpha = 1.0;

    if(isIPhone) {
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
    [self.karaokeView hide];
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

- (void)updateTimeCode {
    
    Float64 dur = CMTimeGetSeconds([self.player currentTime]);
    NSNumber *milliMovieSec = [NSNumber numberWithUnsignedLongLong:1000*dur];
    
    for(int idx = 0; idx < karaokeTimeArr.count; idx++){
        NSNumber *kTime = [karaokeTimeArr objectAtIndex:idx];
        if(kTime.longLongValue < milliMovieSec.longLongValue+100 && 
           kTime.longLongValue > milliMovieSec.longLongValue-100) {
            NSString *lyric = [karaokeLyricArr objectAtIndex:idx];
            [self.karaokeView setText:lyric];
            NSLog(@"ktime:%llu, mtime:%llu, lyric:%@", kTime.longLongValue, milliMovieSec.longLongValue, lyric);
            break;
        }
    }
}

- (void)updateTimeCodeNearest {
    
    Float64 dur = CMTimeGetSeconds([self.player currentTime]);
    NSNumber *milliMovieSec = [NSNumber numberWithUnsignedLongLong:1000*dur];
    
    for(int idx = 0; idx < karaokeTimeArr.count; idx++){
        NSNumber *kTime = [karaokeTimeArr objectAtIndex:idx];
        if(kTime.longLongValue > milliMovieSec.longLongValue-100 && idx > 0) {
            NSString *lyric = [karaokeLyricArr objectAtIndex:idx-1];
            [self.karaokeView setText:lyric];
            NSLog(@"ktime:%llu, mtime:%llu, lyric:%@", kTime.longLongValue, milliMovieSec.longLongValue, lyric);
            break;
        }
    }
}

- (void)checkVideoControlViewFade {
    if(self.videoControlView.alpha == 1.0){
        self.videoControlView.visibleCounter++;
    }
    if( self.videoControlView.visibleCounter > 3 ){
        [self.videoControlView fadeOutControls];
        [self.karaokeView show];
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
	[self removeTimeObserver];
    [self removeTimeCodeObserver];
	[self.player pause];
    [self.videoControlView togglePlayPauseButton:YES];
}


- (IBAction)stopScrubbing:(id)sender {
    if(isIPhone){
        [self.videoControlView resetCounter];
    }
    [self.karaokeView setText:@""];
    [self updateTimeCodeNearest];
	[self addTimeObserver];
    [self addTimeCodeObserver];
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
static NSNumber *timeForKaraokeTimeString(NSString *karaokeStr) {
    
    //NSLog(@"Time str: %@", karaokeStr);
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSArray *values = [karaokeStr componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":"]];
    
    if(values.count == 2){
        NSString *frag = [values objectAtIndex:0];
        NSNumber *minutes = [f numberFromString:frag];
        NSString *frag2 = [values objectAtIndex:1];
        NSNumber *seconds = [f numberFromString:frag2];
        
        int m = [minutes intValue];
        Float64 f = [seconds floatValue];
        
        CMTime cmtime = CMTimeMakeWithSeconds((m*60)+f, 1000);
        //return (NSString *)CMTimeCopyDescription(NULL, cmtime);
        NSNumber *val = [NSNumber numberWithUnsignedLongLong:cmtime.value];
        return val;
    }
    return 0;
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
            [vidWait setHidden:YES];
            
            [self addTimeObserver];
            [self addTimeCodeObserver];
            self.movieDuration = self.player.currentItem.asset.duration;
            [self.karaokeView slideIn];
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

- (void)addTimeCodeObserver {
	[self removeTimeCodeObserver];
	self.timeCodeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(0.001, 1000) queue:nil usingBlock:^(CMTime time) {
		[self updateTimeCode];
	}];
	
}

- (void)removeTimeCodeObserver {
	if (self.timeCodeObserver != nil) {
		[self.player removeTimeObserver:self.timeCodeObserver];
		self.timeCodeObserver = nil;
	}
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
        self.karaokeView.alpha = 1.0f;
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
    [self removeTimeCodeObserver];
    [self.player release];
    [self.playerLayer release];
    [videoControlView release];
    [karaokeTimeArr release];
    [karaokeLyricArr release];
    [super dealloc];
}

@end
