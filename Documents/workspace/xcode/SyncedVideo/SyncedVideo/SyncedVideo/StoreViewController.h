//
//  StoreViewController.h
//  SyncedVideo
//
//  Created by Ben Gardella on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreViewController : UIViewController  
                <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>{
@private
    BOOL isIPhone;
    IBOutlet UITableView *tableView;
    NSArray *products;
    UIAlertView *purchasedAlert;
    UIAlertView *installedAlert;
    NSString *reDownloadId;
}

@property (nonatomic, assign) BOOL isIPhone;
@property (nonatomic, retain) NSArray *products;
@property (nonatomic, retain) NSString *reDownloadId;

- (IBAction)cancel:(id)sender;

@end
