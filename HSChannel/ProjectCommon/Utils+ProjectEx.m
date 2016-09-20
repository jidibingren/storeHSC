//
//  Utils+ProjectEx.m
//  JJ56
//
//  Created by SC on 16/7/21.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "Utils+ProjectEx.h"

@implementation Utils (ProjectEx)

+ (void)playNewMessageAlert{
    
    if ([SCUserInfo sharedInstance].audioEable.boolValue == NO) {
        return;
    }
    
    static dispatch_once_t onceToken;
    static dispatch_queue_t queue = nil;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("", 0);
        dispatch_async(queue, ^{
            AudioServicesPlaySystemSound(1007);
        });
    });
    
    if ([Utils isNonnull:queue]) {
        dispatch_async(queue, ^{
            AudioServicesPlaySystemSound(1007);
        });
    }
}

@end
