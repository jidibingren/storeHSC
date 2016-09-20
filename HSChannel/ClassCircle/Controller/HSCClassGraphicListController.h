//
//  HSCClassGraphicListController.h
//  HSChannel
//
//  Created by SC on 16/8/26.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "SCBaseViewController.h"

typedef NS_ENUM(NSInteger,HSCClassGraphicType){
    HSCClassGraphicNotice = 0,
    HSCClassGraphicDynamic,
    HSCClassGraphicWork,
};

@interface HSCClassGraphicListController : SCBaseViewController

@property (nonatomic, assign)HSCClassGraphicType type;

- (instancetype)initWithType:(HSCClassGraphicType)type autoLoad:(BOOL)autoLoad;

@end
