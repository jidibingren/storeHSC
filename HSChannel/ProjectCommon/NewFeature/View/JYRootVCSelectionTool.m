//
//  JYRootVCSelectionTool.m
//  StudentBusiness
//
//  Created by wangliang on 16/4/5.
//  Copyright © 2016年 com.jinyouapp. All rights reserved.
//

#import "JYRootVCSelectionTool.h"

@implementation JYRootVCSelectionTool
+ (void)setRootViewControllerForWindow:(UIWindow *)window {

    DEFINE_WEAK(self);
    [SCRootViewController setRootControllerByType:SCRootControllerDefault];
//    if ([Utils isNonnull:[[SCCache sharedInstance] cachedObjectForKey:@"SCRootControllerType"]]) {
//        
//        SCRootControllerType type = [[[SCCache sharedInstance] cachedObjectForKey:@"SCRootControllerType"] integerValue];
//        [SCRootViewController setRootControllerByType:type];
//    }
    [window makeKeyAndVisible];
}
@end
