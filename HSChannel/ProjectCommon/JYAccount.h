//
//  JYAccount.h
//  JJ56
//
//  Created by wangliang on 16/7/4.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYAccount : NSObject<NSCoding>
@property (nonatomic, copy) NSString *username;//用户名
@property (nonatomic, copy) NSString *password;//密码
@property (nonatomic, copy) NSString *currentLocation;//当前所在位置具体到市
@property (nonatomic, copy) NSString *hxAccount;
@property (nonatomic, copy) NSString *hxPassword;
@property (nonatomic, copy) NSString *token;


@end
