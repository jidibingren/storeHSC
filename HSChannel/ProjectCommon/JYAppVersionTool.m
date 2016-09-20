//
//  JYAppVersionTool.m
//  StudentBusiness
//
//  Created by wangliang on 16/4/5.
//  Copyright © 2016年 com.jinyouapp. All rights reserved.
//

#import "JYAppVersionTool.h"
#define JYVersionKey @"AppVersion"
@implementation JYAppVersionTool
// 获取保存的上一个版本信息
+ (NSString *)savedAppVersion {
    
    return [[NSUserDefaults standardUserDefaults] stringForKey:JYVersionKey];
}

// 保存新版本信息（偏好设置）
+ (void)saveNewAppVersion:(NSString *)version {
    
    [[NSUserDefaults standardUserDefaults] setObject:version forKey:JYVersionKey];
}

@end
