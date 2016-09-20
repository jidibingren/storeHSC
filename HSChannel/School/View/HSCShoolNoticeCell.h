//
//  HSCShoolNoticeCell.h
//  HSChannel
//
//  Created by SC on 16/8/26.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import <SWTableViewCell/SWTableViewCell.h>

@interface HSCShoolNoticeCell : SCSWTableViewCell

@property (nonatomic, strong)UILabel     *titleLabel;
@property (nonatomic, strong)UILabel     *nameLabel;
@property (nonatomic, strong)UILabel     *timeLabel;
@property (nonatomic, strong)UILabel     *contentLabel;
@property (nonatomic, strong)HSCMessageModel *cellData;

@end
