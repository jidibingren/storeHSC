//
//  SCColor.h
//  ShiHua
//
//  Created by yangjian on 14-8-20.
//  Copyright (c) 2014年 shuchuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCColor : NSObject
+ (UIColor *)getColor:(NSString *)hexColor;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
+ (UIImage *)imageWithColor:(UIColor *)color;

@end
