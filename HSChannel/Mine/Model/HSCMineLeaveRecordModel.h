//
//  HSCMineLeaveRecordModel.h
//  HSChannel
//
//  Created by SC on 16/9/4.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "SCTableViewController.h"

@interface HSCMineLeaveRecordModel : SCTableViewCellData

@property (nonatomic, strong)NSString *id;
@property (nonatomic, assign)long long stuId;
@property (nonatomic, strong)NSString *stuName;
@property (nonatomic, strong)NSString *reason;
@property (nonatomic, assign)long long createTim;
@property (nonatomic, assign)long long teacherId;
@property (nonatomic, strong)NSString *teacherName;
@property (nonatomic, strong)NSString *feedback;

@end
