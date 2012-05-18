//
//  KaraokeView.m
//  SyncedVideo
//
//  Created by Ben Gardella on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KaraokeView.h"

@implementation KaraokeView

@synthesize karaokeText;

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */


- (void)setText:(NSString *)text{
    [karaokeText setText:text];
}

- (void)hide{
    if(self.alpha == 1.0){
        self.alpha = 1.0;
        [UIView beginAnimations:@"Fade-in" context:NULL];
        [UIView setAnimationDuration:1.0];
        self.alpha = 0.0;
        [UIView commitAnimations];
    }   
}

- (void)show{
    if(self.alpha == 0.0){
        self.alpha = 0.0;
        [UIView beginAnimations:@"Fade-in" context:NULL];
        [UIView setAnimationDuration:0.6];
        self.alpha = 1.0;
        [UIView commitAnimations];
    }
}





/////////////////////////
/////////////////////////
/////////////////////////


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

@end
