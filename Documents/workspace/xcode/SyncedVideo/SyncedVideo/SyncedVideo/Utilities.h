//
//  Utilities.h
//  SyncedVideo
//
//  Created by Ben Gardella on 6/24/12.
//  Copyright (c) 2012 Sophie World LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject

+ (NSString *)documentFilePath;
+ (NSArray *)manifestFilePaths;
+ (void)printDirectory:(NSString*)dirPath;


@end
