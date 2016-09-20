//
//  HSCAttendanceRecordsController.m
//  HSChannel
//
//  Created by SC on 16/9/4.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "HSCAttendanceRecordsController.h"

@implementation HSCAttendanceRecordsController

- (void)viewDidLoad{
    
    self.title = @"考勤";
    
    self.url = HSC_URL_WORK_CHECK_LIST;
    
    self.listPath = @"data";
    
    self.cellHeight = 190;
    
    self.cellClass = [HSCAttendanceRecordCell class];
    
    self.cellDataClass = [HSCAttendanceRecordModel class];
   
    
    [super viewDidLoad];
    
    
    [self.tableView reloadData];
    
}

- (void)customizeParams:(NSMutableDictionary *)params newer:(BOOL)newer{
    
    HSCAttendanceRecordModel *checkInfo = self.dataArray.lastObject;
    
    if (newer) {
        checkInfo = nil;
    }
    
    params[@"stuId"] = @([SCUserInfo sharedInstance].selectedChildren.id);
    params[@"createTim"] = checkInfo ? @(checkInfo.checkDate) : @(0);
    
}

@end
