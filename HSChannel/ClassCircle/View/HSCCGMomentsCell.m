//
//  HSCCGMomentsCell.m
//  HSChannel
//
//  Created by SC on 16/9/1.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "HSCCGMomentsCell.h"

@implementation HSCCGMomentsCell

- (void)setupUI{
    
    self.operationMenuClass = [HSCCGOperationMenu class];
    
    self.originalViewClass = [HSCCGMomentsOriginalView class];

    self.dividerColor = [SCColor getColor:@"f4f4f4"];
    
    [super setupUI];
    
    [self.commentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.operationMenu.mas_bottom).offset(0);
        make.left.equalTo(self.contentView.mas_left).offset(10);
    }];
    
}

@end
