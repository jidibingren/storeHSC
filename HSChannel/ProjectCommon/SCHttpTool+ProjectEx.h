//
//  SCHttpTool+JJ56.h
//  JJ56
//
//  Created by SC on 16/6/5.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "SCHttpTool.h"


@interface SCHttpTool (ProjectEx)

+ (void)requestUserInfo;

+ (void)requestContactInfo:(void(^)(NSDictionary *json))callback;

+ (void) uploadImageWithUrl:(NSString *)url data:(NSData *)data success:(void (^)(id response))success withinView:(UIView *)view progressText:(NSString *)progressText;

+ (void)requestNewMessage;

@end
