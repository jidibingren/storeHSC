//
//  SCPageViewController.m
//  JJ56
//
//  Created by SC on 16/7/15.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "SCPageViewController.h"

@interface SCPageViewController ()

@end

@implementation SCPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self customizeWhenInit];
        [self afterCustomizeWhenInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self= [super initWithCoder:aDecoder];
    if (self) {
        [self customizeWhenInit];
        [self afterCustomizeWhenInit];
    }
    return  self;
}

- (void)customizeWhenInit {
    
}

- (void)afterCustomizeWhenInit {
    if (!self.scHasBottomBar) {
        self.hidesBottomBarWhenPushed = YES;
    }
}

- (void) customizeBackButton {
    if (self.navigationController.viewControllers.count >= 2) {
        // not home page
        // 设置backBar没有文字
        [self showBackButton:YES];
    }
}

- (void) showBackButton:(BOOL)isShow{
//    if (isShow && self.navigationItem.leftBarButtonItem == nil) {
//        DEFINE_WEAK(self);
//#ifdef SC_TP_BLOCKSKIT
//        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"search_icon_back"] style:UIBarButtonItemStylePlain handler:^(id sender) {
//            [wself performSelector:@selector(onBackButtonPressed)];
//        }];
//        self.navigationItem.leftBarButtonItem = backButtonItem;
//#endif
//    }else if (isShow == NO){
//        self.navigationItem.leftBarButtonItem = nil;
//        self.navigationItem.hidesBackButton = YES;
//    }
}

- (void)onBackButtonPressed{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self customizeBackButton];
    
}

- (void)viewDidLoad {
    
    [self setupPageControllerBefore];
    
    [super viewDidLoad];
    
    [self setupPageControllerAfter];
    
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;
    
    UIColor* bgColor = [SCColor getColor:SC_COLOR_NAV_BG];
    UIColor* textColor = [SCColor getColor:SC_COLOR_NAV_TEXT];
    
    UIFont*  textFont  = [Utils fontWithSize:JY_FONT_NAV_TEXT];
    //navigationBar background
    if (iOS7) {
        self.navigationController.navigationBar.barTintColor = bgColor;
        // textColor
        self.navigationController.navigationBar.tintColor = textColor;
    } else {
        self.navigationController.navigationBar.tintColor = bgColor;
    }
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navibackground"] forBarPosition:UIBarPositionTop barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    // title color
    NSDictionary* dic = @{
                          NSFontAttributeName:textFont,
                          NSForegroundColorAttributeName: textColor
                          };
    self.navigationController.navigationBar.titleTextAttributes = dic;
    
    if (![JY_COLOR_VIEW_BG isEmpty]) {
        self.view.backgroundColor = [SCColor getColor:JY_COLOR_VIEW_BG];
    }
}

- (void)setupPageControllerBefore{
    
    self.viewFrame = CGRectMake(0, 2, ScreenWidth, ScreenHeight - 64 - 2);
    
    self.titles = @[@"", @"", @""];
    
    self.viewControllerClasses = @[[SCBaseViewController class], [SCBaseViewController class], [SCBaseViewController class]];
    // 下划线
    self.menuItemWidth = ScreenWidth/3;
    self.postNotification = YES;
    self.bounces = YES;
    self.title = @"";
    self.menuViewStyle = WMMenuViewStyleLine;
    self.titleSizeSelected = 15;
    self.titleColorSelected = [SCColor getColor:@"1bca7f"];
    self.titleColorNormal = [SCColor getColor:@"999999"];
    self.titleSizeSelected = 17;
    self.titleSizeNormal = 17;
    self.menuHeight = 45;
    self.menuBGColor = [SCColor getColor:@"ffffff"];
    //    self.menuViewBottom = 0.5;
    self.progressHeight = 1;
    
    self.delegate = self;
    
    self.badgeViews = [NSMutableArray new];
}

- (void)setupPageControllerAfter{
    
    UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.menuHeight-0.5, ScreenWidth, 0.5)];
    
    bottomLine.backgroundColor = [SCColor getColor:@"ebebeb"];
    
    [self.menuView addSubview:bottomLine];
    
    self.selectIndex = 0;
    
}

#pragma mark - WMMenuViewDataSource
- (UIView *)menuView:(WMMenuView *)menu badgeViewAtIndex:(NSInteger)index{
    
    return [self badgeViewByIndex:index];
    
}

#pragma mark - private

- (UIView *)badgeViewByIndex:(NSInteger)index{
    
    if (self.badgeViews.count <= index) {
        CGRect frame = [NSString stringFrame:self.titles[index] font:self.titleSizeNormal size:CGSizeMake(self.menuItemWidth, self.menuHeight)];
        UILabel *badgeView = [[UILabel alloc]initWithFrame:CGRectMake((self.menuItemWidth+frame.size.width)/2, MAX((self.menuHeight-frame.size.height)/2-20/3, 2), 20, 20)];
        badgeView.backgroundColor = [UIColor redColor];
        badgeView.layer.cornerRadius = badgeView.height/2;
        badgeView.layer.masksToBounds = YES;
        badgeView.textColor = [UIColor whiteColor];
        badgeView.textAlignment = NSTextAlignmentCenter;
        badgeView.font = [Utils fontWithSize:11];
        badgeView.text = @"";
        [badgeView setHidden:YES];
        [self.observer observe:badgeView keyPath:@"text" blockForNew:^(id  _Nullable observer, UILabel*  _Nonnull object, NSString*  _Nonnull change) {
            object.text = change;
            if (object.text.integerValue > 0) {
                if (object.text.integerValue > 99) {
                    object.text = @"99+";
                }
                [object setHidden:NO];
            }else{
                [object setHidden:YES];
            }
        }];
        [self.badgeViews addObject:badgeView];
    }
    
    return self.badgeViews[index];
}

@end
