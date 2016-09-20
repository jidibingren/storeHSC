//
//  NSArray+SCUtils.h
//  ShiHua
//
//  Created by Pingan Yi on 9/28/14.
//  Copyright (c) 2014 shuchuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (SCUtils)

- (id) findElementByAssociatedObject: (id)associatedObject;
- (NSUInteger) arrayElementCount;
- (NSArray*) arrayByRemoveObject:(NSObject*)object;
@end
