//
//  VideoPlayerViewController.h
//  SyncedVideo
//
//  Created by Ben Gardella on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoControlView.h"

@interface VideoPlayerViewController : UIViewController{
    
@private
    VideoControlView *videoControlView;
    
}

@property (nonatomic, retain) IBOutlet VideoControlView *videoControlView;



- (IBAction)flipToHomeView:(id)sender;

@end


