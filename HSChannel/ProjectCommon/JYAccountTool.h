//
//  JYAccountTool.h
//  JJ56
//
//  Created by wangliang on 16/7/4.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYAccount.h"
@interface JYAccountTool : NSObject
/**
 *  存储账号信息
 *
 *  @param account 账号模型
 */
+ (void)saveAccount:(JYAccount *)account;

/**
 *  返回账号信息
 *
 *  @return 账号模型（如果账号过期，返回nil）
 */
+ (JYAccount *)account;
//注销登录，删掉账户
+(void)logoutAccount;
@end
