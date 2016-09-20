//
//  SCBaseViewController.h
//  ShiHua
//
//  Created by yangjian on 14-9-5.
//  Copyright (c) 2014年 shuchuang. All rights reserved.
//

#import <UIKit/UIKit.h>

// 每个ViewController应该继承自这个类
typedef void (^SCNotificationCallback)(NSNotification* note);
typedef void (^SCViewControllerFinishCallback)(NSDictionary* result);

@interface SCBaseViewController : UIViewController {
    struct {
        // 一些标志，表明viewDidLoad子类的方法是否被调用过
        unsigned int viewDidLoadCalled:1;
        unsigned int viewWillAppearCalled:1;
        unsigned int viewDidAppearCalled:1;
        unsigned int viewWillDisappearCalled:1;
        unsigned int viewDidDisappearCalled:1;
    } _flags;
    
}

// 可设置的属性：是否有bottom bar
@property BOOL scHasBottomBar;
STD_PROP SCViewControllerFinishCallback scResultCallback;
STD_PROP NSDictionary* scResult;

// viewDidLoad被调用时frame并没有设置好
@property(readonly) CGRect contentFrame;

// init的时候干点啥, 这个函数被initWithFrame 或者initWithCoder
- (void)customizeWhenInit;
// 最好重载下面的方法去初始化子view,因为viewDidLoad时,self.view.frame可能还不对
- (void) setupSubviews;
// 用户按左上角返回按钮时
- (void) onBack;
// 页面销毁时
- (void) viewDidDismiss;
// 是否应该显示返回按钮
- (BOOL) shouldShowBackButton;
// viewDidLayoutSubviews第一次调用后
- (void) onDidFirstLayout;

// 显示/隐藏子ViewController
- (void) displayChildController: (UIViewController*)child frame:(CGRect)frame inView:(UIView*)view;
- (void) hideChildController: (UIViewController*) child;

// 这个ViewController下次DidAppear的的时候的回调，回调一次之后不再调用
typedef void(^UIViewControllerAppearCallback)();
@property(nonatomic, strong) UIViewControllerAppearCallback scNextTimeDidAppearCallback;

- (void)observerNotification:(NSString*)notificationName callback:(SCNotificationCallback)callback;
// 是否显示返回按钮
- (void) showBackButton:(BOOL)isShow;
@end
