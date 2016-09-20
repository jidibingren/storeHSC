//
//  HSCAttendanceRecordModel.h
//  HSChannel
//
//  Created by SC on 16/9/4.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "SCTableViewController.h"

@interface HSCAttendanceRecordModel : SCTableViewCellData

@property (nonatomic, assign)long long checkDate;
@property (nonatomic, assign)NSInteger morCheckStatus;
@property (nonatomic, assign)long long morCheckTime;
@property (nonatomic, assign)NSInteger noonCheckStatus;
@property (nonatomic, assign)long long noonCheckTime;
@property (nonatomic, assign)NSInteger afterCheckStatus;
@property (nonatomic, assign)long long afterCheckTime;

@end
