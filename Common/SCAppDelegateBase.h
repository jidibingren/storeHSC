//
//  SCAppDelegateBase.h
//  ShiHua
//
//  Created by yangjian on 14-9-5.
//  Copyright (c) 2014年 shuchuang. All rights reserved.
//

#import <Foundation/Foundation.h>

// 每个项目的AppDelegate应该继承自这个类
@interface SCAppDelegateBase : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@end
