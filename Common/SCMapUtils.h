//
//  SCMapUtils.h
//  Hongbao
//
//  Created by Pingan Yi on 1/20/15.
//  Copyright (c) 2015 shuchuang. All rights reserved.
//

#import <Foundation/Foundation.h>

//北京天安门，没有位置时在地图上默认显示这个点
#define DEFAULT_LATLNG CLLocationCoordinate2DMake(39.912725, 116.404008)

@interface SCMapUtils : NSObject

+ (BOOL) isValidCoordinate:(CLLocationCoordinate2D)coordinate;
// 在coordinates中顺序查找一个vaild coordinate,　找到就返回,找不到则返回DEFAULT_LATLNG
+ (CLLocationCoordinate2D) findValidCoordinateIn:(NSArray*)coordinates;

@end

@interface NSValue(SCMapUtils)

+ (NSValue*) valueWithCoordinate:(CLLocationCoordinate2D)coordinate;
- (CLLocationCoordinate2D) coordinateValue;
@end
