//
//  HSCAttendanceRecordCell.h
//  HSChannel
//
//  Created by SC on 16/9/4.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "SCTableViewController.h"
#import "HSCAttendanceRecordModel.h"

@interface HSCARItemView : UIView

@property (nonatomic, strong)UIView      *seperatorLine;
@property (nonatomic, strong)UILabel     *titleLabel;
@property (nonatomic, strong)UILabel     *timeLabel;
@property (nonatomic, strong)UIButton    *checkBtn;

@end

@interface HSCAttendanceRecordCell : SCTableViewCell

@property (nonatomic, strong)UILabel     *nameLabel;
@property (nonatomic, strong)UILabel     *timeLabel;
@property (nonatomic, strong)HSCARItemView     *morCheckView;
@property (nonatomic, strong)HSCARItemView     *noonCheckView;
@property (nonatomic, strong)HSCARItemView     *afterCheckView;
@property (nonatomic, strong)HSCAttendanceRecordModel *cellData;

@end
