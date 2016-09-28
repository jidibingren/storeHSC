//
//  HSCMessageCell.m
//  HSChannel
//
//  Created by SC on 16/8/24.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "HSCMessageCell.h"

@implementation HSCMessageCell

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
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
    }];
    
    _timeLabel = [UILabel new];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.font = [Utils fontWithSize:12];
    _timeLabel.textColor = [SCColor getColor:@"333333"];
    [tempView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_nameLabel).offset(0);
        make.right.mas_equalTo(tempView).offset(rightMargin);
        make.left.mas_equalTo(_nameLabel.mas_right);
        make.height.mas_equalTo(20);
    }];
    
    _numberLabel = [UILabel new];
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    _numberLabel.font = [Utils fontWithSize:12];
    _numberLabel.textColor = [SCColor getColor:@"ffffff"];
    _numberLabel.layer.cornerRadius = 15;
    _numberLabel.layer.backgroundColor = [SCColor getColor:@"ff3b30"].CGColor;
    _numberLabel.layer.masksToBounds = YES;
    [tempView addSubview:_numberLabel];
    [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(tempView).offset(rightMargin);
        make.bottom.mas_equalTo(tempView.mas_bottom).offset(-10);
        make.size.mas_equalTo(CGSizeMake(30, 30));
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
        make.right.mas_equalTo(_numberLabel.mas_left);
        make.bottom.mas_equalTo(tempView.mas_bottom);
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
    
    
    _nameLabel.text = [Utils isValidStr:data.fromUser] ? data.fromUser : data.fromUsername;
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSInteger timeInterval = data.createTim;
    if(timeInterval > 140000000000) {
        timeInterval = timeInterval / 1000;
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    data.timeStr = [dateFormatter stringFromDate:date];
    _timeLabel.text = [Utils getCustomDateFromString:data.timeStr];
    
    
    if (data.messageType == HSCMessageSystem) {
        switch (data.type) {
            case 0:
                
                [_signedPhotoView setImage:[UIImage sc_imageNamed:KSCImageMessageCellSystemNotice]];
                _nameLabel.text = @"系统消息";
                
                break;
            case 1:
                
                [_signedPhotoView setImage:[UIImage sc_imageNamed:KSCImageMessageCellSchoolNotice]];
                _nameLabel.text = data.typeName;
                
                break;
            case 2:
                
                [_signedPhotoView setImage:[UIImage sc_imageNamed:KSCImageMessageCellClassNotice]];
                _nameLabel.text = data.typeName;
                
                break;
            case 3:
                
                [_signedPhotoView setImage:[UIImage sc_imageNamed:KSCImageMessageCellClassDynamic]];
                _nameLabel.text = data.typeName;
                
                break;
            case 4:
                
                [_signedPhotoView setImage:[UIImage sc_imageNamed:KSCImageMessageCellWork]];
                _nameLabel.text = data.typeName;
                
                break;
                
            default:
                break;
        }
        _contentLabel.text = data.content;
        _numberLabel.text = [NSString stringWithFormat:@"%ld",data.unreadCount];
        [_numberLabel setHidden:data.unreadCount <= 0];
        
    }else{
        
        [_signedPhotoView sd_setImageWithURL:[NSURL URLWithString:[Utils isValidStr:data.imgUrl] ? data.imgUrl : @""] placeholderImage:[UIImage sc_imageNamed:KSCImageMessageCellHeadDefault]];
        _nameLabel.text = [Utils isValidStr:data.title] ? data.title : data.fromUsername;
        _numberLabel.text = @(data.unreadCount).description;
        [_numberLabel setHidden:data.unreadCount == 0];
        if (data.message.body.type == EMMessageBodyTypeText) {
            _contentLabel.text = [(EMTextMessageBody *)(data.message.body) text];
        }
    }
}

@end
