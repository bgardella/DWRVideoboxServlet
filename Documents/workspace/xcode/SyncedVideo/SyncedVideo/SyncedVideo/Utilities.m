//
//  Utilities.m
//  SyncedVideo
//
//  Created by Ben Gardella on 6/24/12.
//  Copyright (c) 2012 Sophie World LLC. All rights reserved.
//
//  Static Utility Methods
//
//

#import "Utilities.h"

@implementation Utilities

+ (NSString *)documentFilePath{
    NSArray *dirArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [dirArray objectAtIndex:0];
}

+ (NSArray *)manifestFilePaths{
    NSFileManager *filemgr;
    filemgr = [NSFileManager defaultManager];
    
    NSArray *docList = [filemgr contentsOfDirectoryAtPath:[Utilities documentFilePath] error:nil];
    
    NSUInteger counter = 0;
    NSMutableArray *manifestArr = [[NSMutableArray alloc] initWithCapacity:5];
    for(int i = 0; i < docList.count; i++){
        NSString *filePath = [docList objectAtIndex: i];
        if([filePath hasSuffix:@"manifest"]){
            [manifestArr insertObject:[NSString stringWithFormat:@"%@/%@", [Utilities documentFilePath],filePath]            
                              atIndex:counter];
            counter++;
        }
    }
    [filemgr release];
    
    return manifestArr;
}


+ (void)printDirectory:(NSString*)dirPath{
    NSLog(@"**************************************");
    NSFileManager *manager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *direnum = [manager enumeratorAtPath:dirPath];
    NSString *filename;
    NSError *attributesError = nil;
    while ((filename = [direnum nextObject] )) {
        NSString *fullPath = [dirPath stringByAppendingPathComponent:filename];
        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:fullPath error:&attributesError];
        NSNumber *fileSizeNumber = [fileAttributes objectForKey:NSFileSize];
        long long fileSize = [fileSizeNumber longLongValue];
        
        NSLog(@"%@ : %llx",fullPath, fileSize);
    }
    NSLog(@"**************************************");
}



@end
