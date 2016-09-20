//
//  JJPayment.h
//  JJ56
//
//  Created by SC on 16/7/26.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, JJPayType) {
    JJPayTypeAP = 0,
    JJPayTypeWP = 1,
    JJPayTypeUP = 2,
};

// 支付结果
typedef NS_ENUM(NSInteger, JJPaymentResult) {
    JJPaymentResultOK = 0,
    JJPaymentResultFailed,
    JJPaymentResultCanceled
};

typedef void (^JJPayCallback)(NSInteger status, NSDictionary* dict);

@interface JJPayment : NSObject

@property (nonatomic, strong)NSString *appScheme;

@property (nonatomic, strong)JJPayCallback callback;

DECLARE_SINGLETON();

- (BOOL)handleOpenURL:(NSURL *)url;

- (void)createPayment:(NSObject *)charge viewController:(UIViewController*)viewController callback:(JJPayCallback)callback;

- (void)recharge:(CGFloat)amount type:(JJPayType)type viewController:(UIViewController*)viewController callback:(JJPayCallback)callback;

@end
