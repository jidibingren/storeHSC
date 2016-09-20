//
//  NSDictionary+SCUtils.m
//  ShiHua
//
//  Created by Pingan Yi on 11/7/14.
//  Copyright (c) 2014 shuchuang. All rights reserved.
//

#import "NSDictionary+SCUtils.h"

@implementation NSDictionary (SCUtils)

- (int) sc_intForKeyPath:(NSString*)key defaultValue:(int)defaultValue {
    id value = [self valueForKeyPath:key];
    if (value && [value respondsToSelector:@selector(intValue)]) {
        return [value intValue];
    }
    return defaultValue;
}

- (float) sc_floatForKeyPath:(NSString*)key defaultValue:(float)defaultValue {
    id value = [self valueForKeyPath:key];
    if (value && [value respondsToSelector:@selector(floatValue)]) {
        return [value floatValue];
    }
    return defaultValue;
}

- (int) sc_intForKeyPath:(NSString*)key {
    return [self sc_intForKeyPath:key defaultValue:0];
}
- (float) sc_floatForKeyPath:(NSString*)key {
    return [self sc_floatForKeyPath:key defaultValue:0.0f];
}

- (NSString*) sc_stringForKeyPath:(NSString*)key {
    id value = [self valueForKeyPath:key];
    if (value && ![value isKindOfClass:[NSNull class]]) {
        return [[self valueForKeyPath:key] description];
    }
    return @"";
}
@end
