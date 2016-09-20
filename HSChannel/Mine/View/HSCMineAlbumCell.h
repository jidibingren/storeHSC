//
//  HSCMineAlbumCell.h
//  HSChannel
//
//  Created by SC on 16/9/3.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "SCTableViewController.h"
#import "HSCMineAlbumModel.h"
#import "HSCSpeciallyPhotoContainerView.h"

@interface HSCMineAlbumCell : SCTableViewCell

@property (nonatomic, strong)UILabel     *timeLabel;
@property (nonatomic, strong)UITextView  *contentLabel;
@property (nonatomic, strong)UILabel     *numberLabel;
@property (nonatomic, strong)HSCSpeciallyPhotoContainerView   *photoContainer;
@property (nonatomic, strong)NSIndexPath *indexPath;
@property (nonatomic, strong)HSCMineAlbumModel *cellData;

@end
