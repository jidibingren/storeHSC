//
//  NSObject+SCObserver.h
//  FindAFitting
//
//  Created by SC on 16/5/8.
//  Copyright © 2016年 SDJY. All rights reserved.
//
#ifdef SC_TP_KVO_CONTROLLER
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface NSObject (SCObserver)

@property (nonatomic, strong) SCObserver *observer;
@property (nonatomic, strong) SCObserver *observerNonRetaining;

@end
NS_ASSUME_NONNULL_END
#endif
