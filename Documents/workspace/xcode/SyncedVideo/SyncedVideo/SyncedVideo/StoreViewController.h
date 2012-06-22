//
//  StoreViewController.h
//  SyncedVideo
//
//  Created by Ben Gardella on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreViewController : UIViewController{
@private
    BOOL isIPhone;

}

@property (nonatomic, assign) BOOL isIPhone;

- (IBAction)cancel:(id)sender;

@end
