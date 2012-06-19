//
//  InAppPurchaseManager.m
//  SyncedVideo
//
//  Created by Ben Gardella on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InAppPurchaseManager.h"

@implementation InAppPurchaseManager
    
static NSString *songPackPrefix = @"com.sophieworld.sws.SP.";


#pragma mark Singleton Method

+ (id)getInstance {
    static InAppPurchaseManager *mgr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mgr = [[self alloc] init];
    });
    return mgr;
}


- (void)requestProductData {
    
     NSLog(@"request product data start...");
    
    askToPurchase = [[UIAlertView alloc] 
                     initWithTitle:@"Song Pack #1" 
                     message:@"Would you like to Purchase?"
                     delegate:self 
                     cancelButtonTitle:nil
                     otherButtonTitles:@"Yes", @"No", nil]; 
    askToPurchase.delegate = self;
    [askToPurchase show];
    [askToPurchase release];
    
}     
    

#pragma mark AlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView==askToPurchase) {
        if (buttonIndex==0) {
            // user tapped YES, but we need to check if IAP is enabled or not.
            if ([SKPaymentQueue canMakePayments]) { 
                
                
                NSString *songPackOne = [songPackPrefix stringByAppendingString:@"001"];
                
                SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:
                                              [NSSet setWithObject:songPackOne]];  
                
                request.delegate = self;  
                [request start];  
                
                
            } else {
                UIAlertView *tmp = [[UIAlertView alloc] 
                                    initWithTitle:@"Prohibited" 
                                    message:@"Parental Control is enabled, cannot make a purchase!"
                                    delegate:self 
                                    cancelButtonTitle:nil 
                                    otherButtonTitles:@"Ok", nil]; 
                [tmp show];
                [tmp release];
            }
        }
    }
    
}


#pragma mark request available products from store
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSArray *products = response.products;
    
    NSLog(@"product count:%i", products.count);
    
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
