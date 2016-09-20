//
//  SCDBModel.h
//  HSChannel
//
//  Created by SC on 16/8/24.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import <JDModel/JDModel.h>

@interface SCDBModel : JDModel

- (id)initWithDictionary:(NSDictionary *)dic;

- (void) updateWithDictionary: (NSDictionary*)dic;

@end
