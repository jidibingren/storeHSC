//
//  HSCSNDRangeCell.m
//  HSChannel
//
//  Created by SC on 16/8/25.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "HSCSNDRangeCell.h"

@implementation HSCSNDRangeCell

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
    
    
    _signedPhotoView = [UIImageView new];
    _signedPhotoView.contentMode = UIViewContentModeScaleAspectFit;
    _signedPhotoView.layer.cornerRadius = 17.5;
    _signedPhotoView.layer.masksToBounds = YES;
    [tempView addSubview:_signedPhotoView];
    [_signedPhotoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tempView);
        make.left.mas_equalTo(tempView).offset(leftMargin);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(35);
        
    }];
    
    _nameLabel = [UILabel new];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.font = [Utils fontWithSize:SC_FONT_3];
    _nameLabel.textColor = [SCColor getColor:SC_COLOR_TEXT_2];
    [tempView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_signedPhotoView).offset(2);
        make.left.mas_equalTo(_signedPhotoView.mas_right).offset(10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(15);
    }];
    
    _readLabel = [UILabel new];
    _readLabel.textAlignment = NSTextAlignmentLeft;
    _readLabel.font = [Utils fontWithSize:SC_FONT_4];
    _readLabel.textColor = [SCColor getColor:SC_COLOR_TEXT_4];
    [tempView addSubview:_readLabel];
    [_readLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_nameLabel.mas_bottom).offset(0);
        make.left.mas_equalTo(_nameLabel);
        make.bottom.mas_equalTo(tempView.mas_bottom).offset(3);
        make.width.mas_equalTo(30);
    }];
    
    _timeLabel = [UILabel new];
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    _timeLabel.font = [Utils fontWithSize:SC_FONT_4];
    _timeLabel.textColor = [SCColor getColor:SC_COLOR_TEXT_4];
    [tempView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_readLabel).offset(0);
        make.right.mas_equalTo(tempView).offset(rightMargin);
        make.left.mas_equalTo(_readLabel.mas_right);
        make.bottom.mas_equalTo(_readLabel);
    }];
    
}
- (void)setData:(HSCSNDRange *)data indexPath:(NSIndexPath*)indexPath{
    
    if (![data isKindOfClass:[HSCSNDRange class]]) {
        return;
    }
    
    [_signedPhotoView sd_setImageWithURL:[NSURL URLWithString:[Utils isValidStr:data.userImage] ? data.userImage : @""] placeholderImage:[UIImage imageNamed:@"message_head_default"]];
    
    _nameLabel.text = data.username;
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSInteger timeInterval = data.updateTime;
    if(timeInterval > 140000000000) {
        timeInterval = timeInterval / 1000;
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    _timeLabel.text = [NSString stringWithFormat:@", %@",[dateFormatter stringFromDate:date]];
    
    
    if (data.isRead == 0) {
        
        _readLabel.text = @"未读";
        
        _readLabel.textColor = [SCColor getColor:@"ff6161"];
        
    }else{
        
        _readLabel.text = @"已读";
        
        _readLabel.textColor = [SCColor getColor:SC_COLOR_THEME_TEXT];
        
    }
}

@end
