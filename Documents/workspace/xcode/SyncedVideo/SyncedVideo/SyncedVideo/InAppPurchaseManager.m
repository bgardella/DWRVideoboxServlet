//
//  InAppPurchaseManager.m
//  SyncedVideo
//
//  Created by Ben Gardella on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InAppPurchaseManager.h"

@implementation InAppPurchaseManager
    
    
- (void)requestProductData {
    NSSet *productIdentifiers = [NSSet setWithObject:@"SP-001" ];
    productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
    
    // we will release the request object in the delegate callback
}     
    


- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSArray *products = response.products;
    
    songPackProduct = [products count] == 1 ? [[products objectAtIndex:0] retain] : nil;
    if (songPackProduct)
    {
        NSLog(@"Product title: %@" , songPackProduct.localizedTitle);
        NSLog(@"Product description: %@" , songPackProduct.localizedDescription);
        NSLog(@"Product price: %@" , songPackProduct.price);
        NSLog(@"Product id: %@" , songPackProduct.productIdentifier);
    }
    
    for (NSString *invalidProductId in response.invalidProductIdentifiers)
    {
        NSLog(@"Invalid product id: %@" , invalidProductId);
    }
    
    // finally release the reqest we alloc/init’ed in requestProUpgradeProductData
    [productsRequest release];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerProductsFetchedNotification object:self userInfo:nil];
} 




@end
