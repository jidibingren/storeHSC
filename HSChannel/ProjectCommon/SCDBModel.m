//
//  SCDBModel.m
//  HSChannel
//
//  Created by SC on 16/8/24.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "SCDBModel.h"

@interface SCDBModel () {
#ifdef SC_TP_KEYVALUE_MAPPING
    DCKeyValueObjectMapping* _dicParser;
#endif
}
@end

@implementation SCDBModel

- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self updateWithDictionary:dic];
    }
    return self;
}

- (void) updateWithDictionary: (NSDictionary*)dic
{
#ifdef SC_TP_KEYVALUE_MAPPING
    if (!_dicParser) {
        _dicParser = [DCKeyValueObjectMapping mapperForClass:self.class];
    }
    [_dicParser updateObject:self withDictionary:dic];
#endif
}

@end
