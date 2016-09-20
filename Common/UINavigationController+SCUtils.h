//
//  UINavigationController+SCUtils.h
//  ShiHua
//
//  Created by Pingan Yi on 9/28/14.
//  Copyright (c) 2014 shuchuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (SCUtils)
// 返回到某个ViewControler,它的class是viewControllerClass
-(BOOL) popToViewControllerByClass: (Class)viewControllerClass animated:(BOOL)animated;
- (void)replaceTopViewControllerWith:(UIViewController *)viewController animated:(BOOL)animated;
@end
