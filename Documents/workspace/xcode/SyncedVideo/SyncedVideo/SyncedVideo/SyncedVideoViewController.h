//
//  SyncedVideoViewController.h
//  SyncedVideo
//
//  Created by Ben Gardella on 3/29/12.
//  Copyright (c) 2012 Sophie World LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SyncedVideoAppDelegate.h"
#import "VideoPlayerViewController.h"
#import "SSZipArchive.h"
#import "StoreViewController.h"
#import "InAppPurchaseManager.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "DownloadProgressView.h"
#import "Utilities.h"

@interface SyncedVideoViewController : UIViewController{
@private    
    
    IBOutlet UIPageControl *pageControl;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIImageView *scrollBackgroundImageView;
    IBOutlet DownloadProgressView *downloadProgressView;
    IBOutlet UIView *dlProgressViewPanel;
    
    ASINetworkQueue *networkQueue;
}

@property(nonatomic, retain) ASINetworkQueue *networkQueue;


- (IBAction)flipToVideoView:(id)sender;
- (IBAction)changePage:(id)sender;
- (IBAction)makePurchase:(id)sender;
- (IBAction)cancelDownload:(id)sender;

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;

@end
