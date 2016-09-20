//
//  NSDictionary+SCUtils.h
//  ShiHua
//
//  Created by Pingan Yi on 11/7/14.
//  Copyright (c) 2014 shuchuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (SCUtils)

// 从NSDictionary中取出 int或者float value的安全的方法（不会崩溃）
- (int) sc_intForKeyPath:(NSString*)key defaultValue:(int)defaultValue;
- (float) sc_floatForKeyPath:(NSString*)key defaultValue:(float)defaultValue;

// 等同于上面的方法，默认值是0
- (int) sc_intForKeyPath:(NSString*)key;
- (float) sc_floatForKeyPath:(NSString*)key;

// 从NSDictionary中取出 string value的安全的方法（不会崩溃), 如果key存在且value不是[NSNull null],
// 返回[value description], 否则返回@""
- (NSString*) sc_stringForKeyPath:(NSString*)key;
@end
