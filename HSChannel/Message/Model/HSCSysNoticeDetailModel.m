//
//  HSCSysNoticeDetailModel.m
//  HSChannel
//
//  Created by SC on 16/8/25.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "HSCSysNoticeDetailModel.h"

@implementation HSCSNDRange

@end

@implementation HSCSysNoticeDetailModel

- (void)additionParserConfig:(DCParserConfiguration *)config{
    
    DCArrayMapping *mapper = [DCArrayMapping mapperForClassElements:[HSCSNDRange class] forAttribute:@"rangeAll" onClass:[self class]];
    
    [config addArrayMapper:mapper];
}

@end
