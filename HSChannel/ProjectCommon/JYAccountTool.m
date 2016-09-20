//
//  JYAccountTool.m
//  JJ56
//
//  Created by wangliang on 16/7/4.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "JYAccountTool.h"
#import "MBProgressHUD+MJ.h"
// 账号的存储路径
#define JYAccountPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"jj5688_account.archive"]
@implementation JYAccountTool
//保存账户
+(void)saveAccount:(JYAccount *)account
{
    [NSKeyedArchiver archiveRootObject:account toFile:JYAccountPath];
    
}

//返回账户
+(JYAccount *)account
{
    // 加载模型
    JYAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:JYAccountPath];
    return account;
}
//销毁账户
+(void)logoutAccount
{
    NSFileManager *fileManeger=[NSFileManager defaultManager];
    if ([fileManeger isDeletableFileAtPath:JYAccountPath]) {
        [fileManeger removeItemAtPath:JYAccountPath error:nil];
        [MBProgressHUD showSuccess:@"注销成功"];
    }
    
}
@end
