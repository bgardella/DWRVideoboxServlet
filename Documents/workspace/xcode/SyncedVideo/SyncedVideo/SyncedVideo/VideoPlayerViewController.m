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

@synthesize videoControlView;

- (IBAction)flipToHomeView:(id)sender {
    
    SyncedVideoAppDelegate * myDel = 
    ( SyncedVideoAppDelegate * ) [ [ UIApplication sharedApplication ] delegate ];
    
    [myDel.navigationController popViewControllerAnimated:YES];
    
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
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

@end
