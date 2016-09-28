//
//  HSCAttendanceRecordCell.m
//  HSChannel
//
//  Created by SC on 16/9/4.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "HSCAttendanceRecordCell.h"

@implementation HSCARItemView

- (instancetype)init{

    if (self = [super init]) {
        [self setupSubViews];
    }
 
    return self;
}

- (void)setupSubViews{
    
    UIView *tempView = self;
    
    CGFloat leftMargin = 15;
    CGFloat rightMargin = -15;
    
    _seperatorLine = [UIView new];
    _seperatorLine.backgroundColor = [SCColor getColor:SC_COLOR_SEPARATOR_LINE];
    [tempView addSubview:_seperatorLine];
    [_seperatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tempView);
        make.left.mas_equalTo(tempView).offset(leftMargin);
        make.right.mas_equalTo(tempView);
        make.height.mas_equalTo(0.5);
    }];
    
    _checkBtn = [UIButton new];
    [_checkBtn setBackgroundImage:[UIImage sc_imageNamed:KSCImageAttendanceRecordCellUncheck] forState:UIControlStateNormal];
    [_checkBtn setBackgroundImage:[UIImage sc_imageNamed:KSCImageAttendanceRecordCellCheck] forState:UIControlStateSelected];
    [tempView addSubview:_checkBtn];
    [_checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tempView);
        make.right.mas_equalTo(tempView).offset(rightMargin);
        make.width.mas_equalTo(18);
        make.height.mas_equalTo(18);
    }];
    
    _titleLabel = [UILabel new];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.font = [Utils fontWithSize:15];
    _titleLabel.textColor = [SCColor getColor:SC_COLOR_TEXT_3];
    [tempView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_seperatorLine.mas_bottom).offset(0);
        make.left.mas_equalTo(tempView).offset(leftMargin);
        make.right.mas_equalTo(_checkBtn.mas_left);
        make.bottom.mas_equalTo(tempView.mas_centerY);
    }];
    
    _timeLabel = [UILabel new];
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    _timeLabel.font = [Utils fontWithSize:12];
    _timeLabel.textColor = [SCColor getColor:SC_COLOR_TEXT_4];
    [tempView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(0);
        make.right.mas_equalTo(_titleLabel);
        make.left.mas_equalTo(_titleLabel);
        make.bottom.mas_equalTo(tempView);
    }];
    
}

@end

@implementation HSCAttendanceRecordCell
- (void)setupSubviewsWithFrame:(CGRect)frame{
    
    CGFloat leftMargin  = 15;
    CGFloat rightMargin = -15;
    
    CGRect tempFrame = frame;
    
    tempFrame.origin = CGPointZero;
    
    tempFrame.size.width = ScreenWidth;
    
    self.contentView.backgroundColor = [SCColor getColor:@"ffffff"];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    DEFINE_WEAK(self);
    
    __weak UIView *tempView = self.contentView;
    
    UIView *headView = [UIView new];
    headView.backgroundColor = [SCColor getColor:@"f4f4f4"];
    [tempView addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(tempView);
        make.left.mas_equalTo(tempView);
        make.right.mas_equalTo(tempView);
        make.height.mas_equalTo(10);
    }];
    
    _nameLabel = [UILabel new];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.font = [Utils fontWithSize:SC_FONT_2];
    _nameLabel.textColor = [SCColor getColor:@"2aaa4d"];
    [tempView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headView.mas_bottom).offset(0);
        make.left.mas_equalTo(tempView).offset(leftMargin);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(45);
    }];
    
    _timeLabel = [UILabel new];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.font = [Utils fontWithSize:SC_FONT_3];
    _timeLabel.textColor = [SCColor getColor:@"2aaa4d"];
    [tempView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_nameLabel).offset(0);
        make.right.mas_equalTo(tempView).offset(rightMargin);
        make.left.mas_equalTo(_nameLabel.mas_right);
        make.height.mas_equalTo(45);
    }];
    
    
    _morCheckView = [HSCARItemView new];
    _morCheckView.titleLabel.text = @"上午";
    [_morCheckView.seperatorLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_morCheckView);
    }];
    [tempView addSubview:_morCheckView];
    [_morCheckView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_nameLabel.mas_bottom);
        make.right.mas_equalTo(tempView);
        make.left.mas_equalTo(tempView);
        make.height.mas_equalTo(45);
    }];
    
    _noonCheckView = [HSCARItemView new];
    _noonCheckView.titleLabel.text = @"中午";
    [tempView addSubview:_noonCheckView];
    [_noonCheckView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_morCheckView.mas_bottom);
        make.right.mas_equalTo(tempView);
        make.left.mas_equalTo(tempView);
        make.height.mas_equalTo(45);
    }];
    
    _afterCheckView = [HSCARItemView new];
    _afterCheckView.titleLabel.text = @"下午";
    [tempView addSubview:_afterCheckView];
    [_afterCheckView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_noonCheckView.mas_bottom);
        make.right.mas_equalTo(tempView);
        make.left.mas_equalTo(tempView);
        make.height.mas_equalTo(45);
    }];
    
}

- (void)setData:(HSCAttendanceRecordModel *)data indexPath:(NSIndexPath*)indexPath{
    
    if (![data isKindOfClass:[HSCAttendanceRecordModel class]]) {
        return;
    }
    
    self.cellData = data;
    
    
    _nameLabel.text = [SCUserInfo sharedInstance].selectedChildren.name;
    
    _timeLabel.text = [Utils getDateToDayFromSeconds:data.checkDate];
    
    if (data.morCheckStatus) {
        
        _morCheckView.timeLabel.text = [NSString stringWithFormat:@"刷卡时间:%@",[Utils getDateToHoureMinutesFromSeconds:data.morCheckTime]];
        [_morCheckView.checkBtn setSelected:YES];
    }else{
        
        _morCheckView.timeLabel.text = @"刷卡时间:无考勤";
        [_morCheckView.checkBtn setSelected:NO];
    }
    
    if (data.noonCheckStatus) {
        
        _noonCheckView.timeLabel.text = [NSString stringWithFormat:@"刷卡时间:%@",[Utils getDateToHoureMinutesFromSeconds:data.noonCheckTime]];
        [_noonCheckView.checkBtn setSelected:YES];
    }else{
        
        _noonCheckView.timeLabel.text = @"刷卡时间:无考勤";
        [_noonCheckView.checkBtn setSelected:NO];
    }
    
    
    if (data.afterCheckStatus) {
        
        _afterCheckView.timeLabel.text = [NSString stringWithFormat:@"刷卡时间:%@",[Utils getDateToHoureMinutesFromSeconds:data.afterCheckTime]];
        [_afterCheckView.checkBtn setSelected:YES];
        
    }else{
        
        _afterCheckView.timeLabel.text = @"刷卡时间:无考勤";
        [_afterCheckView.checkBtn setSelected:NO];
    }
    
}

@end
