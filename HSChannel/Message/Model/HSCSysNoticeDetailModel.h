//
//  HSCSysNoticeDetailModel.h
//  HSChannel
//
//  Created by SC on 16/8/25.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "SCTableViewController.h"

@interface HSCSNDRange : SCTableViewCellData

@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *username;
@property (nonatomic, strong)NSString *userImage;
@property (nonatomic, assign)NSInteger isRead;
@property (nonatomic, assign)long long updateTime;

@end

@interface HSCSysNoticeDetailModel : SCTableViewCellData

@property (nonatomic, strong)NSString *id;
@property (nonatomic, strong)NSString *noticeId;
@property (nonatomic, strong)NSString *range;
@property (nonatomic, strong)NSArray<HSCSNDRange*>  *rangeAll;

@end
