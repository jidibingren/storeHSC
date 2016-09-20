//
//  HSCCGMomentsOriginalView.m
//  HSChannel
//
//  Created by SC on 16/9/2.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "HSCCGMomentsOriginalView.h"

@implementation HSCCGMomentsOriginalView

- (void)setupUI{
    
    [super setupUI];
    
    self.iconView.layer.cornerRadius = 20;
    self.iconView.layer.masksToBounds = YES;
    
    DEFINE_WEAK(self);
    
    void( ^ right1ItemCallback )(NSUInteger index, id info)  = ^(NSUInteger index, id info){
        
        switch (index) {
            case 0:
                
                if (wself.delegate && [wself.delegate respondsToSelector:@selector(didClickDeleteButton:)]) {
                    [wself.delegate didClickDeleteButton:wself];
                }
                
                break;
            
                
            default:
                
                break;
        }
    };
    
    DTKDropdownItem *dropItem1 = [DTKDropdownItem itemWithTitle:@"删除" callBack:right1ItemCallback];
    DTKDropdownItem *dropItem2 = [DTKDropdownItem itemWithTitle:@"取消" callBack:right1ItemCallback];
    
    NSArray *dropItems = @[dropItem1, dropItem2];
    
    _dropdownMenu = [DTKDropdownMenuView dropdownMenuViewWithType:dropDownTypeSelfRight frame:CGRectMake(0, 0, 60, 20) dropdownItems:dropItems icon:@"icon_select_down"];
    _dropdownMenu.textFont = [Utils fontWithSize:SC_FONT_3];
    _dropdownMenu.textColor = [SCColor getColor:SC_COLOR_TEXT_2];
    _dropdownMenu.cellSeparatorColor = [SCColor getColor:SC_COLOR_SEPARATOR_LINE];
    _dropdownMenu.cellHeight = 44;
    _dropdownMenu.dropWidth = 100;
    _dropdownMenu.topArrowOffset = 10;
    _dropdownMenu.textAlignment = NSTextAlignmentCenter;
    _dropdownMenu.cellSeparatorEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    
    [self addSubview:_dropdownMenu];
    [_dropdownMenu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(wself.iconView);
        make.right.mas_equalTo(wself).offset(-20);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
}

- (void)setViewModel:(SCMomentsViewModel *)viewModel{
    
    [super setViewModel:viewModel];
    
    [self.dropdownMenu setHidden:!viewModel.isShowAddition];
    
}

@end
