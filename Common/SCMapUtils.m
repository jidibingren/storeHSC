//
//  SCMapUtils.m
//  Hongbao
//
//  Created by Pingan Yi on 1/20/15.
//  Copyright (c) 2015 shuchuang. All rights reserved.
//

#import "SCMapUtils.h"

@implementation SCMapUtils

+(BOOL) isValidCoordinate:(CLLocationCoordinate2D)coordinate {
    return !(ABS(coordinate.latitude) < 1e-6 && ABS(coordinate.longitude) < 1e-6);
}

+ (CLLocationCoordinate2D) findValidCoordinateIn:(NSArray *)coordinates {
    for (NSValue* value in coordinates) {
        CLLocationCoordinate2D c = [value coordinateValue];
        if ([self isValidCoordinate:c])
            return c;
    }
    return DEFAULT_LATLNG;
}

@end


@implementation NSValue(SCMapUtils)

+ (NSValue*)valueWithCoordinate:(CLLocationCoordinate2D)coordinate {
    return [NSValue valueWithBytes:&coordinate objCType:@encode(CLLocationCoordinate2D)];
}

- (CLLocationCoordinate2D)coordinateValue {
    CLLocationCoordinate2D c;
    [self getValue:&c];
    return c;
}

@end