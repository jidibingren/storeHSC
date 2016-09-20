//
//  SCSegmentedViewController.h
//  ShiHua
//
//  Created by Pingan Yi on 9/23/14.
//  Copyright (c) 2014 shuchuang. All rights reserved.
//

// 对UISegmentedControl的简单包装
@interface SCSegmentedViewController : SCBaseViewController

@property (nonatomic, strong) UISegmentedControl* segmentedControl;
// array of NSString
@property (nonatomic, strong) NSArray* segmentTitles;
// array of UIViewController
@property (nonatomic, strong) NSArray* segmentChildViewControllers;
@property (nonatomic, strong) NSString * navTitle;

// 可选属性
@property (nonatomic) int initialSelection;

- (void)initSegmenttedControl;

@end
