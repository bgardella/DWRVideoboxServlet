//
//  KaraokeView.h
//  SyncedVideo
//
//  Created by Ben Gardella on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KaraokeView : UIView{
    
@private
    UILabel *karaokeText;
    BOOL isIPhone;
}

@property (nonatomic, retain) IBOutlet UILabel *karaokeText;
@property (nonatomic, assign) BOOL isIPhone;

- (void)setText:(NSString *)text;
- (void)hide;
- (void)show;
- (void)slideOut;
- (void)slideIn;
- (void)dragMove:(float)yPoint;
- (void)dragFinished:(float)yPoint;


@end
