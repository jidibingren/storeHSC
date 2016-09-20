//
//  SCNormalTableViewCell.m
//  JJ56
//
//  Created by SC on 16/7/17.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "SCNormalTableViewCell.h"

@implementation SCNormalTableViewCell
- (void)setupSubviewsWithFrame:(CGRect)frame{
    
    CGFloat leftMargin  = 10;
    CGFloat rightMargin = -10;
    
    CGRect tempFrame = frame;
    
    tempFrame.origin = CGPointZero;
    
    tempFrame.size.width = ScreenWidth;
    
    self.contentView.backgroundColor = [SCColor getColor:@"ffffff"];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    __weak UIView *tempView = self.contentView;
    
    _leftTitle = [UILabel new];
    _leftTitle.textAlignment = NSTextAlignmentRight;
    _leftTitle.font = [Utils fontWithSize:15];
    _leftTitle.textColor = [SCColor getColor:@"333333"];
    [tempView addSubview:_leftTitle];
    [_leftTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tempView);
        make.right.mas_equalTo(tempView.mas_left).offset(60+10+leftMargin);
        make.width.mas_lessThanOrEqualTo(60);
        make.height.mas_equalTo(25);
    }];
    
    _leftIcon = [UILabel new];
    _leftIcon.text = @"*";
    _leftIcon.font = [Utils fontWithSize:15];
    _leftIcon.textColor = [SCColor getColor:@"f75646"];
    [tempView addSubview:_leftIcon];
    [_leftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tempView);
        make.right.mas_equalTo(_leftTitle.mas_left).offset(-5);
        make.width.mas_equalTo(5);
        make.height.mas_equalTo(42);
    }];
    
    
    _rightIcon = [UIImageView new];
    _rightIcon.contentMode = UIViewContentModeScaleAspectFit;
    _rightIcon.image = [UIImage imageNamed:@"moments_icon_more"];
    [tempView addSubview:_rightIcon];
    [_rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tempView);
        make.right.mas_equalTo(tempView).offset(-15);
        make.width.mas_equalTo(18);
        make.height.mas_equalTo(18);
    }];
    
    _rightImageView = [UIImageView new];
    _rightImageView.contentMode = UIViewContentModeScaleAspectFill;
    _rightImageView.layer.cornerRadius = 20;
    _rightImageView.layer.masksToBounds = YES;
    [tempView addSubview:_rightImageView];
    [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tempView);
        make.right.mas_equalTo(_rightIcon.mas_left).offset(-9);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    _rightImageView.userInteractionEnabled = YES;
    
    DEFINE_WEAK(self);
    [_rightImageView bk_whenTapped:^{
        if (wself.cellData.isImageSelect && wself.controller) {
            [wself.controller didSelectRightPhotoWithIndexPath:wself.indexPath];
        }
    }];
    
    _middleTextField = [UITextField new];
    _middleTextField.textAlignment = NSTextAlignmentLeft;
    _middleTextField.font = [Utils fontWithSize:15];
    _middleTextField.textColor = [SCColor getColor:@"999999"];
    _middleTextField.userInteractionEnabled = NO;
    [tempView addSubview:_middleTextField];
    [_middleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tempView);
        make.right.mas_equalTo(_rightIcon.mas_left).offset(-9);
        make.left.mas_equalTo(_leftTitle.mas_right).offset(9);
        make.height.mas_equalTo(25);
    }];
    
    UIView *inputAccessoryView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    inputAccessoryView.backgroundColor = [UIColor clearColor];
    inputAccessoryView.userInteractionEnabled = YES;
    [inputAccessoryView bk_whenTapped:^{
        wself.cellData.middleText = wself.middleTextField.text;
        [wself.middleTextField resignFirstResponder];
    }];
    _middleTextField.inputAccessoryView = inputAccessoryView;
    
}

- (void)setData:(SCNormalCellData *)data indexPath:(NSIndexPath*)indexPath{
    
    if ([data isKindOfClass:[SCNormalCellData class]]) {
        
        self.cellData = data;
        
        self.indexPath = indexPath;
        
        [self.leftIcon setHidden:!data.isMust];
        
        _leftTitle.text = data.leftTitle;
        
        _middleTextField.text = data.middleText;
        
        _middleTextField.placeholder = data.placeholder;
        
        _middleTextField.userInteractionEnabled = data.middleTextEnabled;
        
        if (data.rightImageNameLocal) {
            
            _rightImageView.image = data.rightImageNameLocal;
            
        }else{
            
            if ([Utils isValidStr:data.rightImageName]) {
                
                [_rightImageView sd_setImageWithURL:[NSURL URLWithString:data.rightImageName] placeholderImage:[UIImage imageNamed:@"real_icon_head"]];
                
            }else{
                _rightImageView.image = [UIImage imageNamed:@"real_icon_head"];
            }
            
        }
        
        [_rightImageView setHidden:!data.isImageSelect];
        
        _rightIcon.image = [UIImage imageNamed:[Utils isValidStr:data.rightIconName]?data.rightIconName:@"moments_icon_more"];
        
        [_rightIcon setHidden:data.dontShowRightArrow];
    }
    
}

@end

@implementation SCNormalTableViewCell1

- (void)setupSubviewsWithFrame:(CGRect)frame{
    
    [super setupSubviewsWithFrame:frame];
    
    __weak UIView *tempView = self.contentView;
    
    self.leftTitle.textAlignment = NSTextAlignmentLeft;
    
    [self.leftIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tempView);
        make.left.mas_equalTo(tempView).offset(15);
        make.width.mas_equalTo(5);
        make.height.mas_equalTo(42);
    }];
    
    [self.leftTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tempView);
        make.left.mas_equalTo(self.leftIcon.mas_right);
        make.width.mas_lessThanOrEqualTo(140);
        make.height.mas_equalTo(25);
    }];
    
    [self.middleTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tempView);
        make.right.mas_equalTo(self.rightIcon.mas_left).offset(-9);
        make.left.mas_equalTo(self.leftTitle.mas_right).offset(9);
        make.height.mas_equalTo(25);
    }];
}

@end

@implementation SCNormalTableViewCell2
- (void)setupSubviewsWithFrame:(CGRect)frame{
    DEFINE_WEAK(self);
    CGFloat leftMargin  = 10;
    CGFloat rightMargin = -10;
    
    CGRect tempFrame = frame;
    
    tempFrame.origin = CGPointZero;
    
    tempFrame.size.width = ScreenWidth;
    
    self.contentView.backgroundColor = [SCColor getColor:@"ffffff"];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    __weak UIView *tempView = self.contentView;
    
    _leftTitle = [UILabel new];
    _leftTitle.textAlignment = NSTextAlignmentRight;
    _leftTitle.font = [Utils fontWithSize:15];
    _leftTitle.textColor = [SCColor getColor:@"333333"];
    [tempView addSubview:_leftTitle];
    [_leftTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tempView);
        make.right.mas_equalTo(tempView.mas_left).offset(60+10+leftMargin);
        make.width.mas_lessThanOrEqualTo(60);
        make.height.mas_equalTo(25);
    }];
    
    _leftIcon = [UILabel new];
    _leftIcon.text = @"*";
    _leftIcon.font = [Utils fontWithSize:15];
    _leftIcon.textColor = [SCColor getColor:@"f75646"];
    [tempView addSubview:_leftIcon];
    [_leftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tempView);
        make.right.mas_equalTo(_leftTitle.mas_left).offset(-5);
        make.width.mas_equalTo(5);
        make.height.mas_equalTo(42);
    }];
    
    
    _rightIcon = [UILabel new];
    //    _rightIcon.text = @"辆";
    _rightIcon.font = [Utils fontWithSize:15];
    _rightIcon.textColor = [SCColor getColor:@"333333"];
    [tempView addSubview:_rightIcon];
    [_rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tempView);
        make.right.mas_equalTo(tempView).offset(-15);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(42);
    }];
    
    _middleTextField = [UITextField new];
    _middleTextField.textAlignment = NSTextAlignmentRight;
    _middleTextField.font = [Utils fontWithSize:15];
    _middleTextField.textColor = [SCColor getColor:@"999999"];
    _middleTextField.userInteractionEnabled = NO;
    [tempView addSubview:_middleTextField];
    [_middleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tempView);
        make.right.mas_equalTo(_rightIcon.mas_left).offset(-9);
        make.left.mas_equalTo(_leftTitle.mas_right).offset(9);
        make.height.mas_equalTo(25);
    }];
    
    UIView *inputAccessoryView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    inputAccessoryView.backgroundColor = [UIColor clearColor];
    inputAccessoryView.userInteractionEnabled = YES;
    [inputAccessoryView bk_whenTapped:^{
        wself.cellData.middleText = wself.middleTextField.text;
        [wself.middleTextField resignFirstResponder];
    }];
    _middleTextField.inputAccessoryView = inputAccessoryView;
}

- (void)setData:(SCNormalCellData *)data indexPath:(NSIndexPath*)indexPath{
    
    if ([data isKindOfClass:[SCNormalCellData class]]) {
        _cellData = data;
        self.leftTitle.text = data.leftTitle;
        self.middleTextField.placeholder = data.placeholder;
        self.middleTextField.text = data.middleText;
        self.middleTextField.userInteractionEnabled = data.middleTextEnabled;
    }
    
}

@end

@implementation SCNormalTableViewCell3
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
    
    _leftTitle = [UILabel new];
    _leftTitle.textAlignment = NSTextAlignmentRight;
    _leftTitle.font = [Utils fontWithSize:15];
    _leftTitle.textColor = [SCColor getColor:@"333333"];
    [tempView addSubview:_leftTitle];
    [_leftTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tempView).offset(10);
        make.right.mas_equalTo(tempView.mas_left).offset(60+10+leftMargin);
        make.width.mas_lessThanOrEqualTo(60);
        make.height.mas_equalTo(25);
    }];
    
    _leftIcon = [UILabel new];
    _leftIcon.text = @"*";
    _leftIcon.font = [Utils fontWithSize:15];
    _leftIcon.textColor = [SCColor getColor:@"f75646"];
    [tempView addSubview:_leftIcon];
    [_leftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_leftTitle);
        make.right.mas_equalTo(_leftTitle.mas_left).offset(-5);
        make.width.mas_equalTo(5);
        make.height.mas_equalTo(42);
    }];
    
    [_leftIcon setHidden:YES];
    
    
    _middleTextView = [SZTextView new];
    _middleTextView.textAlignment = NSTextAlignmentLeft;
    _middleTextView.font = [Utils fontWithSize:15];
    _middleTextView.textColor = [SCColor getColor:@"999999"];
    _middleTextView.userInteractionEnabled = NO;
    [tempView addSubview:_middleTextView];
    [_middleTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tempView).offset(2);
        make.right.mas_equalTo(tempView).offset(-10);
        make.left.mas_equalTo(_leftTitle.mas_right).offset(10);
        make.bottom.mas_equalTo(tempView).offset(-2);
    }];
    
    UIView *inputAccessoryView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    inputAccessoryView.userInteractionEnabled = YES;
    [inputAccessoryView bk_whenTapped:^{
        [wself.middleTextView resignFirstResponder];
    }];
    inputAccessoryView.backgroundColor = [UIColor clearColor];
    _middleTextView.inputAccessoryView = inputAccessoryView;
}

@end

@implementation SCNormalTableViewCell4
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
    
    _leftTitle = [UILabel new];
    _leftTitle.textAlignment = NSTextAlignmentRight;
    _leftTitle.font = [Utils fontWithSize:15];
    _leftTitle.textColor = [SCColor getColor:@"333333"];
    [tempView addSubview:_leftTitle];
    [_leftTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tempView).offset(10);
        make.right.mas_equalTo(tempView.mas_left).offset(60+10+leftMargin);
        make.width.mas_lessThanOrEqualTo(60);
        make.height.mas_equalTo(25);
    }];
    
    _leftIcon = [UILabel new];
    _leftIcon.text = @"*";
    _leftIcon.font = [Utils fontWithSize:15];
    _leftIcon.textColor = [SCColor getColor:@"f75646"];
    [tempView addSubview:_leftIcon];
    [_leftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_leftTitle);
        make.right.mas_equalTo(_leftTitle.mas_left).offset(-5);
        make.width.mas_equalTo(5);
        make.height.mas_equalTo(42);
    }];
    
    [_leftIcon setHidden:YES];
    
    
    _middleTextView = [SZTextView new];
    _middleTextView.textAlignment = NSTextAlignmentLeft;
    _middleTextView.font = [Utils fontWithSize:15];
    _middleTextView.textColor = [SCColor getColor:@"999999"];
    _middleTextView.layer.borderWidth = 0.5;
    _middleTextView.layer.borderColor = [SCColor getColor:@"d5d5d5"].CGColor;
    [tempView addSubview:_middleTextView];
    [_middleTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tempView).offset(2);
        make.right.mas_equalTo(tempView).offset(-10);
        make.left.mas_equalTo(_leftTitle.mas_right).offset(10);
        make.bottom.mas_equalTo(tempView).offset(-2);
    }];
    
    UIView *inputAccessoryView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    inputAccessoryView.userInteractionEnabled = YES;
    [inputAccessoryView bk_whenTapped:^{
        wself.cellData.middleText = wself.middleTextView.text;
        [wself.middleTextView resignFirstResponder];
    }];
    inputAccessoryView.backgroundColor = [UIColor clearColor];
    _middleTextView.inputAccessoryView = inputAccessoryView;
    
}

- (void)setData:(SCNormalCellData *)data indexPath:(NSIndexPath*)indexPath{
    
    if ([data isKindOfClass:[SCNormalCellData class]]) {
        _cellData = data;
        self.leftTitle.text = data.leftTitle;
        self.middleTextView.placeholder = data.placeholder;
        self.middleTextView.text = data.middleText;
        self.middleTextView.userInteractionEnabled = data.middleTextEnabled;
    }
    
}

@end

@implementation SCNormalTableViewCell5


- (void)setupSubviewsWithFrame:(CGRect)frame{
    
    CGFloat leftMargin  = 10;
    CGFloat rightMargin = -10;
    
    CGRect tempFrame = frame;
    
    tempFrame.origin = CGPointZero;
    
    tempFrame.size.width = ScreenWidth;
    
    self.contentView.backgroundColor = [SCColor getColor:@"ffffff"];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    __weak UIView *tempView = self.contentView;
    
    
    _leftIcon = [UIImageView new];
    _leftIcon.contentMode = UIViewContentModeScaleAspectFit;
    [tempView addSubview:_leftIcon];
    [_leftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tempView);
        make.left.mas_equalTo(tempView).offset(leftMargin);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    
    _newsLabel = [UILabel new];
    _newsLabel.textAlignment = NSTextAlignmentLeft;
    _newsLabel.font = [Utils fontWithSize:SC_FONT_3];
    _newsLabel.textColor = [SCColor getColor:SC_COLOR_TEXT_2];
    _newsLabel.layer.cornerRadius = 2.5;
    _newsLabel.layer.backgroundColor = [SCColor getColor:@"ff0000"].CGColor;
    _newsLabel.layer.masksToBounds = YES;
    [tempView addSubview:_newsLabel];
    [_newsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_leftIcon);
        make.left.mas_equalTo(_leftIcon.mas_right).offset(2);
        make.width.mas_equalTo(5);
        make.height.mas_equalTo(5);
    }];
    [_newsLabel setHidden:YES];
    
    _rightIcon = [UIImageView new];
    _rightIcon.contentMode = UIViewContentModeScaleAspectFit;
    _rightIcon.image = [UIImage imageNamed:@"moments_icon_more"];
    [tempView addSubview:_rightIcon];
    [_rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tempView);
        make.right.mas_equalTo(tempView).offset(-15);
        make.width.mas_equalTo(18);
        make.height.mas_equalTo(18);
    }];
    
    
    _leftTitle = [UILabel new];
    _leftTitle.textAlignment = NSTextAlignmentLeft;
    _leftTitle.font = [Utils fontWithSize:15];
    _leftTitle.textColor = [SCColor getColor:@"333333"];
    [tempView addSubview:_leftTitle];
    [_leftTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tempView);
        make.left.mas_equalTo(_leftIcon.mas_right).offset(10);
        make.right.mas_equalTo(_rightIcon.mas_left).offset(-10);
        make.height.mas_equalTo(25);
    }];
    
}

- (void)setData:(SCNormalCellData *)data indexPath:(NSIndexPath*)indexPath{
    
    if ([data isKindOfClass:[SCNormalCellData class]]) {
        
        self.cellData = data;
        
        self.indexPath = indexPath;
        
        _leftIcon.image = [UIImage imageNamed:data.leftIconName];
        
        [_newsLabel setHidden:data.newsCount <= 0];
        
        _leftTitle.text = data.leftTitle;
        
        if (![Utils isValidStr:self.cellData.rightIconName] || ![Utils isValidStr:self.cellData.rightIconSelectedName]) {
            
            _rightIcon.image = [UIImage imageNamed:[Utils isValidStr:data.rightIconName]?data.rightIconName:@"moments_icon_more"];
        }else{
            
            if (self.isSelected) {
                
                self.rightIcon.image = [UIImage imageNamed:self.cellData.rightIconSelectedName];
                
            }else{
                
                self.rightIcon.image = [UIImage imageNamed:self.cellData.rightIconName];
                
            }
        }
        
    }
    
}

@end

@implementation SCNormalTableViewCell6
- (void)setupSubviewsWithFrame:(CGRect)frame{
    
    CGFloat leftMargin  = 15;
    CGFloat rightMargin = -15;
    
    CGRect tempFrame = frame;
    
    tempFrame.origin = CGPointZero;
    
    tempFrame.size.width = ScreenWidth;
    
    self.contentView.backgroundColor = [SCColor getColor:@"ffffff"];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    DEFINE_WEAK(self);
    
    __weak UIView *tempView = self.contentView;
    
    _leftTitle = [UILabel new];
    _leftTitle.textAlignment = NSTextAlignmentLeft;
    _leftTitle.font = [Utils fontWithSize:15];
    _leftTitle.textColor = [SCColor getColor:@"333333"];
    [tempView addSubview:_leftTitle];
    [_leftTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tempView);
        make.left.mas_equalTo(tempView).offset(leftMargin);
        make.width.mas_lessThanOrEqualTo(60);
        make.height.mas_equalTo(25);
    }];
    
    _rightIcon = [UIImageView new];
    _rightIcon.contentMode = UIViewContentModeScaleAspectFit;
    _rightIcon.image = [UIImage imageNamed:@"real_icon_right"];
    [tempView addSubview:_rightIcon];
    [_rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tempView);
        make.right.mas_equalTo(tempView).offset(-15);
        make.width.mas_equalTo(18);
        make.height.mas_equalTo(18);
    }];
    
    _middleTextField = [UITextField new];
    _middleTextField.textAlignment = NSTextAlignmentRight;
    _middleTextField.font = [Utils fontWithSize:15];
    _middleTextField.textColor = [SCColor getColor:@"999999"];
    _middleTextField.userInteractionEnabled = NO;
    [tempView addSubview:_middleTextField];
    [_middleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tempView);
        make.right.mas_equalTo(_rightIcon.mas_left).offset(-9);
        make.left.mas_equalTo(_leftTitle.mas_right).offset(9);
        make.height.mas_equalTo(25);
    }];
    
    UIView *inputAccessoryView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    inputAccessoryView.backgroundColor = [UIColor clearColor];
    inputAccessoryView.userInteractionEnabled = YES;
    [inputAccessoryView bk_whenTapped:^{
        wself.cellData.middleText = wself.middleTextField.text;
        [wself.middleTextField resignFirstResponder];
    }];
    _middleTextField.inputAccessoryView = inputAccessoryView;
    
    
}

- (void)setData:(SCNormalCellData *)data indexPath:(NSIndexPath*)indexPath{
    
    if ([data isKindOfClass:[SCNormalCellData class]]) {
        _cellData = data;
        self.leftTitle.text = data.leftTitle;
        self.middleTextField.placeholder = data.placeholder;
        self.middleTextField.text = data.middleText;
        self.middleTextField.userInteractionEnabled = data.middleTextEnabled;
        
        if (![Utils isValidStr:self.cellData.rightIconName] || ![Utils isValidStr:self.cellData.rightIconSelectedName]) {
            
            _rightIcon.image = [UIImage imageNamed:[Utils isValidStr:data.rightIconName]?data.rightIconName:@"moments_icon_more"];
        }else{
            
            if (self.isSelected) {
                
                self.rightIcon.image = [UIImage imageNamed:self.cellData.rightIconSelectedName];
                
            }else{
                
                self.rightIcon.image = [UIImage imageNamed:self.cellData.rightIconName];
                
            }
        }
    }
    
}

@end

@implementation SCNormalTableViewCell7

- (void)setupSubviewsWithFrame:(CGRect)frame{
    
    CGFloat leftMargin  = 15;
    CGFloat rightMargin = -15;
    
    CGRect tempFrame = frame;
    
    tempFrame.origin = CGPointZero;
    
    tempFrame.size.width = ScreenWidth;
    
    self.contentView.backgroundColor = [SCColor getColor:@"ffffff"];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    DEFINE_WEAK(self);
    
    __weak UIView *tempView = self.contentView;
    
    
    _textField = [UITextField new];
    _textField.textAlignment = NSTextAlignmentLeft;
    _textField.font = [Utils fontWithSize:15];
    _textField.textColor = [SCColor getColor:@"999999"];
    _textField.userInteractionEnabled = NO;
    [tempView addSubview:_textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(tempView).offset(rightMargin);
        make.left.mas_equalTo(tempView).offset(leftMargin);
        make.top.mas_equalTo(tempView);
        make.bottom.mas_equalTo(tempView);
    }];
    
    UIView *inputAccessoryView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    inputAccessoryView.backgroundColor = [UIColor clearColor];
    inputAccessoryView.userInteractionEnabled = YES;
    [inputAccessoryView bk_whenTapped:^{
        wself.cellData.middleText = wself.textField.text;
        [wself.textField resignFirstResponder];
    }];
    _textField.inputAccessoryView = inputAccessoryView;
    
}

- (void)setData:(SCNormalCellData *)data indexPath:(NSIndexPath*)indexPath{
    
    if ([data isKindOfClass:[SCNormalCellData class]]) {
        _cellData = data;
        self.textField.placeholder = data.placeholder;
        self.textField.text = data.middleText;
        self.textField.userInteractionEnabled = data.middleTextEnabled;
    }
    
}

@end

@implementation SCNormalTableViewCell8

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
    
    
    _textView = [SZTextView new];
    _textView.textAlignment = NSTextAlignmentLeft;
    _textView.font = [Utils fontWithSize:15];
    _textView.textColor = [SCColor getColor:@"999999"];
//    _textView.layer.borderWidth = 0.5;
//    _textView.layer.borderColor = [SCColor getColor:@"d5d5d5"].CGColor;
    [tempView addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(tempView).offset(rightMargin);
        make.left.mas_equalTo(tempView).offset(leftMargin);
        make.top.mas_equalTo(tempView);
        make.bottom.mas_equalTo(tempView);
    }];
    
    UIView *inputAccessoryView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    inputAccessoryView.userInteractionEnabled = YES;
    [inputAccessoryView bk_whenTapped:^{
        wself.cellData.middleText = wself.textView.text;
        [wself.textView resignFirstResponder];
    }];
    inputAccessoryView.backgroundColor = [UIColor clearColor];
    _textView.inputAccessoryView = inputAccessoryView;
    
}

- (void)setData:(SCNormalCellData *)data indexPath:(NSIndexPath*)indexPath{
    
    if ([data isKindOfClass:[SCNormalCellData class]]) {
        _cellData = data;
        self.textView.placeholder = data.placeholder;
        self.textView.text = data.middleText;
        self.textView.userInteractionEnabled = data.middleTextEnabled;
    }
    
}

@end


@implementation SCNormalTableViewCell9
- (void)setupSubviewsWithFrame:(CGRect)frame{
    
    CGFloat leftMargin  = 15;
    CGFloat rightMargin = -15;
    
    CGRect tempFrame = frame;
    
    tempFrame.origin = CGPointZero;
    
    tempFrame.size.width = ScreenWidth;
    
    self.contentView.backgroundColor = [SCColor getColor:@"ffffff"];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    DEFINE_WEAK(self);
    
    __weak UIView *tempView = self.contentView;
    
    _leftIcon = [UIImageView new];
    _leftIcon.contentMode = UIViewContentModeScaleAspectFit;
    [tempView addSubview:_leftIcon];
    [_leftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tempView);
        make.left.mas_equalTo(tempView).offset(leftMargin);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    
    _leftTitle = [UILabel new];
    _leftTitle.textAlignment = NSTextAlignmentLeft;
    _leftTitle.font = [Utils fontWithSize:15];
    _leftTitle.textColor = [SCColor getColor:@"333333"];
    [tempView addSubview:_leftTitle];
    [_leftTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tempView);
        make.left.mas_equalTo(_leftIcon.mas_right).offset(leftMargin);
        make.width.mas_lessThanOrEqualTo(90);
        make.height.mas_equalTo(25);
    }];
    
    _rightIcon = [UIImageView new];
    _rightIcon.contentMode = UIViewContentModeScaleAspectFit;
    _rightIcon.image = [UIImage imageNamed:@"real_icon_right"];
    [tempView addSubview:_rightIcon];
    [_rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tempView);
        make.right.mas_equalTo(tempView).offset(-15);
        make.width.mas_equalTo(18);
        make.height.mas_equalTo(18);
    }];
    
    _middleTextField = [UITextField new];
    _middleTextField.textAlignment = NSTextAlignmentRight;
    _middleTextField.font = [Utils fontWithSize:15];
    _middleTextField.textColor = [SCColor getColor:@"999999"];
    _middleTextField.userInteractionEnabled = NO;
    [tempView addSubview:_middleTextField];
    [_middleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tempView);
        make.right.mas_equalTo(_rightIcon.mas_left).offset(-9);
        make.left.mas_equalTo(_leftTitle.mas_right).offset(9);
        make.height.mas_equalTo(25);
    }];
    
    UIView *inputAccessoryView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    inputAccessoryView.backgroundColor = [UIColor clearColor];
    inputAccessoryView.userInteractionEnabled = YES;
    [inputAccessoryView bk_whenTapped:^{
        wself.cellData.middleText = wself.middleTextField.text;
        [wself.middleTextField resignFirstResponder];
    }];
    _middleTextField.inputAccessoryView = inputAccessoryView;
    
    
}

- (void)setData:(SCNormalCellData *)data indexPath:(NSIndexPath*)indexPath{
    
    if ([data isKindOfClass:[SCNormalCellData class]]) {
        _cellData = data;
        
        self.leftIcon.image = [UIImage imageNamed:data.leftIconName];
        self.leftTitle.text = data.leftTitle;
        self.middleTextField.placeholder = data.placeholder;
        self.middleTextField.text = data.middleText;
        self.middleTextField.userInteractionEnabled = data.middleTextEnabled;
        
        if (![Utils isValidStr:self.cellData.rightIconName] || ![Utils isValidStr:self.cellData.rightIconSelectedName]) {
            
            _rightIcon.image = [UIImage imageNamed:[Utils isValidStr:data.rightIconName]?data.rightIconName:@"moments_icon_more"];
        }else{
            
            if (self.isSelected) {
                
                self.rightIcon.image = [UIImage imageNamed:self.cellData.rightIconSelectedName];
                
            }else{
                
                self.rightIcon.image = [UIImage imageNamed:self.cellData.rightIconName];
                
            }
        }
    }
    
}

@end