//
//  HSCClassGraphicListController.m
//  HSChannel
//
//  Created by SC on 16/8/26.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "HSCClassGraphicListController.h"

@implementation HSCClassGraphicListController

- (instancetype)initWithType:(HSCClassGraphicType)type autoLoad:(BOOL)autoLoad{
    
    if (self = [super init]) {
        
        self.type = type;
        
        
    }
    
    return self;
    
}

@end
