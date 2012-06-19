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


@implementation SyncedVideoViewController


static NSString *songPackPrefix     = @"com.sophieworld.sws.SP.";
static float PAD_SCROLL_IMG_WIDTH   = 1524;
static float PHONE_SCROLL_IMG_WIDTH = 840;
static float PAD_SCROLL_WIDTH       = 1024;
static float PHONE_SCROLL_WIDTH     = 480;

-(IBAction)makePurchase:(id)sender{
    
    NSLog(@"MAKE PURCHASE!!!");
    
    //call manager singleton
    InAppPurchaseManager *inAppPurchaseManager = [InAppPurchaseManager getInstance];
    [inAppPurchaseManager requestProductData];
    
}
 
-(IBAction)flipToVideoView:(id)sender{
    
    SyncedVideoAppDelegate * myDel = 
    ( SyncedVideoAppDelegate * ) [ [ UIApplication sharedApplication ] delegate ];
    
    [myDel flipToVideoViewWithButtonId:sender];
    
}

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
    
    NSLog(@"SCROLL VIEW HERE!!!");
    CGFloat pageWidth = passedScrollView.frame.size.width;
    int xoff =  passedScrollView.contentOffset.x;
    NSLog(@"xoff:%i, width:%f", xoff, pageWidth);
    
    int page = xoff/3;
    pageControl.currentPage = page;
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
/*
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){ //ipad
        [scrollView setContentSize:CGSizeMake(1483, 483)];
    }else {
        [scrollView setContentSize:CGSizeMake(700, 128)];
    }
  */  
    [self setupSongPackViews];
        
    [super viewDidLoad];
}

- (void)setupSongPackViews{
    
    // check for installed song packs
    NSArray *paths = [[NSBundle mainBundle] pathsForResourcesOfType:@"manifest" inDirectory:nil];
    NSLog(@"Number of song packs installed: %i", paths.count);
 
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
        
        NSLog(@"adjusted width:%i", widthAdjusted);
        
        [self addSongPackButtons:paths];
        
    }else {
        [scrollView setScrollEnabled:NO];
        pageControl.hidden = YES;
    }
    

}

- (void)addSongPackButtons:(NSArray *)songPackPaths{
    
    for (NSString *manifestFilePath in songPackPaths) {
        
        NSData *fileContents = [NSData dataWithContentsOfFile:manifestFilePath];
        NSString *content = [NSString stringWithUTF8String:[fileContents bytes]];
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
    //NSLog(@"CREATE button one: %@ button two: %@ pack id: %@", buttonId1, buttonId2, packId);
    
    if(packId.intValue > 0){

        NSString *imgPath = [[NSBundle mainBundle] pathForResource:@"post_it_big" ofType:@"png"];
        UIImage *image = [UIImage imageWithContentsOfFile:imgPath];
        
        
        UIButton *songButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
        //[evtButton addTarget:self 
        //              action:@selector(videoTouched) forControlEvents:UIControlEventTouchUpInside];
        
        [songButton1 setFrame:CGRectMake(1171,82,300,300)];
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(31,2,300,300)];
        label1.font = [UIFont fontWithName:@"Noteworthy" size:60];
        label1.textColor = UIColor.blackColor;
        label1.text = btnOneTitle;
        label1.backgroundColor = [UIColor clearColor];
        [songButton1 addSubview:label1];
        [songButton1 setBackgroundImage:image forState:UIControlStateNormal];
        [scrollView addSubview:songButton1];
        
        UIButton *songButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [songButton2 setFrame:CGRectMake(1571,82,300,300)];
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(31,2,300,300)];
        label2.font = [UIFont fontWithName:@"Noteworthy" size:60];
        label2.textColor = UIColor.blackColor;
        label2.text = btnTwoTitle;
        label2.backgroundColor = [UIColor clearColor];
        [songButton2 addSubview:label2];
        [songButton2 setBackgroundImage:image forState:UIControlStateNormal];
        [scrollView addSubview:songButton2];
        
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}



- (void)dealloc {
    [super dealloc];
}
     
     
@end
