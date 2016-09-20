//
//  SCObserver.m
//  FindAFitting
//
//  Created by SC on 16/5/8.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#ifdef SC_TP_KVO_CONTROLLER

#import "SCObserver.h"

@implementation SCObserver


- (void)observe:(nullable id)object keyPath:(NSString *)keyPath blockForNew:(SCKVONotificationBlock)block{
    
    [self observe:object keyPath:keyPath options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        
        block(observer, object, [change valueForKey:@"new"]);
        
    }];
    
}

- (void)observe:(nullable id)object keyPath:(NSString *)keyPath blockForOld:(SCKVONotificationBlock)block{
    
    [self observe:object keyPath:keyPath options:NSKeyValueObservingOptionOld block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        
        block(observer, object, [change valueForKey:@"old"]);
        
    }];
    
}

- (void)observe:(nullable id)object keyPath:(NSString *)keyPath blockForNewOld:(SCKVONotificationBlock2)block{
    
    [self observe:object keyPath:keyPath options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        
        block(observer, object, [change valueForKey:@"new"], [change valueForKey:@"old"]);
        
    }];
    
}

- (void)observe:(nullable id)object keyPath:(NSString *)keyPath blockForInitial:(SCKVONotificationBlock2)block{
    
    [self observe:object keyPath:keyPath options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        
        block(observer, object, [change valueForKey:@"new"], [change valueForKey:@"old"]);
        
    }];
    
}

- (void)observe:(nullable id)object keyPath:(NSString *)keyPath blockForPrior:(SCKVONotificationBlock2)block{
    
    [self observe:object keyPath:keyPath options:NSKeyValueObservingOptionPrior | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        
        block(observer, object, [change valueForKey:@"new"], [change valueForKey:@"old"]);
        
    }];
    
}

@end

#endif
