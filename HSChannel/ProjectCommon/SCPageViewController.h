//
//  SCPageViewController.h
//  JJ56
//
//  Created by SC on 16/7/15.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import <WMPageController/WMPageController.h>

@interface SCPageViewController : WMPageController

@property BOOL scHasBottomBar;

@property (nonatomic, strong)NSMutableArray *badgeViews;

- (void)setupPageControllerBefore;

- (void)setupPageControllerAfter;

@end
