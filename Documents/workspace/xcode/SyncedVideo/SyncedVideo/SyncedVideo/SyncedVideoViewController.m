//
//  SyncedVideoViewController.m
//  SyncedVideo
//
//  Created by Ben Gardella on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SyncedVideoViewController.h"
#import "SyncedVideoAppDelegate.h"
#import "VideoPlayerViewController.h"

@implementation SyncedVideoViewController




-(IBAction)flipToVideoView:(id)sender{
    
    SyncedVideoAppDelegate * myDel = 
    ( SyncedVideoAppDelegate * ) [ [ UIApplication sharedApplication ] delegate ];
    
    [myDel flipToVideoViewWithButtonId:sender];
    
}

- (IBAction)changePage:(id)sender{
    
    int pgOffset = 220;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){ //ipad
        pgOffset = 456;
    }
    
    NSLog(@"page change: %i", pageControl.currentPage);
    //page 0 : 0 offset
    //page 1 : 456 offset
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

    //scrollable corkboard
    [scrollView setScrollEnabled:YES];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){ //ipad
        [scrollView setContentSize:CGSizeMake(1483, 483)];
    }else {
        [scrollView setContentSize:CGSizeMake(700, 128)];
    }
    
    pageControl.numberOfPages = 2;
    pageControl.currentPage = 0;
    
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}



- (void)dealloc {
    [super dealloc];
}
     
     
@end
