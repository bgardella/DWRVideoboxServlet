//
//  gardellaModelController.h
//  ScrollViewTestMe
//
//  Created by Ben Gardella on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class gardellaDataViewController;

@interface gardellaModelController : NSObject <UIPageViewControllerDataSource>

- (gardellaDataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(gardellaDataViewController *)viewController;

@end
