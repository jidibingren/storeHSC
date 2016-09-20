//
//  HSCMineLeaveRecordCell.m
//  HSChannel
//
//  Created by SC on 16/9/4.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "HSCMineLeaveRecordCell.h"

@implementation HSCMineLRItemView

- (instancetype)init{
    
    if (self = [super init]) {
        [self setupSubViews];
    }
    
    return self;
}

- (void)setupSubViews{
    
    UIView *tempView = self;
    
    CGFloat leftMargin = 10;
    CGFloat rightMargin = -10;
    
    _seperatorLine = [UIView new];
    _seperatorLine.backgroundColor = [SCColor getColor:SC_COLOR_SEPARATOR_LINE];
    [tempView addSubview:_seperatorLine];
    [_seperatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tempView);
        make.left.mas_equalTo(tempView).offset(leftMargin);
        make.right.mas_equalTo(tempView).offset(rightMargin);
        make.height.mas_equalTo(0.5);
    }];
    
    _titleLabel = [UILabel new];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.font = [Utils fontWithSize:SC_FONT_3];
    _titleLabel.textColor = [SCColor getColor:SC_COLOR_TEXT_4];
    [tempView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_seperatorLine.mas_bottom).offset(0);
        make.left.mas_equalTo(tempView).offset(leftMargin);
        make.width.mas_equalTo(80);
        make.bottom.mas_equalTo(tempView);
    }];
    
    _contentLabel = [UILabel new];
    _contentLabel.textAlignment = NSTextAlignmentRight;
    _contentLabel.font = [Utils fontWithSize:SC_FONT_3];
    _contentLabel.textColor = [SCColor getColor:SC_COLOR_TEXT_2];
    [tempView addSubview:_contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLabel).offset(0);
        make.right.mas_equalTo(tempView).offset(rightMargin);
        make.left.mas_equalTo(_titleLabel.mas_right);
        make.bottom.mas_equalTo(_titleLabel);
    }];
    
}

@end

@implementation HSCMineLeaveRecordCell

- (void)setupSubviewsWithFrame:(CGRect)frame{
    
    CGFloat leftMargin  = 15;
    CGFloat rightMargin = -15;
    
    CGRect tempFrame = frame;
    
    tempFrame.origin = CGPointZero;
    
    tempFrame.size.width = ScreenWidth;
    
    self.contentView.backgroundColor = [SCColor getColor:@"f2f2f2"];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    DEFINE_WEAK(self);
    
    __weak UIView *tempView = self.contentView;
    
    UIView *borderView = [UIView new];
    borderView.backgroundColor = [SCColor getColor:@"ffffff"];
    borderView.layer.cornerRadius = 10;
    [tempView addSubview:borderView];
    [borderView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(tempView).offset(10);
        make.left.mas_equalTo(tempView).offset(leftMargin);
        make.right.mas_equalTo(tempView).offset(rightMargin);
        make.height.mas_equalTo(225);
    }];
    
    tempView = borderView;
    
    _statusLabel = [UILabel new];
    _statusLabel.textAlignment = NSTextAlignmentCenter;
    _statusLabel.font = [Utils fontWithSize:SC_FONT_3];
    _statusLabel.textColor = [SCColor getColor:@"2aaa4d"];
    _statusLabel.layer.cornerRadius = 2;
    _statusLabel.layer.masksToBounds = YES;
    _statusLabel.layer.borderWidth = 0.5;
    [tempView addSubview:_statusLabel];
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tempView).offset(10);
        make.right.mas_equalTo(tempView).offset(rightMargin);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(25);
    }];
    
    
    UIView *markView = [UIView new];
    markView.backgroundColor = [SCColor getColor:@"2aaa4d"];
    [tempView addSubview:markView];
    [markView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(tempView).offset(15);
        make.left.mas_equalTo(tempView).offset(10);
        make.width.mas_equalTo(5);
        make.height.mas_equalTo(15);
    }];
    
    _timeLabel = [UILabel new];
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    _timeLabel.font = [Utils fontWithSize:SC_FONT_3];
    _timeLabel.textColor = [SCColor getColor:SC_COLOR_TEXT_2];
    [tempView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tempView).offset(0);
        make.right.mas_equalTo(_statusLabel.mas_left).offset(rightMargin);
        make.left.mas_equalTo(markView.mas_right).offset(10);
        make.height.mas_equalTo(45);
    }];
    
    
    _childView = [HSCMineLRItemView new];
    _childView.titleLabel.text = @"孩子姓名";
    [_childView.seperatorLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_childView);
        make.right.mas_equalTo(_childView);
    }];
    [tempView addSubview:_childView];
    [_childView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_timeLabel.mas_bottom);
        make.right.mas_equalTo(tempView);
        make.left.mas_equalTo(tempView);
        make.height.mas_equalTo(45);
    }];
    
    _reasonView = [HSCMineLRItemView new];
    _reasonView.titleLabel.text = @"事由";
    [tempView addSubview:_reasonView];
    [_reasonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_childView.mas_bottom);
        make.right.mas_equalTo(tempView);
        make.left.mas_equalTo(tempView);
        make.height.mas_equalTo(45);
    }];
    
    _timeView = [HSCMineLRItemView new];
    _timeView.titleLabel.text = @"时间";
    [tempView addSubview:_timeView];
    [_timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_reasonView.mas_bottom);
        make.right.mas_equalTo(tempView);
        make.left.mas_equalTo(tempView);
        make.height.mas_equalTo(45);
    }];
    
    _teacherView = [HSCMineLRItemView new];
    _teacherView.titleLabel.text = @"请假老师";
    [tempView addSubview:_teacherView];
    [_teacherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_timeView.mas_bottom);
        make.right.mas_equalTo(tempView);
        make.left.mas_equalTo(tempView);
        make.height.mas_equalTo(45);
    }];
    
}

- (void)setData:(HSCMineLeaveRecordModel *)data indexPath:(NSIndexPath*)indexPath{
    
    if (![data isKindOfClass:[HSCMineLeaveRecordModel class]]) {
        return;
    }
    
    
    _timeLabel.text = [Utils getDateToDayFromSeconds:data.createTim];
    
    if ([data.feedback isEqualToString:@"同意"]) {
        _statusLabel.text = @"同意";
        _statusLabel.textColor = [SCColor getColor:@"2aaa4d"];
        _statusLabel.layer.borderColor = [SCColor getColor:@"2aaa4d"].CGColor;
    }else  {
        
        _statusLabel.text = @"未反馈";
        _statusLabel.textColor = [SCColor getColor:@"ff8787"];
        _statusLabel.layer.borderColor = [SCColor getColor:@"ff8787"].CGColor;
    }
    
    _childView.contentLabel.text = data.stuName;
    
    _reasonView.contentLabel.text = data.reason;
    
    _timeView.contentLabel.text = [Utils getCustomDateToDayFromSeconds:data.createTim];
    
    _teacherView.contentLabel.text = data.teacherName;
    
}

@end

