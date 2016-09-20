//
//  JYRootVCSelectionTool.h
//  StudentBusiness
//
//  Created by wangliang on 16/4/5.
//  Copyright © 2016年 com.jinyouapp. All rights reserved.
//

#import <Foundation/Foundation.h>

//#import "JYAccountTool.h"

@interface JYRootVCSelectionTool : NSObject
/**
 *   根据是否授权设置根控制器
 */
+ (void)setRootViewControllerForWindow:(UIWindow *)window;

@end
