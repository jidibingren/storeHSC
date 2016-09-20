//
//  SCSegmentedViewController.m
//  ShiHua
//
//  Created by Pingan Yi on 9/23/14.
//  Copyright (c) 2014 shuchuang. All rights reserved.
//

#import "SCSegmentedViewController.h"

@interface SCSegmentedViewController () {
    CGRect _childFrame;
    UIViewController* _currentChildController;
}
@end

@implementation SCSegmentedViewController

// override
- (void) setupSubviews {
    [super setupSubviews];
    assert(self.segmentTitles);
    assert(self.segmentChildViewControllers);

    _childFrame = CGRectMake(0, 0, ScreenWidth, self.contentFrame.size.height);
    
    [self initSegmenttedControl];
    
    [self segmentChanged:_segmentedControl];
}

- (void)initSegmenttedControl
{
    assert(self.segmentTitles);
    
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:self.segmentTitles];
    
    _segmentedControl.frame = CGRectMake(0, 4.5, 129, 36);
    _segmentedControl.selectedSegmentIndex = _initialSelection ? _initialSelection:0;
    
    [_segmentedControl setTitleTextAttributes:@{NSFontAttributeName: [Utils boldFontWithSize:20.0],} forState:UIControlStateNormal];
    [_segmentedControl setTitleTextAttributes:@{NSFontAttributeName: [Utils boldFontWithSize:20.0],} forState:UIControlStateSelected];
    [_segmentedControl setTintColor:[SCColor getColor:@"ffffff"]];
    [_segmentedControl setBackgroundColor:[SCColor getColor:SC_COLOR_NAV_BG]];
    [_segmentedControl addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.titleView = _segmentedControl;
}

// override
- (void)segmentChanged:(UISegmentedControl *)segment {
    NSInteger index = segment.selectedSegmentIndex;
    if (_currentChildController)
        [self hideChildController:_currentChildController];
    _currentChildController = _segmentChildViewControllers[index];
    assert(_currentChildController);
    [self displayChildController:_currentChildController frame:_childFrame inView:self.view];
}

@end
