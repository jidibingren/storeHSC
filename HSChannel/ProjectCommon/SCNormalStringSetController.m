//
//  SCNormalStringSetController.m
//  HSChannel
//
//  Created by SC on 16/9/3.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "SCNormalStringSetController.h"

@interface SCNormalStringSetController ()

@property (nonatomic, strong)TPKeyboardAvoidingScrollView *scrollView;

@end

@implementation SCNormalStringSetController

- (instancetype)initWithTitle:(NSString *)title{
    
    if (self = [super init]) {
        self.title = title;
    }
    
    return self;
    
}

- (void)setupSubviews{
    
    [self setupScrollView];
    
}

- (void)setupScrollView{
    CGFloat leftMargin = 15;
    CGFloat rightMargin = -15;
    
    DEFINE_WEAK(self);
    self.view.backgroundColor = [SCColor getColor:@"eeeeec"];
    
    _scrollView = [[TPKeyboardAvoidingScrollView alloc]initWithFrame:CGRectZero];
    _scrollView.scrollEnabled = YES;
    _scrollView.backgroundColor = [SCColor getColor:@"fefefc"];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    _scrollView.showsVerticalScrollIndicator = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(1);
        make.bottom.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
    }];
    
    UIView *contentView = [UIView new];
    contentView.backgroundColor = [SCColor getColor:@"ffffff"];
    [_scrollView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_scrollView);
        make.left.mas_equalTo(_scrollView);
        make.bottom.mas_equalTo(_scrollView);
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_greaterThanOrEqualTo(ScreenHeight-64);
    }];
    
    SZTextView *textView = [SZTextView new];
    textView.textColor = [SCColor getColor:@"999999"];
    textView.font = [Utils fontWithSize:15];
    textView.layer.cornerRadius = 2.5;
    textView.layer.borderWidth = 1;
    textView.layer.borderColor = [SCColor getColor:@"e2e2e2"].CGColor;
    [contentView addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(contentView).offset(10);
        make.left.mas_equalTo(contentView).offset(leftMargin);
        make.right.mas_equalTo(contentView).offset(rightMargin);
        make.height.mas_equalTo(150);
    }];
    
    UIView *inputAccessoryView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    inputAccessoryView.userInteractionEnabled = YES;
    [inputAccessoryView bk_whenTapped:^{
        [wself.contentTextView resignFirstResponder];
    }];
    inputAccessoryView.backgroundColor = [UIColor clearColor];
    textView.inputAccessoryView = inputAccessoryView;
    textView.placeholder = [NSString stringWithFormat:@"请输入%@",self.title];
    _contentTextView = textView;
    
    UIButton *confirmBtn = [UIButton new];
    confirmBtn.layer.cornerRadius = 5;
    confirmBtn.layer.masksToBounds = YES;
    confirmBtn.backgroundColor = [SCColor getColor:@"1bca7f"];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[SCColor getColor:@"ffffff"] forState:UIControlStateNormal];
    [contentView addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(textView.mas_bottom).offset(24);
        make.left.mas_equalTo(contentView).offset(leftMargin);
        make.right.mas_equalTo(contentView).offset(rightMargin);
        make.height.mas_equalTo(58);
    }];
    
    self.confirmBtn = confirmBtn;
    
    [confirmBtn bk_whenTapped:^{
        
        if (wself.callback) {
            wself.callback(wself.contentTextView.text);
        }
        
        [wself.navigationController popViewControllerAnimated:YES];
        
    }];
}
@end
