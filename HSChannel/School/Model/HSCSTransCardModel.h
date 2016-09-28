//
//  HSCSTransCardModel.h
//  HSChannel
//
//  Created by SC on 16/8/30.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "SCTableViewController.h"

@interface HSCSTransCardModel : SCTableViewCellData

@property (nonatomic, assign)long long stuId;
@property (nonatomic, strong)NSString *stuName;
@property (nonatomic, strong)NSString *stuCode;
@property (nonatomic, strong)NSString *className;

@end
