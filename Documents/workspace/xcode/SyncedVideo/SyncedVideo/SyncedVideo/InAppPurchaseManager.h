//
//  InAppPurchaseManager.h
//  SyncedVideo
//
//  Created by Ben Gardella on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <StoreKit/StoreKit.h>

#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"


@interface InAppPurchaseManager : NSObject <UIAlertViewDelegate, SKProductsRequestDelegate>{
    
    SKProduct *songPackProduct;
    SKProductsRequest *productsRequest;
    
    UIAlertView *askToPurchase;
} 

#pragma mark Singleton Method
+ (id)getInstance;


- (void)requestProductData;

@end
