//
//  InAppPurchaseManager.m
//  SyncedVideo
//
//  Created by Ben Gardella on 6/12/12.
//  Copyright (c) 2012 Sophie World LLC. All rights reserved.
//

#import "InAppPurchaseManager.h"

@implementation InAppPurchaseManager
    
static NSString *songPackPrefix = @"com.sophieworld.sws.SP.";
@synthesize chosenProduct;

#pragma mark Singleton Method

+ (id)getInstance {
    static InAppPurchaseManager *mgr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mgr = [[self alloc] init];
    });
    
    [mgr loadStore];
    
    return mgr;
}


//
// call this method once on startup
//
- (void)loadStore
{
    // restarts any purchases if they were interrupted last time the app was open
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    // get the product description (defined in early sections)
    //[self requestProUpgradeProductData];
} 

- (void)makePurchase:(SKProduct *)product{
    
    chosenProduct = [product retain];
    
    askToPurchase = [[UIAlertView alloc] 
                     initWithTitle:product.localizedTitle
                     message:@"Would you like to Purchase?"
                     delegate:self 
                     cancelButtonTitle:nil
                     otherButtonTitles:@"Yes", @"No", nil]; 
    askToPurchase.delegate = self;
    [askToPurchase show];
    [askToPurchase release];
}


- (void)getProductArray {
    
    if ([SKPaymentQueue canMakePayments]) { 
        
        NSArray  *allPacksArr = [NSArray arrayWithObjects:
                                 [songPackPrefix stringByAppendingString:@"001"],
                                 [songPackPrefix stringByAppendingString:@"002"],
                                 [songPackPrefix stringByAppendingString:@"003"],
                                 [songPackPrefix stringByAppendingString:@"004"],
                                 nil];
        
        NSSet* allPacksSet = [NSSet setWithArray:allPacksArr];
        
        //NSString *songPackOne = [songPackPrefix stringByAppendingString:@"001"];
        
        SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:allPacksSet];
        
        request.delegate = self;  
        [request start];  
        
    }
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
    

// TODO: Show and Hide "Store UI View" so users can select a pack for purchase
// instead of using alertViews

#pragma mark AlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView==askToPurchase) {
        if (buttonIndex==0) {
            // user tapped YES, but we need to check if IAP is enabled or not.
            if ([SKPaymentQueue canMakePayments]) { 
                
                NSArray  *packArr = [NSArray arrayWithObjects:
                                         chosenProduct.productIdentifier,
                                         nil];
                
                NSSet* packSet = [NSSet setWithArray:packArr];
                SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:packSet];
                
                [chosenProduct release];
                
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

- (void)purchaseSongPack:(SKProduct *)product{
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
} 


#pragma mark request available products from store
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSArray *products = response.products;
    
    NSLog(@"product count:%i", products.count);
    /*
    for(SKProduct *prod in products){
        if(prod){
        NSLog(@"Product title: %@" , prod.localizedTitle);
        NSLog(@"Product description: %@" , prod.localizedDescription);
        NSLog(@"Product price: %@" , prod.price);
        NSLog(@"Product id: %@" , prod.productIdentifier);
        }
    }*/
    
    if(response.invalidProductIdentifiers.count > 0){
    
        for (NSString *invalidProductId in response.invalidProductIdentifiers){
            NSLog(@"Invalid product id: %@" , invalidProductId);
        }
    }else{
        
        if(products.count == 1){ //this is a purchase
            
            [self purchaseSongPack:[products objectAtIndex:0]];
            
        }else if(products.count > 1){ //this is a query
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerProductsFetchedNotification 
                                                                object:products userInfo:nil];
        }
    }
    
    // finally release the reqest we alloc/init’ed in requestProUpgradeProductData
    [productsRequest release];
} 


#pragma mark store transaction methods

- (void)provideContent:(NSString *)productId{
    // enable the song packs
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:productId ];
    [[NSUserDefaults standardUserDefaults] synchronize];
} 


//
// saves a record of the transaction by storing the receipt to disk
//
- (void)recordTransaction:(SKPaymentTransaction *)transaction{
    
    // save:  transaction.payment.productIdentifier
    
    //if ([transaction.payment.productIdentifier isEqualToString:kInAppPurchaseProUpgradeProductId])
    //{
        // save the transaction receipt to disk
        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:transaction.payment.productIdentifier ];
        [[NSUserDefaults standardUserDefaults] synchronize];
    //}
} 

//
// removes the transaction from the queue and posts a notification with the transaction result
//
- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful{
    // remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction" , nil];
    if (wasSuccessful){
        
        ////////////////skip receipt validation for now//////////////////
        //use the receiptString as a signature to verify the purchase
        //NSString *receiptString = [self encode:(uint8_t *)transaction.transactionReceipt.bytes length:transaction.transactionReceipt.length];
        //[self sendingRequestForReceipt:receiptString];
        /////////////////////////////////////////////////////////////////
        
        
         NSLog(@"song pack purchased: %@ sending notification...", transaction.payment.productIdentifier);
        
        // send out a notification that we’ve finished the transaction
        // should get picked up by ViewController and call notifySongPackPurchase
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionSucceededNotification 
                                                            object:transaction.payment.productIdentifier userInfo:userInfo];
        
    }
    else{
        // send out a notification for the failed transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionFailedNotification object:self userInfo:userInfo];
    }
} 


//
// called when the transaction was successful
//
- (void)completeTransaction:(SKPaymentTransaction *)transaction{
    [self recordTransaction:transaction];
    [self provideContent:transaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
}

//
// called when a transaction has been restored and and successfully completed
//
- (void)restoreTransaction:(SKPaymentTransaction *)transaction{
    [self recordTransaction:transaction.originalTransaction];
    [self provideContent:transaction.originalTransaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
}

//
// called when a transaction has failed
//
- (void)failedTransaction:(SKPaymentTransaction *)transaction{
    if (transaction.error.code != SKErrorPaymentCancelled){
        // error!
        [self finishTransaction:transaction wasSuccessful:NO];
    }
    else{
        // this is fine, the user just cancelled, so don’t notify
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    }
} 



#pragma mark SKPaymentTransactionObserver methods

//
// called when the transaction status is updated
//
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    for (SKPaymentTransaction *transaction in transactions){
        switch (transaction.transactionState){
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
            default:
                break;
        }
    }
} 


//////////////////////////////////
//////////////////////////////////
//////////////////////////////////

/*
 #pragma mark Util methods
 
- (NSString *)encode:(const uint8_t *)input length:(NSInteger)length {
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData *data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t *output = (uint8_t *)data.mutableBytes;
    
    for (NSInteger i = 0; i < length; i += 3) {
        NSInteger value = 0;
        for (NSInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger index = (i / 3) * 4;
        output[index + 0] =                    table[(value >> 18) & 0x3F];
        output[index + 1] =                    table[(value >> 12) & 0x3F];
        output[index + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[index + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
}
*/


//////////////////////////////////
//////////////////////////////////
//////////////////////////////////
// receipt validation -- stubbed out

/*
 - (BOOL)validateReceipt:(NSString *)receipt{
 
 //the production url:
 //  https://buy.itunes.apple.com/verifyReceipt
 
 ASIFormDataRequest *validationRequest = [[ASIFormDataRequest alloc] initWithURL:
 [NSURL URLWithString:
 [NSString stringWithFormat:@"https://sandbox.itunes.apple.com/verifyReceipt"]]];
 
 NSLog(@"Receipt Body: %@", receipt);
 NSString* json = [NSString stringWithFormat:@"{ 'receipt-data' : '%@' }", receipt];
 
 [validationRequest setPostValue:json forKey:@"receipt-data"];
 [validationRequest startSynchronous];  //change this to ASYNC!!!
 
 NSString *resp = [validationRequest responseString];
 
 //NSDictionary* subsInfo = [[validationRequest responseString] JSONValue];
 NSLog(@"Apple Receipt Validation: %@",resp);
 
 return YES;
 }
 
 
 -(void)sendingRequestForReceipt:(NSString *)receiptStr{
 ASINetworkQueue *networkQueue = [ASINetworkQueue queue];
 [networkQueue retain];
 NSString *serverUrl = @"https://sandbox.itunes.apple.com/";
 //NSString *receiptStr= [Base64Encoding base64EncodingForData:(transaction.transactionReceipt) WithLineLength:0];
 
 
 NSString *str = [NSString stringWithFormat:@"%@verifyReceipt", serverUrl];
 NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
 ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:url] autorelease];
 
 //NSDictionary* data = [NSDictionary dictionaryWithObjectsAndKeys:receiptStr,@"receipt-data", nil];
 //[request appendPostData: [[data JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding]];
 NSString* json = [NSString stringWithFormat:@"{ 'receipt-data' : '%@' }", receiptStr];
 [request appendPostData: [json dataUsingEncoding:NSUTF8StringEncoding]];
 [request setRequestMethod:@"POST"];
 [request setDelegate:self];
 [request setDidFinishSelector: @selector(gotReceiptResponse:)];
 
 
 [networkQueue addOperation: request];
 [networkQueue go];
 }
 
 - (void)gotReceiptResponse:(ASIHTTPRequest *)req{
 
 NSString *resultString = [[NSString alloc] initWithData:[req responseData] encoding:NSUTF8StringEncoding];
 //This is a simple validation. It's only checking if there is a '"status":0' string in the resultString.
 
 NSLog(@"Apple Receipt Validation: %@",resultString);
 
 
 }
 */




@end
