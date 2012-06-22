//
//  StoreViewController.h
//  SyncedVideo
//
//  Created by Ben Gardella on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreViewController : UIViewController  <UITableViewDelegate, UITableViewDataSource>{
@private
    BOOL isIPhone;
    IBOutlet UITableView *tableView;
    NSArray *products;
}

@property (nonatomic, assign) BOOL isIPhone;
@property (nonatomic, retain) NSArray *products;


- (IBAction)cancel:(id)sender;

@end
