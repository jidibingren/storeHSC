//
//  HSCSysMessageCell.m
//  HSChannel
//
//  Created by SC on 16/8/25.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "HSCSysMessageCell.h"

@implementation HSCSysMessageCell

- (void)setupSubviewsWithFrame:(CGRect)frame{
    
    CGFloat leftMargin  = 10;
    CGFloat rightMargin = -10;
    
    CGRect tempFrame = frame;
    
    tempFrame.origin = CGPointZero;
    
    tempFrame.size.width = ScreenWidth;
    
    self.contentView.backgroundColor = [SCColor getColor:@"ffffff"];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    DEFINE_WEAK(self);
    
    __weak UIView *tempView = self.contentView;
    
    
    _titleLabel = [UILabel new];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.font = [Utils fontWithSize:SC_FONT_3];
    _titleLabel.textColor = [SCColor getColor:SC_COLOR_TEXT_2];
    [tempView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tempView).offset(10);
        make.left.mas_equalTo(tempView).offset(SC_MARGIN_LEFT);
        make.right.mas_equalTo(tempView).offset(SC_MARGIN_RIGHT);
        make.height.mas_equalTo(20);
    }];
    
    _nameLabel = [UILabel new];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.font = [Utils fontWithSize:SC_FONT_4];
    _nameLabel.textColor = [SCColor getColor:SC_COLOR_TEXT_3];
    [tempView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLabel.mas_bottom);
        make.left.mas_equalTo(_titleLabel);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
    }];
    
    _timeLabel = [UILabel new];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.font = [Utils fontWithSize:SC_FONT_4];
    _timeLabel.textColor = [SCColor getColor:SC_COLOR_TEXT_3];
    [tempView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_nameLabel).offset(0);
        make.right.mas_equalTo(_titleLabel);
        make.left.mas_equalTo(_nameLabel.mas_right);
        make.height.mas_equalTo(20);
    }];
    
    
    
    _contentLabel = [UILabel new];
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    _contentLabel.font = [Utils fontWithSize:SC_FONT_3];
    _contentLabel.textColor = [SCColor getColor:SC_COLOR_TEXT_3];
        _contentLabel.numberOfLines = 2;
    [tempView addSubview:_contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_nameLabel.mas_bottom).offset(0);
        make.left.mas_equalTo(_titleLabel);
        make.right.mas_equalTo(_titleLabel);
        make.bottom.mas_equalTo(tempView.mas_bottom).offset(-10);
    }];
    
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"删除"];
    
    self.rightUtilityButtons = rightUtilityButtons;
}

- (void)setData:(HSCMessageModel *)data{
    
}

- (void)setData:(HSCMessageModel *)data indexPath:(NSIndexPath*)indexPath{
    
    if (![data isKindOfClass:[HSCMessageModel class]]) {
        return;
    }
    
    self.cellData = data;
    
    self.indexPath = indexPath;
    
    
    _titleLabel.text = data.title;
    
    _nameLabel.text = [NSString stringWithFormat:@"发布人:%@",data.fromUser];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSInteger timeInterval = data.createTim;
    if(timeInterval > 140000000000) {
        timeInterval = timeInterval / 1000;
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    data.timeStr = [dateFormatter stringFromDate:date];
    _timeLabel.text = [Utils getCustomDateFromString:data.timeStr];
    
    _contentLabel.text = data.content;
    
}

@end
