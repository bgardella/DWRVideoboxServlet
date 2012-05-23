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

static float Y_PHONE_BOTTOM     = 321;
static float Y_PHONE_MIDDLE     = 301;
static float Y_PHONE_TOP        = 281;

static float Y_PAD_BOTTOM       = 770;
static float Y_PAD_MIDDLE       = 740;
static float Y_PAD_TOP          = 709;

static float X_PHONE_CENTER     = 240;
static float X_PAD_CENTER       = 512;

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
        self.center = CGPointMake(X_PHONE_CENTER, Y_PHONE_BOTTOM);
    }else {
        self.center = CGPointMake(X_PAD_CENTER, Y_PAD_BOTTOM);
    }
    
    [UIView commitAnimations];
}

- (void)slideIn{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    if(self.isIPhone){
        self.center = CGPointMake(X_PHONE_CENTER, Y_PHONE_TOP);
    }else {
        self.center = CGPointMake(X_PAD_CENTER, Y_PAD_TOP);
    }
    
    [UIView commitAnimations];
}

- (void)dragMove:(float)yPoint{
    
    if(!self.isIPhone && yPoint<=Y_PAD_BOTTOM && yPoint>=Y_PAD_TOP){
        self.center = CGPointMake(self.center.x, yPoint);
        //NSLog(@"Dragging bar y:%f", yPoint);
    }else if(yPoint<=Y_PHONE_BOTTOM && yPoint>=Y_PHONE_TOP){
        self.center = CGPointMake(self.center.x, yPoint);
        //NSLog(@"Dragging bar y:%f", yPoint);
    }
}

- (void)dragFinished:(float)yPoint{
    //NSLog(@"Drag bar finished y:%f", yPoint);
    
    if(!self.isIPhone){
        if(yPoint>=Y_PAD_MIDDLE){
            self.center = CGPointMake(self.center.x, Y_PAD_BOTTOM);
        }else{
            self.center = CGPointMake(self.center.x, Y_PAD_TOP);
        }
    }else {
        if(yPoint>=Y_PHONE_MIDDLE){
            self.center = CGPointMake(self.center.x, Y_PHONE_BOTTOM);
        }else{
            self.center = CGPointMake(self.center.x, Y_PHONE_TOP);
        }
    }
    
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