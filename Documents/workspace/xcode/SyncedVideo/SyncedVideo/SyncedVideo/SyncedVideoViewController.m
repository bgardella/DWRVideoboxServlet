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
