//
//  SCAppDelegateBase.m
//  ShiHua
//
//  Created by yangjian on 14-9-5.
//  Copyright (c) 2014年 shuchuang. All rights reserved.
//

#import "SCAppDelegateBase.h"
#ifdef SC_TP_UMANALYTICS
#import "MobClick.h"
#endif
#ifdef SC_TP_UMESSAGE
#import "UMessage.h"
#endif
#ifdef SC_TP_UMSOCIAL
#import "UMSocial.h"
#endif
#ifdef SC_TP_UMSOCIAL_EXTRA
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
//#import "UMSocialYiXinHandler.h"
#endif


@implementation SCAppDelegateBase

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setupCrashReport];
#ifdef SC_TP_UMANALYTICS
    [MobClick startWithAppkey:UMENG_APP_KEY reportPolicy:BATCH channelId:UMENG_CHANNEL];
//    [MobClick updateOnlineConfig];
#endif
#ifdef SC_TP_UMESSAGE
    [UMessage startWithAppkey:UMENG_APP_KEY launchOptions:launchOptions];
#endif
    
#ifdef SC_TP_UMSOCIAL
    [UMSocialData setAppKey:UMENG_APP_KEY];
#endif
#ifdef SC_TP_UMSOCIAL_EXTRA
    [UMSocialWechatHandler setWXAppId:UMENG_SHARE_WX_APPID appSecret:UMENG_SHARE_WX_SECRET url:UMENG_SHARE_URL];
    [UMSocialQQHandler setQQWithAppId:UMENG_SHARE_QQ_APPID appKey:UMENG_SHARE_QQ_APPKEY url:UMENG_SHARE_URL];
#endif
    
    [Utils setupUserAgent];
#ifdef SC_TP_UMESSAGE
    [UMessage setLogEnabled:YES];
#endif
    return YES;
}
//获取到设备的Device Token
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"My device token is: %@",deviceToken);
    NSString *token = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""];
    NSLog(@"%@", token);
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
#ifdef SC_TP_UMESSAGE
    [UMessage registerDeviceToken:deviceToken];
#endif
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    
    NSLog(NSLocalizedString(@"apns -> 注册推送功能时发生错误， 错误信息:\n %@", nil), error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
#ifdef SC_TP_UMESSAGE
    [UMessage didReceiveRemoteNotification:userInfo];
#endif
}

//返回网络错误
- (void)onGetNetworkState:(int)iError
{
    NSLog(@"onGetNetworkState: %d",iError);
}
//返回验证错误
- (void)onGetPermissionState:(int)iError
{
    NSLog(@"onGetPermissionState: %d",iError);
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
#ifdef SC_TP_UMSOCIAL
    return  [UMSocialSnsService handleOpenURL:url];
#else
    return NO;
#endif
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
#ifdef SC_TP_UMSOCIAL
    return  [UMSocialSnsService handleOpenURL:url];
#else
    return NO;
#endif
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void) setupCrashReport {
    NSString* crashReportComponent = !BUGLY_APP_ID.isEmpty ? @"bugly" : @"umeng";

//    Umeng online config seems don't work
//    NSString* param = [MobClick getConfigParams:@"crash_reporter"];
//    if (param && !param.isEmpty) {
//        crashReportComponent = param;
//    }
//    [[NSNotificationCenter defaultCenter] addObserverForName:UMOnlineConfigDidFinishedNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
//        NSLog(@"%@", [MobClick getConfigParams]);
//    }];
#ifdef SC_TP_BUGLY
    if ([crashReportComponent isEqualToString:@"bugly"]) {
#if _DEBUG
        [[CrashReporter sharedInstance] enableLog:YES];
#endif
        [[CrashReporter sharedInstance] installWithAppId:BUGLY_APP_ID];
    } else {
//        [[CrashReporter sharedInstance] uninstall];
    }
#endif
    // 初始化UMENG 统计,推送,自动更新,分享
#ifdef SC_TP_UMANALYTICS
    [MobClick setCrashReportEnabled:[crashReportComponent isEqualToString:@"umeng"]];
#if _DEBUG
    [MobClick setLogEnabled:YES];
#endif
#endif
}

@end
