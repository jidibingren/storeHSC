//
//  SCRootViewController.h
//  JJ56
//
//  Created by SC on 16/5/20.
//  Copyright © 2016年 SDJY. All rights reserved.
//

typedef NS_ENUM(NSInteger, SCRootControllerType){
    SCRootControllerDefault,
    SCRootControllerType1,
    SCRootControllerType2
};

@interface SCRootViewController : CYLTabBarController

@property (nonatomic, assign)SCRootControllerType type;

+ (void)setRootControllerByType:(SCRootControllerType)type;

- (instancetype)initWithType:(SCRootControllerType)type;

@end
