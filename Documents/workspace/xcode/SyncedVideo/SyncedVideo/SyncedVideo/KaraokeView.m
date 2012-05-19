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
@synthesize isIPhone;

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

- (void)slideOut{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    NSLog(@"kview center.x:%f center.y:%f", self.center.x, self.center.y);
    
    if(self.isIPhone){
        self.center = CGPointMake(240, 321);
    }else {
        self.center = CGPointMake(512, 800);
    }
    
    [UIView commitAnimations];
}

- (void)slideIn{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    if(self.isIPhone){
        self.center = CGPointMake(240, 281);
    }else {
        self.center = CGPointMake(512, 709);
    }
    
    [UIView commitAnimations];
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


- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if(self = [super initWithCoder:aDecoder]){
        if (self) {
            // Initialization code
            self.isIPhone = UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad;
        }
    }
    return self;
}

@end
