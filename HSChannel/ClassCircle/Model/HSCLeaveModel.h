//
//  HSCLeaveModel.h
//  HSChannel
//
//  Created by SC on 16/9/4.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "SCTableViewController.h"

@interface HSCLeaveModel : SCTableViewCellData

@property (nonatomic, assign)long long stuId;
@property (nonatomic, assign)long long leaveDate;
@property (nonatomic, strong)NSString *reason;

@end
