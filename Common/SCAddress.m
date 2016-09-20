//
//  SCAddress.m
//  FindAFitting
//
//  Created by SC on 16/5/8.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "SCAddress.h"

@implementation SCAddress

- (CLLocationCoordinate2D)pt{
    
    if (CLLocationCoordinate2DIsValid(_pt) && (_pt.latitude || _pt.longitude)) {

        return _pt;
        
    }
    
    return CLLocationCoordinate2DMake(_lat.floatValue, _lng.floatValue);
}

@end
