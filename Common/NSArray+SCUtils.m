//
//  NSArray+SCUtils.m
//  ShiHua
//
//  Created by Pingan Yi on 9/28/14.
//  Copyright (c) 2014 shuchuang. All rights reserved.
//

#import "NSArray+SCUtils.h"

@implementation NSArray (SCUtils)
- (id) findElementByAssociatedObject: (id)associatedObject {
    for (NSObject* o in self) {
        if (o.associatedObject == associatedObject) {
            return o;
        }
    }
    return nil;
}

- (NSUInteger) arrayElementCount {
    return [self count];
}

- (NSArray*) arrayByRemoveObject:(NSObject*)object {
    NSMutableArray* array = [self mutableCopy];
    [array removeObject:object];
    return  array;
}
@end
