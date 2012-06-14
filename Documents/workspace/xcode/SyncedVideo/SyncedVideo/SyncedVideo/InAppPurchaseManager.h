//
//  InAppPurchaseManager.h
//  SyncedVideo
//
//  Created by Ben Gardella on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <StoreKit/StoreKit.h>

#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"


@interface InAppPurchaseManager : NSObject <SKProductsRequestDelegate>{
    SKProduct *songPackProduct;
    SKProductsRequest *productsRequest;
} 

@end
