//
//  JYAccount.m
//  JJ56
//
//  Created by wangliang on 16/7/4.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "JYAccount.h"

@implementation JYAccount
/**
 *  当一个对象要归档进沙盒中时，就会调用这个方法
 *  目的：在这个方法中说明这个对象的哪些属性要存进沙盒
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.username forKey:@"username"];
    [encoder encodeObject:self.password forKey:@"password"];
    [encoder encodeObject:self.currentLocation forKey:@"currentLocation"];
    [encoder encodeObject:self.hxAccount forKey:@"hxAccount"];
    [encoder encodeObject:self.hxPassword forKey:@"hxPassword"];
    [encoder encodeObject:self.token forKey:@"token"];
}

/**
 *  当从沙盒中解档一个对象时（从沙盒中加载一个对象时），就会调用这个方法
 *  目的：在这个方法中说明沙盒中的属性该怎么解析（需要取出哪些属性）
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.username = [decoder decodeObjectForKey:@"username"];
        self.password = [decoder decodeObjectForKey:@"password"];
        self.currentLocation = [decoder decodeObjectForKey:@"currentLocation"];
        self.hxAccount = [decoder decodeObjectForKey:@"hxAccount"];
        self.hxPassword = [decoder decodeObjectForKey:@"hxPassword"];
        self.token = [decoder decodeObjectForKey:@"token"];
    }
    return self;
}
@end
