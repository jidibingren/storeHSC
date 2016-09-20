//
//  SCObserver.h
//  FindAFitting
//
//  Created by SC on 16/5/8.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#ifdef SC_TP_KVO_CONTROLLER
#import <KVOController/KVOController.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^SCKVONotificationBlock)(id _Nullable observer, id  object, id  change);

typedef void (^SCKVONotificationBlock2)(id _Nullable observer, id  object, id  newValue, id  oldValue);

@interface SCObserver : FBKVOController

- (void)observe:(nullable id)object keyPath:(NSString *)keyPath blockForNew:(SCKVONotificationBlock)block;

- (void)observe:(nullable id)object keyPath:(NSString *)keyPath blockForOld:(SCKVONotificationBlock)block;

- (void)observe:(nullable id)object keyPath:(NSString *)keyPath blockForNewOld:(SCKVONotificationBlock2)block;

- (void)observe:(nullable id)object keyPath:(NSString *)keyPath blockForInitial:(SCKVONotificationBlock2)block;

- (void)observe:(nullable id)object keyPath:(NSString *)keyPath blockForPrior:(SCKVONotificationBlock2)block;

@end
NS_ASSUME_NONNULL_END
#endif
