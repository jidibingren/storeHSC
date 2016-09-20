//
//  HSCMessageCell.h
//  HSChannel
//
//  Created by SC on 16/8/24.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "SCTableViewController.h"

@interface HSCMessageCell : SCSWTableViewCell

@property (nonatomic, strong)UIImageView *signedPhotoView;
@property (nonatomic, strong)UILabel     *nameLabel;
@property (nonatomic, strong)UILabel     *timeLabel;
@property (nonatomic, strong)UILabel     *contentLabel;
@property (nonatomic, strong)UILabel     *numberLabel;
@property (nonatomic, strong)HSCMessageModel *cellData;

@end
