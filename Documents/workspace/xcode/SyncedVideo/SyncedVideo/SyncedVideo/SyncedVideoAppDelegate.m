//
//  SyncedVideoAppDelegate.m
//  SyncedVideo
//
//  Created by Ben Gardella on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SyncedVideoAppDelegate.h"
#import "SyncedVideoViewController.h"
#import "VideoPlayerViewController.h"

@implementation SyncedVideoAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize playerViewController;
@synthesize navigationController;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //adding navigation controller manually
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){ 
        self.viewController = [[SyncedVideoViewController alloc] initWithNibName:@"IPadController" bundle:nil]; 
        self.playerViewController = [[VideoPlayerViewController alloc] initWithNibName:@"VideoPlayerViewController" bundle:nil]; 
    }else {
        self.viewController = [[SyncedVideoViewController alloc] initWithNibName:@"SyncedVideoViewController" bundle:nil]; 
        self.playerViewController = [[VideoPlayerViewController alloc] initWithNibName:@"VideoPlayerViewController-Phone" bundle:nil]; 
    }
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];      
    self.navigationController.navigationBarHidden = YES;
    
    [self.window addSubview:navigationController.view];  

    ///////////////////////////////////////////
    //without navigation controller
    //[window addSubview:viewController.view];
    ///////////////////////////////////////////
    
    [window makeKeyAndVisible];
    return YES;
}

- (void)flipToVideoViewWithButtonId:(id)sender{
    /*
    //check to see if the player is already playing or paused
    if(self.playerViewController.playerLayer.opacity == 0.99f){
        return;
    }
    if(self.playerViewController.player.rate != 0.0f){
        return;
    }
    */
    [navigationController pushViewController:playerViewController animated:YES];
    
    UIButton *playButton = (UIButton *) sender;
    if(playButton != nil){
        [playerViewController loadVideoByButtonPress:(playButton)];
    }
}
 
     
- (void)flipToHomeView{
    if(self.navigationController != nil){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [viewController release];
    [playerViewController release];
    [navigationController release];
    [window release];
    [super dealloc];
}



@end
