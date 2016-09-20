//
//  HSCClassPublishController.h
//  HSChannel
//
//  Created by SC on 16/9/3.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "SCNormalTableViewController.h"
#import "HSCImageSlecteCell.h"
#import "HSCContactSelectController.h"

typedef NS_ENUM(NSInteger, HSCClassPublishType) {
    HSCClassPublishNotice = 0,
    HSCClassPublishDynamic,
    HSCClassPublishWork
};

@interface HSCClassPublishController : SCNormalTableViewController

@property (nonatomic, assign)HSCClassPublishType type;

- (instancetype)initWithType:(HSCClassPublishType)type;

@end
