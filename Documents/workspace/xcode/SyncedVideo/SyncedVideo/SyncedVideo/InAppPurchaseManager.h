//
//  InAppPurchaseManager.h
//  SyncedVideo
//
//  Created by Ben Gardella on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <StoreKit/StoreKit.h>



#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"
#define kInAppPurchaseManagerTransactionFailedNotification @"kInAppPurchaseManagerTransactionFailedNotification"
#define kInAppPurchaseManagerTransactionSucceededNotification @"kInAppPurchaseManagerTransactionSucceededNotification"


@interface InAppPurchaseManager : NSObject <UIAlertViewDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver>{
    
    SKProductsRequest *productsRequest;
    
    UIAlertView *askToPurchase;
    SKProduct *chosenProduct;
} 

@property (nonatomic, retain) SKProduct *chosenProduct;


#pragma mark Singleton Method
+ (id)getInstance;

// public methods
- (void)loadStore;
- (void)makePurchase:(SKProduct *)product;

- (void)requestProductData;
- (void)getProductArray;

@end
