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

static float IPHONE_FONT_SIZE = 12;
static float IPAD_FONT_SIZE = 16;

@synthesize isIPhone;
@synthesize products;
@synthesize reDownloadId;


- (IBAction)cancel:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)notifySongPackPurchase:(NSNotification*)notification {
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
    
    NSString *packId = nil;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifySongPackPurchase:) 
                                                 name:kInAppPurchaseManagerTransactionSucceededNotification
                                               object:packId];
    
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

- (BOOL)isPackInstalled:(NSString *)packId{
    NSArray *paths = [[NSBundle mainBundle] pathsForResourcesOfType:@"manifest" inDirectory:nil];
    for(int i=0; i<paths.count; i++){
        NSString *manifestFilePath = [paths objectAtIndex:i];
        //NSLog(@"manifest: %@", manifestFilePath);
        
        NSData *fileContents = [NSData dataWithContentsOfFile:manifestFilePath];
        NSString *content = [NSString stringWithUTF8String:[fileContents bytes]];
        NSArray *values = [content componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        for(NSString *line in values){
            if([line hasPrefix:@"product_id"]){
                NSArray *arr = [line componentsSeparatedByString:@"="];
                NSString *installedId = [arr objectAtIndex:1];
                //NSLog(@"is pack installed: %@ == %@", packId, installedId);
                if([packId isEqualToString:installedId]){
                    return YES;
                }
            }
        }
    }
    return NO;
}

- (BOOL)isPackPurchased:(NSString *)packId{
    // check the defaults for a purchase receipt
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *prodReceipt = [prefs stringForKey:packId];
    if(prodReceipt){
        return YES;
    }
    return NO;
}


- (void)presentInstalledAlert{
    
    installedAlert =  [[UIAlertView alloc] 
                                         initWithTitle:nil
                                         message:@"This song pack is already installed."
                                         delegate:self 
                                         cancelButtonTitle:nil
                                         otherButtonTitles:@"OK", nil]; 
    installedAlert.delegate = self;
    [installedAlert show];
    [installedAlert release];
}

- (void)presentPurchasedAlert{
    
    purchasedAlert =  [[UIAlertView alloc] 
                           initWithTitle:nil
                           message:@"This song pack has already been purchased. Would you like to download it again?"
                           delegate:self 
                           cancelButtonTitle:nil
                           otherButtonTitles:@"YES", @"NO", nil]; 
    purchasedAlert.delegate = self;
    [purchasedAlert show];
    [purchasedAlert release];
}

#pragma mark AlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView==purchasedAlert) {
        if (buttonIndex==0) { //YES -- re-download
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionSucceededNotification 
                                                                object:reDownloadId];
            
            [reDownloadId release];
            
        }
    }
    
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    if(self.products == nil){
        cell.textLabel.text = @"...";
    }else {
        SKProduct *skProduct = [self.products objectAtIndex:[indexPath row]];
        
        if(isIPhone){
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:IPHONE_FONT_SIZE];
        }else{
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:IPAD_FONT_SIZE]; 
        }
        
        if([self isPackInstalled:skProduct.productIdentifier] ||
           [self isPackPurchased:skProduct.productIdentifier]){
            cell.accessoryType = UITableViewCellAccessoryCheckmark; //for purchased items
        }
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"$%@", skProduct.price];
        cell.textLabel.text = [NSString stringWithFormat:@"%@", skProduct.localizedDescription];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SKProduct *skProduct = [self.products objectAtIndex:[indexPath row]];
    
    NSLog(@"Tapped cell %@",skProduct.productIdentifier);
   
    if([self isPackPurchased:skProduct.productIdentifier] && 
       ![self isPackInstalled:skProduct.productIdentifier]){
        reDownloadId = [skProduct.productIdentifier retain];
        [self presentPurchasedAlert];
    }else if([self isPackInstalled:skProduct.productIdentifier]){
        [self presentInstalledAlert];
    }else {
        //call manager singleton
        InAppPurchaseManager *inAppPurchaseManager = [InAppPurchaseManager getInstance];
        [inAppPurchaseManager makePurchase:skProduct];
    }
}



@end
