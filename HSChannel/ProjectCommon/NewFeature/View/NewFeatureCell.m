//
//  NewFeatureCell.m
//  StudentBusiness
//
//  Created by wangliang on 16/4/5.
//  Copyright © 2016年 com.jinyouapp. All rights reserved.
//

#import "NewFeatureCell.h"
#import "JYRootVCSelectionTool.h"

@interface NewFeatureCell ()

@property (nonatomic, weak) UIButton *startButton;

@end

@implementation NewFeatureCell
- (UIButton *)startButton {
    
    if (_startButton == nil) {
        
        UIButton *tempStartButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        // 设置图片
        [tempStartButton setImage:[UIImage sc_imageNamed:KSCImageNewFeatureCellStartButtonNormal]
                         forState:UIControlStateNormal];
        [tempStartButton setImage:[UIImage sc_imageNamed:KSCImageNewFeatureCellStartButtonPressed]
                         forState:UIControlStateHighlighted];
        
        // 尺寸自适应
        [tempStartButton sizeToFit];
        
        // 添加点击事件
        [tempStartButton addTarget:self
                            action:@selector(startJD:)
                  forControlEvents:UIControlEventTouchUpInside];
        
        
        [self addSubview:tempStartButton];
        
        _startButton = tempStartButton;
    }
    
    return _startButton;
}

#pragma mark - 获取当前页码和最后一页的页码,判断是否显示按钮
- (void)setCurrentPageIndex:(NSInteger)currentIndex lastPageIndex:(NSInteger)lastIndex {
    
    if (currentIndex == lastIndex) { // 如果是最后一页就显示button
        
        self.startButton.hidden = NO;
        
    } else {
        
        self.startButton.hidden = YES;
    }
}

#pragma mark  - 点击开始按钮时调用
- (void)startJD:(UIButton *)button {
    
    // 根据授权与否选择窗口根控制器
    [JYRootVCSelectionTool setRootViewControllerForWindow:JYKeyWindow];
}

#pragma mark - 布局子控件
- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 设置开始按钮中心
    self.startButton.bounds=CGRectMake(0, 0, 120, 40);
    self.startButton.center = CGPointMake(self.width * 0.5, self.height * 0.9);
    
}

@end
