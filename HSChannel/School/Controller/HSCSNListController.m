//
//  HSCSNListController.m
//  HSChannel
//
//  Created by SC on 16/8/26.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "HSCSNListController.h"

@implementation HSCSNListController

- (instancetype)initWithAutoLoad:(BOOL)autoLoad{
    
    if (self = [super init]) {
        
        self.dontAutoLoad = !autoLoad;
        
        if (!autoLoad) {
            self.dataArray = [SCUserInfo sharedInstance].unreadSN;
        }
        
        self.title = @"学校通知";
        
    }
    
    return self;
}

- (void)customizeTableView{
    
    self.url = HSC_URL_SCHOOL_NOTICE_LIST;
    
    self.listPath = @"data";
    
    self.cellClass = [HSCShoolNoticeCell class];
    
    self.cellDataClass = [HSCMessageModel class];
    
    self.cellHeight = UITableViewAutomaticDimension;
    
}

- (void)customizeParams:(NSMutableDictionary *)params newer:(BOOL)newer{
    
    HSCMessageModel *data = self.dataArray.lastObject;
    
    if (newer) {
        data = nil;
    }
    
    params[@"createTim"] = data ? @(data.createTim) : @(0);
    
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewAutomaticDimension;
    
}

@end
