//
//  UINavigationController+SCUtils.m
//  ShiHua
//
//  Created by Pingan Yi on 9/28/14.
//  Copyright (c) 2014 shuchuang. All rights reserved.
//

#import "UINavigationController+SCUtils.h"

@implementation UINavigationController (SCUtils)

-(BOOL) popToViewControllerByClass: (Class)viewControllerClass animated:(BOOL)animated {
    UIViewController* targetViewController = nil;
    for (UIViewController* controller in self.viewControllers) {
        if ([controller isKindOfClass:viewControllerClass]) {
            targetViewController = controller;
        }
    }
    if (targetViewController) {
        [self popToViewController:targetViewController animated:animated];
        return YES;
    }
    return NO;
}

- (void)replaceTopViewControllerWith:(UIViewController *)viewController animated:(BOOL)animated{
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[self viewControllers]];
    UIViewController *parentViewController = viewControllers.lastObject;
    if ([viewControllers containsObject:viewController]) {
        [viewControllers removeObject:viewController];
        self.viewControllers = viewControllers;
    }
    DEFINE_WEAK(self);
    ((SCBaseViewController *)viewController).scNextTimeDidAppearCallback = ^{
        NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[self viewControllers]];
        if (parentViewController != wself.viewControllers[0]) {
            if (parentViewController == wself.viewControllers.lastObject) {
                [parentViewController.navigationController popViewControllerAnimated:YES];
            } else {
                [viewControllers removeObject:parentViewController];
                wself.viewControllers = viewControllers;
            }
        }
    };
    [self pushViewController:viewController animated:animated];
    return;
}

@end
