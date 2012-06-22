//
//  StoreViewController.m
//  SyncedVideo
//
//  Created by Ben Gardella on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StoreViewController.h"
#import "InAppPurchaseManager.h"

@interface StoreViewController ()

@end

@implementation StoreViewController

static float IPHONE_FONT_SIZE = 14;
static float IPAD_FONT_SIZE = 25;

@synthesize isIPhone;
@synthesize products;

- (IBAction)cancel:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)displayProducts:(NSNotification*)notification {    
    
    products = [(NSArray *)notification.object retain];
    /*
    for(SKProduct *prod in products){
        if(prod){
            NSLog(@"Product title: %@" , prod.localizedTitle);
            NSLog(@"Product description: %@" , prod.localizedDescription);
            NSLog(@"Product price: %@" , prod.price);
            NSLog(@"Product id: %@" , prod.productIdentifier);
        }
    }
    */
    [tableView reloadData];
}

///////////////////////////
///////////////////////////
///////////////////////////


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.isIPhone = UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad;
        
        //call manager singleton
        InAppPurchaseManager *inAppPurchaseManager = [InAppPurchaseManager getInstance];
        [inAppPurchaseManager getProductArray];
        
    }
    return self;
}


- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    NSArray *productList = nil;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(displayProducts:) 
                                                 name:kInAppPurchaseManagerProductsFetchedNotification
                                               object:productList];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // turn off portrait support
    
    if (interfaceOrientation == UIInterfaceOrientationPortrait)
        return NO;
    else
        return YES;
}


///////////////////////////
///////////////////////////
///////////////////////////
// Table View Stuff

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4; // Number of rows
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if(self.products == nil){
        cell.textLabel.text = @"...";
    }else {
        //NSLog(@"prod list desc: %@", self.products);
        //NSLog(@"index path row num: %i", indexPath.row);
        /*
        for(SKProduct *prod in self.products){
            if(prod){
                NSLog(@"xProduct title: %@" , prod.localizedTitle);
                NSLog(@"xProduct description: %@" , prod.localizedDescription);
                NSLog(@"xProduct price: %@" , prod.price);
                NSLog(@"xProduct id: %@" , prod.productIdentifier);
            }
        }
        */
        
        SKProduct *skProduct = [self.products objectAtIndex:[indexPath row]];
        
        if(isIPhone){
            cell.textLabel.font = [UIFont fontWithName:@"Noteworthy" size:IPHONE_FONT_SIZE];
        }else{
            cell.textLabel.font = [UIFont fontWithName:@"Noteworthy" size:IPAD_FONT_SIZE];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"($%@) %@", 
                                            skProduct.price,
                                            skProduct.localizedDescription];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SKProduct *skProduct = [self.products objectAtIndex:[indexPath row]];
    
    NSLog(@"Tapped cell %@",skProduct.productIdentifier);
    
     //call manager singleton
     InAppPurchaseManager *inAppPurchaseManager = [InAppPurchaseManager getInstance];
     [inAppPurchaseManager makePurchase:skProduct];
}



@end
