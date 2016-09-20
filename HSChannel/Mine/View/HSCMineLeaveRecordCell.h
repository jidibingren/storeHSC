//
//  HSCMineLeaveRecordCell.h
//  HSChannel
//
//  Created by SC on 16/9/4.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "SCTableViewController.h"
#import "HSCMineLeaveRecordModel.h"


@interface HSCMineLRItemView : UIView

@property (nonatomic, strong)UIView      *seperatorLine;
@property (nonatomic, strong)UILabel     *titleLabel;
@property (nonatomic, strong)UILabel     *contentLabel;

@end

@interface HSCMineLeaveRecordCell : SCTableViewCell

@property (nonatomic, strong)UILabel     *timeLabel;
@property (nonatomic, strong)UILabel     *statusLabel;
@property (nonatomic, strong)HSCMineLRItemView     *childView;
@property (nonatomic, strong)HSCMineLRItemView     *reasonView;
@property (nonatomic, strong)HSCMineLRItemView     *timeView;
@property (nonatomic, strong)HSCMineLRItemView     *teacherView;

@end

