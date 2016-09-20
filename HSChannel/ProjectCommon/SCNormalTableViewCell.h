//
//  SCNormalTableViewCell.h
//  JJ56
//
//  Created by SC on 16/7/17.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "SCTableViewController.h"

@protocol SCNormalCellDetailDelegate <NSObject>

- (void)didSelectRightPhotoWithIndexPath:(NSIndexPath*)indexPath;

@end

@interface SCNormalTableViewCell : SCTableViewCell

@property (nonatomic, weak  )id <SCNormalCellDetailDelegate> controller;

@property (nonatomic, strong)UILabel     *leftIcon;
@property (nonatomic, strong)UILabel     *leftTitle;
@property (nonatomic, strong)UITextField *middleTextField;
@property (nonatomic, strong)UIImageView *rightImageView;
@property (nonatomic, strong)UIImageView *rightIcon;
@property (nonatomic, strong)SCNormalCellData *cellData;
@property (nonatomic, strong)NSIndexPath *indexPath;

- (void)setData:(SCNormalCellData *)data indexPath:(NSIndexPath*)indexPath;

@end

@interface SCNormalTableViewCell1 : SCNormalTableViewCell

- (void)setupSubviewsWithFrame:(CGRect)frame;

@end

@interface SCNormalTableViewCell2 : SCTableViewCell

@property (nonatomic, weak  )id <SCNormalCellDetailDelegate> controller;

@property (nonatomic, strong)UILabel     *leftIcon;
@property (nonatomic, strong)UILabel     *leftTitle;
@property (nonatomic, strong)UITextField *middleTextField;
@property (nonatomic, strong)UILabel     *rightIcon;
@property (nonatomic, strong)NSIndexPath *indexPath;
@property (nonatomic, strong)SCNormalCellData *cellData;
- (void)setData:(SCNormalCellData *)data indexPath:(NSIndexPath*)indexPath;

@end

@interface SCNormalTableViewCell3 : SCTableViewCell

@property (nonatomic, weak  )id <SCNormalCellDetailDelegate> controller;

@property (nonatomic, strong)UILabel     *leftIcon;
@property (nonatomic, strong)UILabel     *leftTitle;
@property (nonatomic, strong)SZTextView  *middleTextView;

@end


@interface SCNormalTableViewCell4 : SCTableViewCell

@property (nonatomic, weak  )id <SCNormalCellDetailDelegate> controller;

@property (nonatomic, strong)UILabel     *leftIcon;
@property (nonatomic, strong)UILabel     *leftTitle;
@property (nonatomic, strong)SZTextView  *middleTextView;
@property (nonatomic, strong)SCNormalCellData *cellData;

- (void)setData:(SCNormalCellData *)data indexPath:(NSIndexPath*)indexPath;

@end

@interface SCNormalTableViewCell5 : SCTableViewCell

@property (nonatomic, weak  )id <SCNormalCellDetailDelegate> controller;

@property (nonatomic, strong)UIImageView *leftIcon;
@property (nonatomic, strong)UILabel     *newsLabel;
@property (nonatomic, strong)UILabel     *leftTitle;
@property (nonatomic, strong)UIImageView *rightIcon;
@property (nonatomic, strong)SCNormalCellData *cellData;
@property (nonatomic, strong)NSIndexPath *indexPath;

- (void)setData:(SCNormalCellData *)data indexPath:(NSIndexPath*)indexPath;

@end


@interface SCNormalTableViewCell6 : SCTableViewCell

@property (nonatomic, weak  )id <SCNormalCellDetailDelegate> controller;

@property (nonatomic, strong)UILabel     *leftTitle;
@property (nonatomic, strong)UITextField *middleTextField;
@property (nonatomic, strong)UIImageView      *rightIcon;
@property (nonatomic, strong)SCNormalCellData *cellData;

- (void)setData:(SCNormalCellData *)data indexPath:(NSIndexPath*)indexPath;

@end

@interface SCNormalTableViewCell7 : SCTableViewCell

@property (nonatomic, weak  )id <SCNormalCellDetailDelegate> controller;
@property (nonatomic, strong)UITextField  *textField;
@property (nonatomic, strong)SCNormalCellData *cellData;

- (void)setData:(SCNormalCellData *)data indexPath:(NSIndexPath*)indexPath;

@end


@interface SCNormalTableViewCell8 : SCTableViewCell

@property (nonatomic, weak  )id <SCNormalCellDetailDelegate> controller;
@property (nonatomic, strong)SZTextView  *textView;
@property (nonatomic, strong)SCNormalCellData *cellData;

- (void)setData:(SCNormalCellData *)data indexPath:(NSIndexPath*)indexPath;

@end

@interface SCNormalTableViewCell9 : SCTableViewCell

@property (nonatomic, weak  )id <SCNormalCellDetailDelegate> controller;

@property (nonatomic, strong)UIImageView *leftIcon;
@property (nonatomic, strong)UILabel     *leftTitle;
@property (nonatomic, strong)UITextField *middleTextField;
@property (nonatomic, strong)UIImageView *rightIcon;
@property (nonatomic, strong)SCNormalCellData *cellData;
@property (nonatomic, strong)NSIndexPath *indexPath;

- (void)setData:(SCNormalCellData *)data indexPath:(NSIndexPath*)indexPath;

@end