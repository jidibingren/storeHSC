//
//  NSObject+SCObserver.m
//  FindAFitting
//
//  Created by SC on 16/5/8.
//  Copyright © 2016年 SDJY. All rights reserved.
//
#ifdef SC_TP_KVO_CONTROLLER
#import "NSObject+SCObserver.h"

#import <libkern/OSAtomic.h>
#import <objc/message.h>

#if !__has_feature(objc_arc)
#error This file must be compiled with ARC. Convert your project to ARC or specify the -fobjc-arc flag.
#endif

#pragma mark NSObject Category -

NS_ASSUME_NONNULL_BEGIN

static void *NSObjectSCKVOObserverKey = &NSObjectSCKVOObserverKey;
static void *NSObjectSCKVOObserverNonRetainingKey = &NSObjectSCKVOObserverNonRetainingKey;

@implementation NSObject (SCObserver)

- (SCObserver *)observer
{
    id controller = objc_getAssociatedObject(self, NSObjectSCKVOObserverKey);
    
    // lazily create the KVOController
    if (nil == controller) {
        controller = [SCObserver controllerWithObserver:self];
        self.observer = controller;
    }
    
    return controller;
}

- (void)setObserver:(SCObserver *)observer
{
    objc_setAssociatedObject(self, NSObjectSCKVOObserverKey, observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SCObserver *)observerNonRetaining
{
    id controller = objc_getAssociatedObject(self, NSObjectSCKVOObserverNonRetainingKey);
    
    if (nil == controller) {
        controller = [[SCObserver alloc] initWithObserver:self retainObserved:NO];
        self.KVOControllerNonRetaining = controller;
    }
    
    return controller;
}

- (void)setObserverNonRetaining:(SCObserver *)observerNonRetaining
{
    objc_setAssociatedObject(self, NSObjectSCKVOObserverNonRetainingKey, observerNonRetaining, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end


NS_ASSUME_NONNULL_END
#endif
