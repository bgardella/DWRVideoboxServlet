//
//  SyncedVideoViewController.m
//  SyncedVideo
//
//  Created by Ben Gardella on 3/29/12.
//  Copyright (c) 2012 Emmett's Older Brother Prod. All rights reserved.
//

#import "SyncedVideoViewController.h"
#import "SyncedVideoAppDelegate.h"
#import "VideoPlayerViewController.h"
#import "SSZipArchive.h"

@implementation SyncedVideoViewController

static NSString *SERVER_URL         = @"http://gardella.org/sophie/";
static float PAD_SCROLL_IMG_WIDTH   = 1760;
static float PHONE_SCROLL_IMG_WIDTH = 890;
static float PAD_SCROLL_WIDTH       = 1024;
static float PHONE_SCROLL_WIDTH     = 480;
static float PAD_STICKY_SIZE        = 300;
static float PHONE_STICKY_SIZE      = 150;

@synthesize networkQueue;

-(IBAction)makePurchase:(id)sender{
    
    NSLog(@"MAKE PURCHASE!!!");
    
    //call manager singleton
//    InAppPurchaseManager *inAppPurchaseManager = [InAppPurchaseManager getInstance];
//    [inAppPurchaseManager requestProductData];
 
    [self fetchSongPackFromServer:@"SP-001"];
    
    //[self unzipDownload];
}
 
-(IBAction)flipToVideoView:(id)sender{
    
    SyncedVideoAppDelegate * myDel = 
    ( SyncedVideoAppDelegate * ) [ [ UIApplication sharedApplication ] delegate ];
    
    [myDel flipToVideoViewWithButtonId:sender];
    
}

//////////////////////////////////
//////////////////////////////////
//////////////////////////////////
// scrolling stuff

- (IBAction)changePage:(id)sender{
    
    int pgOffset = 480;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){ //ipad
        pgOffset = 1024;
    }
    
    NSLog(@"page change: %i", pageControl.currentPage);
    //page 0 : 0 offset
    //page 1 : 480 or 1024 offset
    CGPoint pt = scrollView.contentOffset;
    CGPoint newPt = CGPointMake(pageControl.currentPage*pgOffset, pt.y);
    [scrollView setContentOffset:newPt animated:YES];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)passedScrollView {
    
    [self snapScroll];
    
    NSLog(@"SCROLL VIEW HERE!!!");
    CGFloat pageWidth = passedScrollView.frame.size.width;
    int xoff =  passedScrollView.contentOffset.x;
    float pageFloat = xoff/pageWidth;
    int page = (int)(pageFloat + 0.5f);
    
    NSLog(@"xoff:%i, width:%f, page:%i", xoff, pageWidth, page);
    
    
    pageControl.currentPage = page;
}

- (void) snapScroll;{
    int scrollWidth = PHONE_SCROLL_WIDTH;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){ //ipad
        scrollWidth = PAD_SCROLL_WIDTH;
    }
    
    int temp = (scrollView.contentOffset.x+(scrollWidth/2)) / scrollWidth;
    [scrollView setContentOffset:CGPointMake(temp*scrollWidth , 0) animated:YES];
    int xoff =  scrollView.contentOffset.x;
    NSLog(@"xoff after snap:%i", xoff);
}

//////////////////////////////////
//////////////////////////////////
//////////////////////////////////


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // turn off portrait support
    
    if (interfaceOrientation == UIInterfaceOrientationPortrait)
        return NO;
    else
        return YES;
}


- (void)viewDidLoad {
	// Do any additional setup after loading the view, typically from a nib.
 
    [self setupSongPackViews];
        
    NSString *packId = nil;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifySongPackPurchase:) 
                                                 name:kInAppPurchaseManagerTransactionSucceededNotification
                                               object:packId];
    
    self.networkQueue = [ASINetworkQueue queue];
    
    [super viewDidLoad];
}




- (void)setupSongPackViews{
    
    // check for installed song packs
    NSArray *paths = [[NSBundle mainBundle] pathsForResourcesOfType:@"manifest" inDirectory:nil];
    NSLog(@"Number of song packs installed: %i", paths.count);
 
    for(NSString *path in paths){
        NSLog(@"pack path: %@", path);
    }
    
    if(paths.count > 1){
        //scrollable corkboard
        [scrollView setScrollEnabled:YES];
     
        pageControl.numberOfPages = paths.count;
        pageControl.currentPage = 0;
        
        //resize the width of the scroll view and background image   
        int bgImageHeight = scrollBackgroundImageView.bounds.size.height;
        int bgScrollHeight = scrollView.bounds.size.height;
        int imgWidthAdjusted = PHONE_SCROLL_IMG_WIDTH*paths.count;
        int widthAdjusted = PHONE_SCROLL_WIDTH*paths.count;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){ //ipad
            imgWidthAdjusted = PAD_SCROLL_IMG_WIDTH*paths.count;
            widthAdjusted = PAD_SCROLL_WIDTH*paths.count;
        }
        
        [scrollBackgroundImageView setBounds:CGRectMake(scrollBackgroundImageView.bounds.origin.x, 
                                                        scrollBackgroundImageView.bounds.origin.y, 
                                                        imgWidthAdjusted, bgImageHeight)];
        
        [scrollView setContentSize:CGSizeMake(widthAdjusted, bgScrollHeight)];
        
        scrollBackgroundImageView.backgroundColor = [UIColor colorWithPatternImage:
                                                     [UIImage imageNamed:@"cork_board_seemless.png"]];
        
        //NSLog(@"adjusted width:%i", widthAdjusted);
        
        [self addSongPackButtons:paths];
        
    }else {
        [scrollView setScrollEnabled:NO];
        pageControl.hidden = YES;
    }
    

}

- (void)addSongPackButtons:(NSArray *)songPackPaths{
    
    for(int i=0; i<songPackPaths.count; i++){
    //for (NSString *manifestFilePath in songPackPaths) {
        NSString *manifestFilePath = [songPackPaths objectAtIndex:i];
         NSLog(@"manifestFilePath: %@", manifestFilePath);
        
        NSData *fileContents = [NSData dataWithContentsOfFile:manifestFilePath];
        NSString *content = [NSString stringWithUTF8String:[fileContents bytes]];
        //[fileContents release];
        NSArray *values = [content componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        
        NSString *buttonOne;
        NSString *btnOneTitle;
        NSString *buttonTwo;
        NSString *btnTwoTitle;
        NSString *packId;
        
        for(NSString *line in values){
            if([line hasPrefix:@"button_1_id"]){
                NSArray *arr = [line componentsSeparatedByString:@"="];
                buttonOne = [arr objectAtIndex:1];
            }
            if([line hasPrefix:@"button_1_title"]){
                NSArray *arr = [line componentsSeparatedByString:@"="];
                btnOneTitle = [arr objectAtIndex:1];
            }
            if([line hasPrefix:@"button_2_id"]){
                NSArray *arr = [line componentsSeparatedByString:@"="];
                buttonTwo = [arr objectAtIndex:1];
            }
            if([line hasPrefix:@"button_2_title"]){
                NSArray *arr = [line componentsSeparatedByString:@"="];
                btnTwoTitle = [arr objectAtIndex:1];
            }
            if([line hasPrefix:@"pack_id"]){
                NSArray *arr = [line componentsSeparatedByString:@"="];
                packId = [arr objectAtIndex:1];
            }
            
        }
                
        [self createSongPackButtons:buttonOne :btnOneTitle :buttonTwo :btnTwoTitle :packId];
    }
    
}

- (void)createSongPackButtons:  (NSString *)buttonId1 
                             :  (NSString *)btnOneTitle 
                             :  (NSString *)buttonId2
                             :  (NSString *)btnTwoTitle
                             :  (NSString *)packId{
    NSLog(@"CREATE button one: %@ button two: %@ pack id: %@", buttonId1, buttonId2, packId);
    
    if(packId.intValue > 0){

        NSString *imgPath = [[NSBundle mainBundle] pathForResource:@"post_it_big" ofType:@"png"];
        UIImage *image = [UIImage imageWithContentsOfFile:imgPath];
        
        int fontSize1 = 29;
        int fontSize2 = 29;
        int xbtn1 = 73+(PHONE_SCROLL_WIDTH*packId.intValue);
        int xbtn2 = 267+(PHONE_SCROLL_WIDTH*packId.intValue);
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){ //ipad
            xbtn1 = 147+(PAD_SCROLL_WIDTH*packId.intValue);
            xbtn2 = 617+(PAD_SCROLL_WIDTH*packId.intValue);
            
            fontSize1 = 60;
            fontSize2 = 60;

            if(btnOneTitle.length > 10){
                fontSize1 = 45;
            }
            if(btnTwoTitle.length > 10){
                fontSize2 = 45;
            }
        }else {
            if(btnOneTitle.length > 10){
                fontSize1 = 20;
            }
            if(btnTwoTitle.length > 10){
                fontSize2 = 20;
            }
        }
        
        UIButton *songButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [songButton1 addTarget:self action:@selector(flipToVideoView:) 
                     forControlEvents:UIControlEventTouchUpInside];
        
        [songButton1 setTitle:buttonId1 forState:UIControlStateNormal];
        [songButton1 setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        CGRect labelRect;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){ //ipad
            [songButton1 setFrame:CGRectMake(xbtn1,82,PAD_STICKY_SIZE,PAD_STICKY_SIZE)];
            labelRect = CGRectMake(30,-20,250,300);
        }else{
            [songButton1 setFrame:CGRectMake(xbtn1,2,PHONE_STICKY_SIZE,PHONE_STICKY_SIZE)];
            labelRect = CGRectMake(15,-10,120,150);
        }
        UILabel *label1 = [[UILabel alloc] initWithFrame:labelRect];
        label1.font = [UIFont fontWithName:@"Noteworthy" size:fontSize1];
        label1.textColor = UIColor.blackColor;
        [label1 setText:btnOneTitle];
        label1.backgroundColor = [UIColor clearColor];
        [label1 setTextAlignment:UITextAlignmentCenter];
        label1.numberOfLines = 3;
        [songButton1 addSubview:label1];
        [songButton1 setBackgroundImage:image forState:UIControlStateNormal];
        [scrollView addSubview:songButton1];
        
        UIButton *songButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [songButton2 addTarget:self action:@selector(flipToVideoView:) 
                     forControlEvents:UIControlEventTouchUpInside];
        
        [songButton2 setTitle:buttonId2 forState:UIControlStateNormal];
        [songButton2 setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){ //ipad
            [songButton2 setFrame:CGRectMake(xbtn2,82,PAD_STICKY_SIZE,PAD_STICKY_SIZE)];
        }else{
            [songButton2 setFrame:CGRectMake(xbtn2,2,PHONE_STICKY_SIZE,PHONE_STICKY_SIZE)];
        }
        UILabel *label2 = [[UILabel alloc] initWithFrame:labelRect];
        label2.font = [UIFont fontWithName:@"Noteworthy" size:fontSize2];
        label2.textColor = UIColor.blackColor;
        [label2 setText:btnTwoTitle];
        label2.backgroundColor = [UIColor clearColor];
        [label2 setTextAlignment:UITextAlignmentCenter];
        label2.numberOfLines = 3;
        [songButton2 addSubview:label2];
        [songButton2 setBackgroundImage:image forState:UIControlStateNormal];
        [scrollView addSubview:songButton2];
        
    }
}

- (void)notifySongPackPurchase:(NSNotification*)notification {

    NSString *packId = (NSString *)notification.object;
    
    NSLog(@"pack id purchased notified: %@", packId);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL hasPack = [defaults boolForKey:packId];

    if(hasPack){
        NSLog(@"pack found: %@ fetch from server...", packId);
        //load it from server

        [self fetchSongPackFromServer:packId];
        
    }else {
        NSLog(@"pack not found: %@", packId);
    }

}

- (void)fetchSongPackFromServer:(NSString *)packId{
    
    
    [self.networkQueue retain];
    NSString *packFileName = [NSString stringWithFormat:@"%@.zip", packId];
    
    NSString *str = [NSString stringWithFormat:@"%@%@", SERVER_URL,packFileName];
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:url] autorelease];
    
    NSString *path = [NSString stringWithFormat:@"%@/%@", [self documentFilePath], packFileName];
    NSString *tempPath =[NSString stringWithFormat:@"%@/%@.download", [self documentFilePath], packFileName];
    
    [request setDownloadDestinationPath:path];
    [request setTemporaryFileDownloadPath:tempPath];
    
    [request setRequestMethod:@"GET"];
    [request setDelegate:self];
    [request setDidFinishSelector: @selector(gotSongPackResponse:)];
    [request setDidFailSelector:@selector(gotSongPackResponseFail:)];
    [request setShowAccurateProgress:YES];
    
    //[downloadProgressView setAlpha:1.0];
    [dlProgressViewPanel setAlpha:0.8];
    
    [self.networkQueue cancelAllOperations];
    [self.networkQueue setShowAccurateProgress:YES];
    [self.networkQueue setDownloadProgressDelegate:downloadProgressView];
    [self.networkQueue setDelegate:self];
    [self.networkQueue setRequestDidFinishSelector:@selector(queueComplete:)];

    [self.networkQueue addOperation: request];
    [self.networkQueue go];
}



- (IBAction)cancelDownload:(id)sender{
    
    [self.networkQueue cancelAllOperations];
    [dlProgressViewPanel setAlpha:0];
}

- (void)queueComplete:(ASINetworkQueue *)queue{
    NSLog(@"dl queue complete");
    [dlProgressViewPanel setAlpha:0];
}

- (void)unzipDownload:(NSString *)zipFilePath{
    
    //[self printDirectory:[self documentFilePath]];
    //[self printDirectory:[self appBundleFilePath]];
    
    NSLog(@"Unziping file: %@", zipFilePath);
    NSLog(@"To directory: %@", [self appBundleFilePath]);
    BOOL success = [SSZipArchive unzipFileAtPath:zipFilePath toDestination:[self appBundleFilePath]];
    
    
    //check your work
    [self printDirectory:[self appBundleFilePath]];
    
    if(success){
        NSLog(@"unzip complete...");
        
        
    }else{
        NSLog(@"unzip failed!!!");
    }
    
}

- (void)gotSongPackResponse:(ASIHTTPRequest *)req{
 
    NSString *path = req.downloadDestinationPath;
    NSLog(@"pack downloaded: %@", path);
    
    //check dl directory..
    //[self printDirectory:[self documentFilePath]];
    
    [self unzipDownload:path];
    
    [self setupSongPackViews];
    
}

- (void)gotSongPackResponseFail:(ASIHTTPRequest *)req{
    
    NSLog(@"Song pack request failed: %i", req.responseStatusCode);
    NSLog(@"Song pack response status: %@", req.responseStatusMessage);
    NSLog(@"Song pack response string: %@", req.responseString);
    NSLog(@"responseData %@",[req responseData]);
    NSLog(@"responseHeaders %@",[req responseHeaders]);
}

//////////////////////////////////
//////////////////////////////////
//////////////////////////////////
// UTILITY METHODS

- (NSString *)documentFilePath{
    NSArray *dirArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [dirArray objectAtIndex:0];
}

- (NSString *)appBundleFilePath{
    return [[NSBundle mainBundle] bundlePath];
}

- (void)printDirectory:(NSString*)dirPath{
    NSLog(@"**************************************");
    NSFileManager *manager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *direnum = [manager enumeratorAtPath:dirPath];
    NSString *filename;
    NSError *attributesError = nil;
    while ((filename = [direnum nextObject] )) {
        NSString *fullPath = [dirPath stringByAppendingPathComponent:filename];
        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:fullPath error:&attributesError];
        NSNumber *fileSizeNumber = [fileAttributes objectForKey:NSFileSize];
        long long fileSize = [fileSizeNumber longLongValue];
        
        NSLog(@"%@ : %llx",fullPath, fileSize);
    }
    NSLog(@"**************************************");
}



- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}



- (void)dealloc {
    [self.networkQueue release];
    [super dealloc];
}
     
     
@end
