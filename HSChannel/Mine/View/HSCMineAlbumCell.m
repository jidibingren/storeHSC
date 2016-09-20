//
//  HSCMineAlbumCell.m
//  HSChannel
//
//  Created by SC on 16/9/3.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "HSCMineAlbumCell.h"

@implementation HSCMineAlbumCell
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
    
    
    _timeLabel = [UILabel new];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.font = [Utils fontWithSize:SC_FONT_3];
    _timeLabel.textColor = [SCColor getColor:SC_COLOR_TEXT_2];
    [tempView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tempView).offset(20);
        make.left.mas_equalTo(tempView).offset(leftMargin);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(20);
    }];
    
    
    _photoContainer = [[HSCSpeciallyPhotoContainerView alloc]initWithFrame:CGRectMake(0, 0, 125, 125)];
    [tempView addSubview:_photoContainer];
    [_photoContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_timeLabel).offset(0);
        make.left.mas_equalTo(_timeLabel.mas_right).offset(10);
        make.width.mas_equalTo(125);
        make.height.mas_equalTo(125);
    }];
    
    
    _numberLabel = [UILabel new];
    _numberLabel.textAlignment = NSTextAlignmentLeft;
    _numberLabel.font = [Utils fontWithSize:SC_FONT_4];
    _numberLabel.textColor = [SCColor getColor:SC_COLOR_TEXT_4];
    [tempView addSubview:_numberLabel];
    [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_photoContainer.mas_right).offset(leftMargin);
        make.right.mas_equalTo(tempView).offset(rightMargin);
        make.bottom.mas_equalTo(_photoContainer.mas_bottom);
        make.height.mas_equalTo(20);
    }];
    
    _contentLabel = [UITextView new];
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    _contentLabel.textContainer.lineBreakMode = NSLineBreakByWordWrapping;
    _contentLabel.textContainer.maximumNumberOfLines = 6;
    _contentLabel.font = [Utils fontWithSize:SC_FONT_3];
    _contentLabel.textColor = [SCColor getColor:SC_COLOR_TEXT_2];
    _contentLabel.userInteractionEnabled = NO;
    [tempView addSubview:_contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_photoContainer).offset(-10);
        make.left.mas_equalTo(_numberLabel);
        make.right.mas_equalTo(_numberLabel);
        make.bottom.mas_equalTo(_numberLabel.mas_top);
    }];
    

}


- (void)setData:(HSCMineAlbumModel *)data indexPath:(NSIndexPath*)indexPath{
    
    if (![data isKindOfClass:[HSCMineAlbumModel class]]) {
        return;
    }
    
    self.cellData = data;
    
    self.indexPath = indexPath;
    
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSInteger timeInterval = data.createTim;
    if(timeInterval > 140000000000) {
        timeInterval = timeInterval / 1000;
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    _timeLabel.text = [Utils getDateToDayFromString:[dateFormatter stringFromDate:date]];
    
    _contentLabel.text = data.content;
    
    _numberLabel.text = [NSString stringWithFormat:@"共%ld张",data.images.count];
    
    NSMutableArray *urls = [NSMutableArray new];
    NSMutableArray *urlsB = [NSMutableArray new];
    
    for (NSDictionary *dict in data.images) {
        [urls addObject:dict[@"url"]];
        [urlsB addObject:dict[@"urlB"]];
    }
    
    _photoContainer.urlsBig = urlsB;
    _photoContainer.urls = urls;
    
    
    
}
@end
