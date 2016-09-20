//
//  HSCCGOperationMenu.m
//  HSChannel
//
//  Created by SC on 16/9/1.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "HSCCGOperationMenu.h"

@implementation HSCCGOperationMenu

- (void)setupUI{
    
    [super setupUI];
    
    self.layer.cornerRadius = 0;
    
    self.backgroundColor = [UIColor clearColor];
    
    self.centerLine.backgroundColor = [SCColor getColor:SC_COLOR_SEPARATOR_LINE];
    
    [self.likeButton setTitleColor:[SCColor getColor:SC_COLOR_TEXT_3] forState:UIControlStateNormal];
    
    [self.likeButton setImage:[UIImage imageNamed:@"moments_icon_like_normal"] forState:UIControlStateNormal];
    
    [self.likeButton setImage:[UIImage imageNamed:@"moments_icon_like_selected"] forState:UIControlStateSelected];
    
    
    [self.commentButton setTitleColor:[SCColor getColor:SC_COLOR_TEXT_3] forState:UIControlStateNormal];
    
    [self.commentButton setImage:[UIImage imageNamed:@"moments_icon_comment"] forState:UIControlStateNormal];
    
    UIView *seperatorLine = [UIView new];
    seperatorLine.backgroundColor = [SCColor getColor:SC_COLOR_SEPARATOR_LINE];
    [self addSubview:seperatorLine];
    [seperatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    
    UIView *seperatorLineBottom = [UIView new];
    seperatorLineBottom.backgroundColor = [SCColor getColor:SC_COLOR_SEPARATOR_LINE];
    [self addSubview:seperatorLineBottom];
    [seperatorLineBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self);
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.height.mas_equalTo(0.5);
    }];

}



-(void)likeButtonClicked{
    
    [super likeButtonClicked];
    
    [self.likeButton setSelected:!self.likeButton.isSelected];
    
}

- (void)setShow:(BOOL)show{

}

- (void)setViewModel:(SCMomentsViewModel *)viewModel{
    
    [super setViewModel:viewModel];
    
    [self.likeButton setTitle:viewModel.likeCount > 0 ? [NSString stringWithFormat:@"(%ld)",viewModel.likeCount] : @"赞" forState:UIControlStateNormal];
    
    [self.commentButton setTitle:viewModel.replyCount > 0 ? [NSString stringWithFormat:@"(%ld)",viewModel.replyCount] : @"回复" forState:UIControlStateNormal];
    
}

@end
