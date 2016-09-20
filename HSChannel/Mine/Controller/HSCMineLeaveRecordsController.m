//
//  HSCMineLeaveRecordsController.m
//  HSChannel
//
//  Created by SC on 16/9/4.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "HSCMineLeaveRecordsController.h"

@implementation HSCMineLeaveRecordsController

- (void)viewDidLoad{
    
    self.title = @"请假记录";
    
    self.url = HSC_URL_PARENT_LEAVE_LIST;
    
    self.listPath = @"data";
    
    self.cellHeight = 240;
    
    self.cellClass = [HSCMineLeaveRecordCell class];
    
    self.cellDataClass = [HSCMineLeaveRecordModel class];
    
    
    [super viewDidLoad];
    
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = [SCColor getColor:@"f2f2f2"];
    
    [self.tableView reloadData];
    
}

- (void)customizeParams:(NSMutableDictionary *)params newer:(BOOL)newer{
    
    HSCMineLeaveRecordModel *checkInfo = self.dataArray.lastObject;
    
    if (newer) {
        checkInfo = nil;
    }
    
    params[@"createTim"] = checkInfo ? @(checkInfo.createTim) : @(0);
    
}

@end
