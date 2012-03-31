//
//  SyncedVideoAppDelegate.h
//  SyncedVideo
//
//  Created by Ben Gardella on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SyncedVideoViewController;

@interface SyncedVideoAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    SyncedVideoViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SyncedVideoViewController *viewController;

@end
