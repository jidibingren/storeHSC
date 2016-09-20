//
//  HSCSNDRangeCell.h
//  HSChannel
//
//  Created by SC on 16/8/25.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "SCTableViewController.h"

@interface HSCSNDRangeCell : SCTableViewCell

@property (nonatomic, strong)UIImageView *signedPhotoView;
@property (nonatomic, strong)UILabel     *nameLabel;
@property (nonatomic, strong)UILabel     *readLabel;
@property (nonatomic, strong)UILabel     *timeLabel;

- (void)setData:(HSCMessageModel *)data indexPath:(NSIndexPath*)indexPath;

@end
