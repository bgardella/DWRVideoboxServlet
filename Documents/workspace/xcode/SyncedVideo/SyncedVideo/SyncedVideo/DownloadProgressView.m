//
//  DownloadProgressView.m
//  SyncedVideo
//
//  Created by Ben Gardella on 6/21/12.
//  Copyright (c) 2012 Sophie World LLC. All rights reserved.
//

#import "DownloadProgressView.h"

@implementation DownloadProgressView

- (void)setProgress:(float)newProgress{
    
    NSLog(@"dl progress: %f", newProgress);
    [super setProgress:newProgress];
}

- (void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes{
    
    NSLog(@"dl received bytes...");
}

- (void)request:(ASIHTTPRequest *)request incrementDownloadSizeBy:(long long)newLength{
    
    NSLog(@"increment dl size...");
}

@end
