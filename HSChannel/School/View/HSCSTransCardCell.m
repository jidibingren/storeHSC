//
//  HSCSTransCardCell.m
//  HSChannel
//
//  Created by SC on 16/8/30.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "HSCSTransCardCell.h"

@implementation HSCSTransCardCell

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
    
    _rightImageView = [UIImageView new];
    _rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    _rightImageView.image = [UIImage sc_imageNamed:KSCImageSTransCardCellIconDelete];
    _rightImageView.userInteractionEnabled = YES;
    [tempView addSubview:_rightImageView];
    [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tempView);
        make.right.mas_equalTo(tempView).offset(SC_MARGIN_RIGHT);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
        
    }];
    [_rightImageView bk_whenTapped:^{
        
        if (wself.delegate && [wself.delegate respondsToSelector:@selector(deleteCellByIndexPath:)]) {
            
            [wself.delegate deleteCellByIndexPath:wself.indexPath];
            
        }
        
    }];
    
    _titleLabel = [UILabel new];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.font = [Utils fontWithSize:SC_FONT_3];
    _titleLabel.textColor = [SCColor getColor:SC_COLOR_TEXT_3];
    [tempView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tempView);
        make.left.mas_equalTo(tempView).offset(SC_MARGIN_LEFT);
        make.right.mas_equalTo(_rightImageView.mas_left).offset(SC_MARGIN_RIGHT);
        make.height.mas_equalTo(30);
    }];
    
}

- (void)setData:(HSCSTransCardModel *)data indexPath:(NSIndexPath*)indexPath{
    
    if (![data isKindOfClass:[HSCSTransCardModel class]]) {
        return;
    }
    
    self.cellData = data;
    
    self.indexPath = indexPath;
    
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@  %@  %@", [Utils groupText:data.stuCode seperator:@" " groupLength:4], data.stuName, data.className];
    
}

@end
