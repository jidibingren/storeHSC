//
//  SCPrimaryFunctionCell.m
//  ShiHua
//
//  Created by SC on 15/5/1.
//  Copyright (c) 2015年 shuchuang. All rights reserved.
//

#import "SCPrimaryFunctionCell.h"
#import "SCPrimaryFunctionCellData.h"

#define IMAGE_WIDTH   50
#define IMAGE_HEIGHT  60
#define LABEL_WIDTH   frame.size.width
#define LABEL_HEIGHT  30

#define BACKGROUND_IMAGENAME  @"nil"

@implementation SCPrimaryFunctionCell

- (instancetype)init{
    if (self = [super init]){
        [self setupSubviewsWithFrame:self.frame];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self setupSubviewsWithFrame:frame];
    }
    return self;
}

- (void)setupSubviewsWithFrame:(CGRect)frame{
    
    
    _functionNameLabel = [[UILabel alloc]init];
    [_functionNameLabel setFont:[Utils fontWithSize:SC_FONT_3]];
    _functionNameLabel.textColor = [SCColor getColor:SC_COLOR_TEXT_3];
    [_functionNameLabel setTextAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:_functionNameLabel];
    [_functionNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView).offset(-10);
        make.left.mas_equalTo(self.contentView).offset(1);
        make.right.mas_equalTo(self.contentView).offset(-1);
        make.height.mas_equalTo(20);
    }];
    
    _functionImageView = [[UIImageView alloc]init];
    _functionImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_functionImageView];
    [_functionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(10);
        make.centerX.mas_equalTo(self.contentView);
        make.width.mas_equalTo(50);
        make.bottom.mas_equalTo(_functionNameLabel.mas_top).offset(-10);
    }];
    
    _newsLabel = [[UILabel alloc]init];
    [_newsLabel setFont:[Utils fontWithSize:SC_FONT_3]];
    _newsLabel.textColor = [SCColor getColor:SC_COLOR_TEXT_6];
    [_newsLabel setTextAlignment:NSTextAlignmentCenter];
    _newsLabel.layer.cornerRadius = 10;
    _newsLabel.layer.backgroundColor = [SCColor getColor:@"f5270b"].CGColor;
    _newsLabel.layer.masksToBounds = YES;
    [self.contentView addSubview:_newsLabel];
    [_newsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(10);
        make.left.mas_equalTo(_functionImageView.mas_right).offset(0);
        make.right.mas_lessThanOrEqualTo(self.contentView).offset(0);
        make.width.mas_greaterThanOrEqualTo(20);
        make.height.mas_equalTo(20);
    }];
    [_newsLabel setHidden:YES];
    
    UIImageView *highlightView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    highlightView.image = [UIImage imageNamed:BACKGROUND_IMAGENAME];
    [self setHighlightView:highlightView];
    
}

- (void)setData:(SCCollectionViewCellData *)data{
    SCPrimaryFunctionCellData    *cellData = (SCPrimaryFunctionCellData *)data;
    CGRect frame = _functionImageView.frame;
    if ([Utils isNilOrNSNull:cellData.functionName] || cellData.functionName.length == 0) {
        [_functionImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.contentView).offset(-10);
        }];
    }else {
        [_functionImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.functionNameLabel.mas_top).offset(-10);
        }];
    }
    
    _newsLabel.text = [NSString stringWithFormat:@"%ld",cellData.newsCount];
    
    [_newsLabel setHidden:cellData.newsCount <= 0];
    
    [_functionImageView setImage:[UIImage imageNamed:cellData.imageName]];
    [_functionNameLabel setText:cellData.functionName];
}

@end
