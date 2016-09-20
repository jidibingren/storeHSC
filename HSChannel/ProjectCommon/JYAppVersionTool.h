//
//  JYAppVersionTool.h
//  StudentBusiness
//
//  Created by wangliang on 16/4/5.
//  Copyright © 2016年 com.jinyouapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYAppVersionTool : NSObject
/**
 *  之前保存的版本
 *
 *  @return NSString类型的AppVersion
 */
+ (NSString *)savedAppVersion;
/**
 *  保存新版本
 */
+ (void)saveNewAppVersion:(NSString *)version;
@end
