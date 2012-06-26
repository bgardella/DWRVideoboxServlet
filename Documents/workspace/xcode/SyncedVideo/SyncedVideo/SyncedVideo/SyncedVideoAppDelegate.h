//
//  SyncedVideoAppDelegate.h
//  SyncedVideo
//
//  Created by Ben Gardella on 3/29/12.
//  Copyright (c) 2012 Sophie World LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SyncedVideoViewController;
@class VideoPlayerViewController;

@interface SyncedVideoAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    
    SyncedVideoViewController *viewController;
    VideoPlayerViewController *playerViewController;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SyncedVideoViewController *viewController;
@property (nonatomic, retain) IBOutlet VideoPlayerViewController *playerViewController;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;


- (void)flipToVideoViewWithButtonId:(id)sender;
- (void)flipToHomeView;

@end
