//
//  AppDelegate.m
//  HSChannel
//
//  Created by SC on 16/8/22.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()<EMClientDelegate>
{
    //__block SCUserInfo *userInfo;
}

STD_PROP NSTimer *timer;

@end


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.rootViewController = [[SCRootViewController alloc]initWithType:SCRootControllerDefault];
    
    [self.window makeKeyAndVisible];
    
    EMOptions *options = [EMOptions optionsWithAppkey:EASE_APP_KEY];
    options.isAutoLogin = NO;
    options.isAutoAcceptGroupInvitation = YES;
    options.isAutoAcceptFriendInvitation = YES;
    options.isDeleteMessagesWhenExitGroup = NO;
    options.isDeleteMessagesWhenExitChatRoom = NO;
#if JJ_DEBUG==1
    options.apnsCertName = EASE_CER_NAME_DEVELOP;
#else
    options.apnsCertName = EASE_CER_NAME_PRODUCT;
#endif
    [[EMClient sharedClient] addDelegate:self delegateQueue:dispatch_queue_create("HSC_EMCLIENT", 0)];
    [[EMClient sharedClient] initializeSDKWithOptions:options];
        //iOS8 注册APNS
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge |
        UIUserNotificationTypeSound |
        UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
    
    [self autoLogin];
    
    [self startTimer];
    
    return YES;
}

-(void)autoLogin{
    
    JYAccount *account=[JYAccountTool account];
    if ([Utils isNilOrNSNull:account]) {
        account=[JYAccount new];
    }
    
    NSString *username=account.username;
    NSString *password=account.password;
    //判断是否存在用户名
    username = username ? username : @"18560126362";
    password = password ? password : @"123456";
    if ([Utils isValidStr:username]) {
        
        //如果存在用户名则自动登录
        //设备序列号
        NSUUID *uuid = [[UIDevice currentDevice].identifierForVendor UUIDString];
        //deviceName设备名称
        NSString* deviceName = [[UIDevice currentDevice] systemName];
        //手机系统版本
        NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
        
        phoneVersion=[NSString stringWithFormat:@"%@%@",deviceName,phoneVersion];
        //NSLog(@"手机系统版本: %@%@", deviceName,phoneVersion);
        //手机型号
        NSString* phoneModel = [[UIDevice currentDevice] model];
        NSDictionary *params = @{
                                 @"username" : username,
                                 @"password" : password,
                                 };
        
        [SCHttpTool postWithURL:HSC_URL_USER_LOGIN params:params success:^(NSDictionary *json) {
            
            
            [SCUserInfo sharedInstance].accountInfo = [[SCAccountInfo alloc]initWithDictionary:json[@"info"]];
            
            DCKeyValueObjectMapping *kvm = [DCKeyValueObjectMapping mapperForClass:[SCChildInfo class]];
            [SCUserInfo sharedInstance].children = [kvm parseArray:json[@"children"]];
            
            if ([SCUserInfo sharedInstance].children.count > 0) {
                
                [SCUserInfo sharedInstance].selectedChildren = [SCUserInfo sharedInstance].children[0];
            }
            
            [Utils setLoginToken:json[@"token"]];
            [SCUserInfo sharedInstance].isLogined = YES;
            account.hxAccount = [SCUserInfo sharedInstance].accountInfo.hxAccount;
            account.hxPassword = [SCUserInfo sharedInstance].accountInfo.hxPasswd;
            [JYAccountTool saveAccount:account];
            
            [SCHttpTool requestContactInfo:nil];
            
            [[EMClient sharedClient] asyncLoginWithUsername:account.hxAccount.description password:account.hxPassword.description success:nil failure:^(EMError *aError) {
                NSLog(@"%@",aError);
            }];
        } failure:^(NSError *error) {
            NSLog(error.description);
        }];
        
        
    }
    
    
    NSMutableDictionary *versionParams = [NSMutableDictionary new];
    versionParams[@"typeId"] = @(2);
    versionParams[@"currVersion"] = [Utils getCurrentVersionShort];
    [SCHttpTool postWithURL:HSC_URL_ADMIN_VERSION params:versionParams success:^(NSDictionary *json) {
        
        if ([[json valueForKey:@"isUpdate"] integerValue] == 1) {
            
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"发现新版本" message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:nil];
            [alter bk_addButtonWithTitle:@"更新" handler:^{
                
                NSURL *url = [NSURL URLWithString:json[@"updateUrl"]];
                [[UIApplication sharedApplication] openURL:url];
                
            }];
            
            [alter show];
            
        }
        
    } failure:nil];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [super application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    
    [[EMClient sharedClient] bindDeviceToken:deviceToken];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    if (![EMClient sharedClient].isLoggedIn) {
        
        [self loginEMClient];
        
    }else{
        
        [[EMClient sharedClient] applicationWillEnterForeground:application];
        
    }
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    return YES;
}


- (void)startTimer{
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
}

- (void)handleTimer:(NSTimer*)timer{
    
    DEFINE_WEAK(self);
    [SCHttpTool requestNewMessage];
    
}

#pragma mark -
- (void)didConnectionStateChanged:(EMConnectionState)aConnectionState{
    
    if (![EMClient sharedClient].isLoggedIn) {
        [self loginEMClient];
        return;
    }
    
    if (aConnectionState != EMConnectionConnected) {
        
        [[EMClient sharedClient] applicationWillEnterForeground:[UIApplication sharedApplication]];
    }
    
}

- (void)didAutoLoginWithError:(EMError *)aError{
    
    [self loginEMClient];
    
}

- (void)didLoginFromOtherDevice{
    
    dispatch_main_async_safe(^{
        
        LGAlertView *alertView = [LGAlertView alertViewWithTitle:@"账号在其它设备登录" message:@"是否重新登录" style:LGAlertViewStyleAlert buttonTitles:@[@"确定"] cancelButtonTitle:@"取消" destructiveButtonTitle:nil actionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
            [self loginEMClient];
        } cancelHandler:nil destructiveHandler:nil];
        
        [alertView showAnimated:YES completionHandler:nil];
    });
}

- (void)loginEMClient{
    JYAccount *account=[JYAccountTool account];
    if ([Utils isNilOrNSNull:account]) {
        account=[JYAccount new];
    }
    
    [[EMClient sharedClient] asyncLoginWithUsername:account.hxAccount.description password:account.hxPassword.description success:nil failure:^(EMError *aError) {
        NSLog(@"%@",aError);
    }];
}

@end
