//
//  InAppPurchaseManager.h
//  SyncedVideo
//
//  Created by Ben Gardella on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <StoreKit/StoreKit.h>
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"


#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"
#define kInAppPurchaseManagerTransactionFailedNotification @"kInAppPurchaseManagerTransactionFailedNotification"
#define kInAppPurchaseManagerTransactionSucceededNotification @"kInAppPurchaseManagerTransactionSucceededNotification"


@interface InAppPurchaseManager : NSObject <UIAlertViewDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver>{
    
    SKProductsRequest *productsRequest;
    
    UIAlertView *askToPurchase;
} 

#pragma mark Singleton Method
+ (id)getInstance;

// public methods
- (void)loadStore;
- (BOOL)canMakePurchases;
- (void)purchaseSongPack:(NSString *)productId;

- (void)requestProductData;

@end
