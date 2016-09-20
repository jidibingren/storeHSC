//
//  HSCContactSelectController.h
//  HSChannel
//
//  Created by SC on 16/9/3.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "SCPageViewController.h"

@interface HSCContactSelectController : SCPageViewController

@property (nonatomic, strong)NSMutableDictionary *selectedContacts;

@property (nonatomic, strong)void(^callback)(NSArray *contacts);

- (instancetype)initWithCallback:(void(^)(NSArray *contacts))callback;

@end
