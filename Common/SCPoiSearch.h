//
//  SCPoiSearch.h
//  FindAFitting
//
//  Created by SC on 16/5/10.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCAddress.h"

typedef void (^SCPoiSearchBlock)(BOOL isSuccessed, NSMutableArray *addressArray, id additionalInfo);

@interface SCPoiSearchUtil : NSObject

DECLARE_SINGLETON()

- (void)nearbySearchByKeyword:(NSString *)keyword location:(CLLocationCoordinate2D) location callback:(SCPoiSearchBlock)callback;

- (void)nearbySearchByKeyword:(NSString *)keyword location:(CLLocationCoordinate2D) location additionalInfo:(id)additionalInfo callback:(SCPoiSearchBlock)callback;

- (void)nearbySearchByKeyword:(NSString *)keyword location:(CLLocationCoordinate2D) location radius:(NSInteger)radius additionalInfo:(id)additionalInfo callback:(SCPoiSearchBlock)callback;


@end
