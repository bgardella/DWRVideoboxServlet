//
//  gardellaDataViewController.m
//  ScrollViewTestMe
//
//  Created by Ben Gardella on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "gardellaDataViewController.h"

@interface gardellaDataViewController ()

@end

@implementation gardellaDataViewController

@synthesize dataLabel = _dataLabel;
@synthesize dataObject = _dataObject;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.dataLabel = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.dataLabel.text = [self.dataObject description];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
