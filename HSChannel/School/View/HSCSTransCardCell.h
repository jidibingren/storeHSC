//
//  HSCSTransCardCell.h
//  HSChannel
//
//  Created by SC on 16/8/30.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "SCTableViewController.h"
#import "HSCSTransCardModel.h"

@protocol HSCSTransCardCellDelegate <NSObject>

- (void)deleteCellByIndexPath:(NSIndexPath *)indexPath;

@end

@interface HSCSTransCardCell : SCTableViewCell

@property (nonatomic, strong)UILabel     *titleLabel;
@property (nonatomic, strong)UIImageView *rightImageView;
@property (nonatomic, strong)HSCSTransCardModel *cellData;
@property (nonatomic, strong)NSIndexPath *indexPath;
@property (nonatomic, weak  )id<HSCSTransCardCellDelegate> delegate;

@end
