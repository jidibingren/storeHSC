//
//  SCBaseViewController.m
//  ShiHua
//
//  Created by yangjian on 14-9-5.
//  Copyright (c) 2014年 shuchuang. All rights reserved.
//

#import "SCBaseViewController.h"
#ifdef SC_TP_UMANALYTICS
#import "MobClick.h"
#endif

@interface SCBaseViewController () {
    BOOL _didFirstLayout;
    NSMutableArray* _notificationObservers;
}

@end

@implementation SCBaseViewController

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

- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleDefault;
    
}

- (void) viewDidLoad {
    [super viewDidLoad];
    _flags.viewDidLoadCalled = 1;
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    UIColor* bgColor = [SCColor getColor:SC_COLOR_NAV_BG];
    UIColor* textColor = [SCColor getColor:SC_COLOR_NAV_TEXT];
//    UIFont*  textFont  = [UIFont boldSystemFontOfSize:SC_FONT_NAV_TEXT];
    UIFont*  textFont  = [Utils fontWithSize:JY_FONT_NAV_TEXT];
    //navigationBar background
    if (iOS7) {
        self.navigationController.navigationBar.barTintColor = bgColor;
        // textColor
        self.navigationController.navigationBar.tintColor = textColor;
    } else {
        self.navigationController.navigationBar.tintColor = bgColor;
    }
    [self.navigationController.navigationBar setBackgroundImage:[UIImage sc_imageNamed:KSCImageNavibackground] forBarPosition:UIBarPositionTop barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    // title color
    NSDictionary* dic = @{
                          NSFontAttributeName:textFont,
                          NSForegroundColorAttributeName: textColor
                          };
    self.navigationController.navigationBar.titleTextAttributes = dic;
//    self.tabBarController.tabBar.tintColor = [SCColor getColor:SC_COLOR_TABBAR_TINT];

    if (![JY_COLOR_VIEW_BG isEmpty]) {
        self.view.backgroundColor = [SCColor getColor:JY_COLOR_VIEW_BG];
    }

    NSLog(@"%@", NSStringFromCGRect(self.view.frame));
    _contentFrame = self.view.bounds;
    _contentFrame.size.height -= 64;
    
    self.navigationController.interactivePopGestureRecognizer.delegate=(id)self;

}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _contentFrame = self.view.bounds;
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (!_didFirstLayout) {
        _didFirstLayout = YES;
        [self onDidFirstLayout];
    }
}

- (void) onDidFirstLayout {
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    BOOL firstAppear = !_flags.viewWillAppearCalled;
    _flags.viewWillAppearCalled = 1;
    [self customizeBackButton];
    [self customizeTabbar];
    
    if (firstAppear) {
        NSLog(@"%@", NSStringFromCGRect(self.view.frame));
        _contentFrame = self.view.bounds;
        [self setupSubviews];
    }
}

- (BOOL) shouldShowBackButton {
    if (self.scHasBottomBar) {
        return NO;
    }
    return [self.navigationController.viewControllers count] >=2;
}
         
- (void) setupSubviews {
}

- (void) customizeBackButton {
    if ([self shouldShowBackButton]) {
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

- (void) customizeTabbar {
    
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _flags.viewWillDisappearCalled = 1;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _flags.viewDidAppearCalled = 1;
#ifdef SC_TP_UMANALYTICS
    UMENG_STATS_ENTER_VIEW_CONTROLLER();
#endif
    UIViewControllerAppearCallback callback = self.scNextTimeDidAppearCallback;
    if (callback) {
        callback();
        self.scNextTimeDidAppearCallback = nil;
    }
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear: animated];
    _flags.viewDidDisappearCalled = 1;
#ifdef SC_TP_UMANALYTICS
    UMENG_STATS_LEAVE_VIEW_CONTROLLER();
#endif
    if (!self.parentViewController) {
        [self viewDidDismiss];
    }
}

// view已经被销毁，不同于viewWillDisappear, 销毁后此view不再可用
- (void) viewDidDismiss {
    if (self.scResultCallback) {
        self.scResultCallback(self.scResult);
    }
}

// 屏幕左上角back button被点击后触发onBackButtonPressed
- (void) onBackButtonPressed {
    [self onBack];
}

- (void) onBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) dealloc {
    // ios8以前，viewWillDisappear可能不被调用到:
    // http://stackoverflow.com/questions/18128510/viewdiddisappear-not-called
    if (self.isViewLoaded && iOS8_OR_LATER) {
//        NSAssert(_flags.viewDidLoadCalled, NSLocalizedString(@"重写viewDidLoad时没有调用父类方法", nil));
//        NSAssert(_flags.viewWillAppearCalled, NSLocalizedString(@"重写viewWillAppear时没有调用父类方法", nil));
//        NSAssert(_flags.viewDidAppearCalled, NSLocalizedString(@"重写viewDidAppear时没有调用父类方法", nil));
//        NSAssert(_flags.viewWillDisappearCalled, NSLocalizedString(@"重写viewWillDisappear时没有调用父类方法", nil));
//        NSAssert(_flags.viewDidDisappearCalled, NSLocalizedString(@"重写viewDidDisappear时没有调用父类方法", nil));
    }
    
    if (_notificationObservers) {
        for (id observer in _notificationObservers) {
            [[NSNotificationCenter defaultCenter] removeObserver:observer];
        }
        _notificationObservers = nil;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


// https://developer.apple.com/library/ios/featuredarticles/ViewControllerPGforiPhoneOS/CreatingCustomContainerViewControllers/CreatingCustomContainerViewControllers.html 
- (void) displayChildController: (UIViewController*) child frame:(CGRect)frame inView:(UIView *)view
{
    [self addChildViewController:child];                 // 1
    child.view.frame = frame; // 2
    [view addSubview: child.view];
    [child didMoveToParentViewController:self];          // 3
}

- (void) hideChildController: (UIViewController*) child
{
    [child willMoveToParentViewController:nil];  // 1
    [child.view removeFromSuperview];            // 2
    [child removeFromParentViewController];      // 3
}

// http://stackoverflow.com/questions/11532808/viewdidappear-not-getting-called
- (BOOL)automaticallyForwardAppearanceAndRotationMethodsToChildViewControllers
{
    return YES;
}

- (void)observerNotification:(NSString*)notificationName callback:(SCNotificationCallback)callback {
    if (!_notificationObservers) {
        _notificationObservers = [NSMutableArray new];
    }
    id observer = [[NSNotificationCenter defaultCenter] addObserverForName:notificationName object:nil queue:nil usingBlock:^(NSNotification *note) {
        callback(note);
    }];
    [_notificationObservers addObject:observer];
}
@end
