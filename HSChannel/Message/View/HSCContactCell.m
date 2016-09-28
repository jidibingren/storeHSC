//
//  HSCContactCell.m
//  HSChannel
//
//  Created by SC on 16/8/26.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "HSCContactCell.h"

@implementation HSCContactHeaderView

- (void)setupSubviewsWithFrame:(CGRect)frame{
    
    CGFloat leftMargin  = 10;
    CGFloat rightMargin = -10;
    
    CGRect tempFrame = frame;
    
    tempFrame.origin = CGPointZero;
    
    tempFrame.size.width = ScreenWidth;
    
    self.contentView.backgroundColor = [SCColor getColor:@"ffffff"];
    
    
    DEFINE_WEAK(self);
    
    __weak UIView *tempView = self.contentView;
    
    
    _selectBtn = [UIButton new];
    [_selectBtn setImage:[UIImage sc_imageNamed:KSCImageContactHeaderSelectButtonNormal] forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage sc_imageNamed:KSCImageContactHeaderSelectButtonSelect] forState:UIControlStateSelected];
    [tempView addSubview:_selectBtn];
    [_selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tempView);
        make.left.mas_equalTo(tempView).offset(SC_MARGIN_LEFT);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    _nameLabel = [UILabel new];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.font = [Utils fontWithSize:15];
    _nameLabel.textColor = [SCColor getColor:@"333333"];
    [tempView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tempView).offset(0);
        make.left.mas_equalTo(_selectBtn.mas_right).offset(10);
        make.right.mas_equalTo(tempView).offset(SC_MARGIN_RIGHT);
        make.bottom.mas_equalTo(tempView);
    }];
    
    _separatorLineTop = [UIView new];
    _separatorLineTop.backgroundColor = [SCColor getColor:SC_COLOR_SEPARATOR_LINE];
    [tempView addSubview:_separatorLineTop];
    [_separatorLineTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tempView);
        make.left.mas_equalTo(tempView);
        make.right.mas_equalTo(tempView);
        make.height.mas_equalTo(0.5);
    }];
    
    _separatorLineBottom = [UIView new];
    _separatorLineBottom.backgroundColor = [SCColor getColor:SC_COLOR_SEPARATOR_LINE];
    [tempView addSubview:_separatorLineBottom];
    [_separatorLineBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(tempView);
        make.left.mas_equalTo(tempView);
        make.right.mas_equalTo(tempView);
        make.height.mas_equalTo(0.5);
    }];
    
}

- (void)setData:(HSCContactGroupModel *)data{
    
    if (![data isKindOfClass:[HSCContactGroupModel class]]) {
        return;
    }
    
    [self.selectBtn setSelected:data.isSpread];
    
    self.nameLabel.text = data.name;
    
    [self.separatorLineBottom setHidden:!data.isSpread];
    
}

@end

@implementation HSCContactCell
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
    
    
    _selectBtn = [UIButton new];
    [_selectBtn setImage:[UIImage sc_imageNamed:KSCImageContactCellSelectButtonNormal] forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage sc_imageNamed:KSCImageContactCellSelectButtonSelect] forState:UIControlStateSelected];
    [tempView addSubview:_selectBtn];
    [_selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tempView);
        make.left.mas_equalTo(tempView).offset(SC_MARGIN_LEFT);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];

    _signedPhotoView = [UIImageView new];
    _signedPhotoView.contentMode = UIViewContentModeScaleAspectFit;
    _signedPhotoView.layer.cornerRadius = 25;
    _signedPhotoView.layer.masksToBounds = YES;
    [tempView addSubview:_signedPhotoView];
    [_signedPhotoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tempView);
        make.left.mas_equalTo(_selectBtn.mas_right).offset(leftMargin);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(50);
        
    }];
    
    _nameLabel = [UILabel new];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.font = [Utils fontWithSize:15];
    _nameLabel.textColor = [SCColor getColor:@"333333"];
    [tempView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_signedPhotoView).offset(0);
        make.left.mas_equalTo(_signedPhotoView.mas_right).offset(10);
        make.right.mas_equalTo(tempView).offset(SC_MARGIN_RIGHT);
        make.bottom.mas_equalTo(_signedPhotoView.mas_centerY);
    }];
    
    _contentLabel = [UILabel new];
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    _contentLabel.font = [Utils fontWithSize:12];
    _contentLabel.textColor = [SCColor getColor:@"333333"];
    //    _contentLabel.numberOfLines = 0;
    [tempView addSubview:_contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_nameLabel.mas_bottom).offset(0);
        make.left.mas_equalTo(_nameLabel);
        make.right.mas_equalTo(_nameLabel);
        make.bottom.mas_equalTo(_signedPhotoView.mas_bottom);
    }];
    
    _separatorLine = [UIView new];
    _separatorLine.backgroundColor = [SCColor getColor:SC_COLOR_SEPARATOR_LINE];
    [tempView addSubview:_separatorLine];
    [_separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tempView);
        make.left.mas_equalTo(_signedPhotoView);
        make.right.mas_equalTo(tempView);
        make.height.mas_equalTo(0.5);
    }];
    
}

- (void)setData:(HSCContactModel *)data indexPath:(NSIndexPath*)indexPath{
    
    if (![data isKindOfClass:[HSCContactModel class]]) {
        return;
    }
    
    self.cellData = data;
    
    [_selectBtn setSelected:data.isSelected];
    
    [_signedPhotoView sd_setImageWithURL:[NSURL URLWithString:[Utils isValidStr:data.signPhoto] ? data.signPhoto : @""] placeholderImage:[UIImage sc_imageNamed:KSCImageContactCellSignedDefault]];
    
    _nameLabel.text = data.name;
    
    _contentLabel.text = data.className;
    
    [_separatorLine setHidden: indexPath.row == 0];
    
}

@end

@implementation HSCContactCell2

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
    
    
    _selectBtn = [UIButton new];
    [_selectBtn setImage:[UIImage sc_imageNamed:KSCImageContactCellSelectButtonNormal] forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage sc_imageNamed:KSCImageContactCellSelectButtonSelect] forState:UIControlStateSelected];
    [tempView addSubview:_selectBtn];
    [_selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tempView);
        make.right.mas_equalTo(tempView).offset(SC_MARGIN_RIGHT);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    _signedPhotoView = [UIImageView new];
    _signedPhotoView.contentMode = UIViewContentModeScaleAspectFit;
    _signedPhotoView.layer.cornerRadius = 25;
    _signedPhotoView.layer.masksToBounds = YES;
    [tempView addSubview:_signedPhotoView];
    [_signedPhotoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tempView);
        make.left.mas_equalTo(tempView).offset(leftMargin);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(50);
        
    }];
    
    _nameLabel = [UILabel new];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.font = [Utils fontWithSize:15];
    _nameLabel.textColor = [SCColor getColor:@"333333"];
    [tempView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_signedPhotoView).offset(0);
        make.left.mas_equalTo(_signedPhotoView.mas_right).offset(10);
        make.right.mas_equalTo(_selectBtn.mas_left).offset(SC_MARGIN_RIGHT);
        make.bottom.mas_equalTo(_signedPhotoView.mas_centerY);
    }];
    
    _contentLabel = [UILabel new];
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    _contentLabel.font = [Utils fontWithSize:12];
    _contentLabel.textColor = [SCColor getColor:@"333333"];
    //    _contentLabel.numberOfLines = 0;
    [tempView addSubview:_contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_nameLabel.mas_bottom).offset(0);
        make.left.mas_equalTo(_nameLabel);
        make.right.mas_equalTo(_nameLabel);
        make.bottom.mas_equalTo(_signedPhotoView.mas_bottom);
    }];
    
}

- (void)setData:(HSCContactModel *)data indexPath:(NSIndexPath*)indexPath{
    
    if (![data isKindOfClass:[HSCContactModel class]]) {
        return;
    }
    
    self.cellData = data;
    
    [_selectBtn setSelected:data.isSelected];
    
    [_signedPhotoView sd_setImageWithURL:[NSURL URLWithString:[Utils isValidStr:data.signPhoto] ? data.signPhoto : @""] placeholderImage:[UIImage sc_imageNamed:KSCImageContactCellSignedDefault]];
    
    _nameLabel.text = data.name;
    
    _contentLabel.text = data.className;
    
}

@end
