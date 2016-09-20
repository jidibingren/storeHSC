//
//  SCHttpTool.h
//  ShiHua
//
//  Created by 工作 on 14-7-29.
//  Copyright (c) 2014年 shuchuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#ifdef SC_TP_AFNETWORKING
#import "AFNetworking.h"

// 网络请求相关的库
typedef void(^SCSessionExpiredCallback)();

extern NSSet *noTokenUrlsSet;

@interface SCHttpTool : NSObject

/**
 *  发送一个GET请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(NSDictionary* json))success failure:(void (^)(NSError *error))failure;

/**
 *  发送一个POST请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(NSDictionary* json))success failure:(void (^)(NSError *error))failure;


+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(NSDictionary* json))success failure:(void (^)(NSError *error))failure withProgress:(UIView*)view;

+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(NSDictionary* json))success failure:(void (^)(NSError *error))failure withProgress:(UIView*)view;

+ (void)requestWithURL:(NSString *)url
            method:(NSString*)method
            params:(NSDictionary *)params
            constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
            success:(void (^)(NSDictionary*))success
            failure:(void (^)(NSError *))failure
            withProgress:(UIView *)view
            progressText:(NSString*)progressText;
            

// 设置成退出状态
+ (void) setLoggedOutStatus;

+ (void) uploadImageWithUrl:(NSString *)url params:(NSDictionary *)params data:(NSData *)data fileName:(NSString*)fileName success:(void (^)(id response))success withinView:(UIView *)view progressText:(NSString *)progressText;

+ (void) uploadImageWithUrl:(NSString *)url params:(NSDictionary *)params images:(NSArray *)images fileNames:(NSArray*)fileNames success:(void (^)(id response))success withinView:(UIView *)view progressText:(NSString *)progressText;

+ (void) uploadImageWithUrl:(NSString *)url params:(NSDictionary *)params images:(NSArray *)images fileNames:(NSArray*)fileNames success:(void (^)(id response))success withinView:(UIView *)view;

@end
#endif
