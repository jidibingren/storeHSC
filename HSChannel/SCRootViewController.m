//
//  SCRootViewController.m
//  JJ56
//
//  Created by SC on 16/5/20.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "SCRootViewController.h"

static SCRootViewController *rootVCDefault = nil;
static SCRootViewController *rootVCType1 = nil;
static SCRootViewController *rootVCType2 = nil;

@interface SCPlusButton : CYLPlusButton<CYLPlusButtonSubclassing>

@end

@implementation SCPlusButton

#pragma mark - CYLPlusButtonSubclassing

+ (id)plusButton{
    
    SCPlusButton *button = [[SCPlusButton alloc]initWithFrame:CGRectMake(0, 0, 70, 70)];
    
    button.backgroundColor = [UIColor clearColor];
    
    [button setBackgroundImage:[UIImage imageNamed:@"source_icon_center"] forState:UIControlStateNormal];
    
    return button;
    
}

+ (NSUInteger)indexOfPlusButtonInTabBar{
    
    return 2;
    
}

+ (UIViewController *)plusChildViewController{
    
    return [SCBaseViewController new];
    
}

@end


@interface SCPlusButton2 : CYLPlusButton<CYLPlusButtonSubclassing>

@end

@implementation SCPlusButton2

#pragma mark - CYLPlusButtonSubclassing

+ (id)plusButton{
    
    SCPlusButton2 *button = [[SCPlusButton2 alloc]initWithFrame:CGRectMake(0, 0, 70, 70)];
    
    button.backgroundColor = [UIColor clearColor];
    
    [button setBackgroundImage:[UIImage imageNamed:@"source_icon_center"] forState:UIControlStateNormal];
    
    return button;
    
}

+ (NSUInteger)indexOfPlusButtonInTabBar{
    
    return 2;
    
}

+ (UIViewController *)plusChildViewController{
    
    return [SCBaseViewController new];
    
}

@end

@interface SCRootViewController ()

@end

@implementation SCRootViewController

+ (void)setRootControllerByType:(SCRootControllerType)type{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        rootVCDefault = [[SCRootViewController alloc] initWithType:SCRootControllerDefault];
        rootVCType1 = [[SCRootViewController alloc] initWithType:SCRootControllerType1];
        rootVCType2 = [[SCRootViewController alloc] initWithType:SCRootControllerType2];
    });
    
    dispatch_main_async_safe(^{
        UIWindow *window = [Utils getDefaultWindow];
        window.rootViewController = [SCRootViewController getRootControllerByType:type];
    });
    
}

+ (void)resetRootController{
    
    dispatch_main_async_safe(^{
        UIWindow *window = [Utils getDefaultWindow];
        window.rootViewController = [[SCRootViewController alloc]init];
    });
    
}

+ (SCRootViewController*)getRootControllerByType:(SCRootControllerType)type{
    
    SCRootViewController *temp = nil;
    
    switch (type) {
        case SCRootControllerDefault:
            temp = rootVCDefault;
            break;
        case SCRootControllerType1:
            temp = rootVCType1;
            break;
        case SCRootControllerType2:
            temp = rootVCType2;
            break;
            
        default:
            break;
    }
    
    return temp;
    
}

- (instancetype)initWithType:(SCRootControllerType)type{
    
//    [SCPlusButton registerSubclass];
    
//    self.tabBarHeight = 100;
    self.type = type;
    
    if (self = [super init]) {
        
        [self customWithType:type];
        
    }
    
    return self;
    
}

- (instancetype)init{
    
    
    if (self = [super init]) {
        
        [self customWithType:SCRootControllerDefault];
        
    }
    
    return self;
    
}

- (void)viewDidLoad{

    [super viewDidLoad];
    
}

- (void)customWithType:(SCRootControllerType)type{
    
    NSString *boundleId = [[NSBundle mainBundle] bundleIdentifier];
    
    NSMutableArray *tabBarItemsAttributes = [NSMutableArray new];
    NSArray *viewControllers = nil;
    
    NSArray *titles = [SCProjects sharedInstance].currentProject.tabbarTitles;
    
    NSArray *normalImages = [SCProjects sharedInstance].currentProject.tabbarNormalimages;
    
    NSArray *selectImages = [SCProjects sharedInstance].currentProject.tabbarSelectedimages;
    
    for (NSInteger i = 0; i < titles.count; i++) {
        NSDictionary *dict = @{
                                CYLTabBarItemTitle : titles[i],
                                CYLTabBarItemImage : normalImages[i],
                                CYLTabBarItemSelectedImage : selectImages[i],
                                };
        [tabBarItemsAttributes addObject:dict];
    }
    
    
    UINavigationController *navi1 = [[UINavigationController alloc]initWithRootViewController:[HSCHomepageController new]];
    UINavigationController *navi2  = [[UINavigationController alloc]initWithRootViewController:[HSCSchoolController new]];
    UINavigationController *navi3  = [[UINavigationController alloc]initWithRootViewController:[HSCClassCircleController new]];
    UINavigationController *navi4 = [[UINavigationController alloc]initWithRootViewController:[HSCClassroomController new]];
    UINavigationController *navi5 = [[UINavigationController alloc]initWithRootViewController:[HSCMineController new]];
    
    
    if ([SCProjects sharedInstance].currentProject.type == SCProjectShuXiangYuan) {
        
        viewControllers = @[
                            navi1,
                            navi2,
                            navi3,
                            navi4,
                            navi5
                            ];
    }else {
        
        viewControllers = @[
                            navi1,
                            navi2,
                            navi3,
                            navi5
                            ];
    }
    
    
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = [SCColor getColor:SC_COLOR_TABBAR_TITLE_NORMAL];
    
    // set the text color for selected state
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = [SCColor getColor:SC_COLOR_TABBAR_TITLE_SELECTED];
    
    // set the text Attributes
    // 设置文字属性
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    self.tabBarItemsAttributes = tabBarItemsAttributes;
    
    [self setViewControllers:viewControllers];
    
}

@end
