//
//  SyncedVideoViewController.h
//  SyncedVideo
//
//  Created by Ben Gardella on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SyncedVideoViewController : UIViewController {
@private    
    
    IBOutlet UIPageControl *pageControl;
    IBOutlet UIScrollView *scrollView;
}

- (IBAction)flipToVideoView:(id)sender;
- (IBAction)changePage:(id)sender;

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;

@end
