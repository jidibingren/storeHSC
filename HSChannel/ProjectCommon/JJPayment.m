//
//  JJPayment.m
//  JJ56
//
//  Created by SC on 16/7/26.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "JJPayment.h"

@interface JJPayment (){
    __weak JJPayment *wself ;
}

@end

@implementation JJPayment

IMPLEMENT_SINGLETON();

- (instancetype)init{
    
    if (self = [super init]) {
        wself = self;
        self.appScheme = @"";
    }
    
    return self;
}

- (BOOL)handleOpenURL:(NSURL *)url{
    
#ifdef SDJY_PING_PLUS_PLUS
    
    return [Pingpp handleOpenURL:url withCompletion:^(NSString *result, PingppError *error) {
        
        if (wself.callback) {
            wself.callback([wself payResultByStr:result], nil);
        }
    }];
    
#else
    return NO;
#endif
}

- (void)createPayment:(NSObject *)charge viewController:(UIViewController*)viewController callback:(JJPayCallback)callback{
#ifdef SDJY_PING_PLUS_PLUS
    self.callback = callback;
    
    [Pingpp createPayment:charge appURLScheme:self.appScheme withCompletion:^(NSString *result, PingppError *error) {
        
        if (callback) {
            callback([wself payResultByStr:result], nil);
        }
        
    }];
#else
    
#endif
    
}

- (void)recharge:(CGFloat)amount type:(JJPayType)type viewController:(UIViewController*)viewController callback:(JJPayCallback)callback{
    
}

#pragma mark - private

- (JJPaymentResult)payResultByStr:(NSString *)str{
    JJPaymentResult result = JJPaymentResultFailed;
    
    return result;
}

@end
