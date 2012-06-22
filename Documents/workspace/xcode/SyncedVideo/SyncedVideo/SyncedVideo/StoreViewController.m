//
//  StoreViewController.m
//  SyncedVideo
//
//  Created by Ben Gardella on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StoreViewController.h"

@interface StoreViewController ()

@end

@implementation StoreViewController

@synthesize isIPhone;

- (IBAction)cancel:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
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
