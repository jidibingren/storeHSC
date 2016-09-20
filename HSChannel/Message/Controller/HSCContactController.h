//
//  HSCContactController.h
//  HSChannel
//
//  Created by SC on 16/8/24.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "SCBaseViewController.h"
#import "HSCContactModel.h"
#import "HSCContactCell.h"

typedef NS_ENUM(NSInteger, HSCContactSelectType) {
    HSCContactSelectDefault = 0,
    HSCContactSelectSingle,
    HSCContactSelectMulti
};

@interface HSCContactController : SCGroupTableViewController

@property (nonatomic, assign)HSCContactSelectType type;

@property (nonatomic, strong)SCAccordionTableView *tableView;

@property (nonatomic, strong)NSString *headerViewReuseIdentifier;

@property (nonatomic, strong)NSString *cellReuseIdentifier;

@property (nonatomic, strong)NSString *footerViewReuseIdentifier;

@property (nonatomic, strong)NSMutableArray<HSCContactGroupModel*> *headersInfo;

@property (nonatomic, strong)void(^callback)(NSArray *contacts);

- (instancetype)initWithType:(HSCContactSelectType)type callback:(void(^)(NSArray *contacts))callback;

@end
