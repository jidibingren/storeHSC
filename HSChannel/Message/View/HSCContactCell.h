//
//  HSCContactCell.h
//  HSChannel
//
//  Created by SC on 16/8/26.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "SCTableViewController.h"
#import "HSCContactModel.h"

@interface HSCContactHeaderView : SCAccordionTableViewHeaderView

@property (nonatomic, strong)UIButton    *selectBtn;
@property (nonatomic, strong)UILabel     *nameLabel;
@property (nonatomic, strong)UIView      *separatorLineTop;
@property (nonatomic, strong)UIView      *separatorLineBottom;

@end


@interface HSCContactCell : SCTableViewCell

@property (nonatomic, strong)UIButton    *selectBtn;
@property (nonatomic, strong)UIImageView *signedPhotoView;
@property (nonatomic, strong)UILabel     *nameLabel;
@property (nonatomic, strong)UILabel     *contentLabel;
@property (nonatomic, strong)UIView      *separatorLine;
@property (nonatomic, strong)HSCContactModel  *cellData;

- (void)setData:(HSCContactModel *)data indexPath:(NSIndexPath*)indexPath;

@end


@interface HSCContactCell2 : SCTableViewCell

@property (nonatomic, strong)UIButton    *selectBtn;
@property (nonatomic, strong)UIImageView *signedPhotoView;
@property (nonatomic, strong)UILabel     *nameLabel;
@property (nonatomic, strong)UILabel     *contentLabel;
@property (nonatomic, strong)HSCContactModel  *cellData;

- (void)setData:(HSCContactModel *)data indexPath:(NSIndexPath*)indexPath;

@end
