//
//  HSCSysNoticeDetailController.h
//  HSChannel
//
//  Created by SC on 16/8/25.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "SCTableViewController.h"
#import "HSCSysNoticeDetailModel.h"
#import "HSCSNDRangeCell.h"

@interface HSCSysNoticeDetailController : SCTableViewController

@property (nonatomic, strong)HSCMessageModel *messageModel;

- (instancetype)initWithNoticeId:(HSCMessageModel *)messageModel;

@end
