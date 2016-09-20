//
//  SCNormalStringSetController.h
//  HSChannel
//
//  Created by SC on 16/9/3.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "SCBaseViewController.h"

@interface SCNormalStringSetController : SCBaseViewController

@property (nonatomic, strong)SZTextView         *contentTextView;

@property (nonatomic, strong)UIButton           *confirmBtn;

@property (nonatomic, strong) void(^callback)(NSString *value);

- (instancetype)initWithTitle:(NSString *)title;

@end
