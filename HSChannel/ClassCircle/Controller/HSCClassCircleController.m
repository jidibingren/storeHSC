//
//  HSCClassCircleController.m
//  HSChannel
//
//  Created by SC on 16/8/22.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "HSCClassCircleController.h"

@implementation HSCClassCircleController

- (void)customizeWhenInit {
    
    [super customizeWhenInit];
    
    self.scHasBottomBar = YES;
    self.title = @"班级圈";
}

- (void)viewDidLoad{
    
    SCUserInfo *userInfo = [SCUserInfo sharedInstance];
    
    self.separatorLineMarginLeft = SC_MARGIN_LEFT;
    
    self.cellHeightArray = @[@45,@45,@45];
    
    self.headerHeightArray = @[@15,@15,@15];
    
    self.cellClassArray = @[[SCNormalTableViewCell5 class],
                            [SCNormalTableViewCell5 class],
                            [SCNormalTableViewCell5 class]];
    
    
    self.cellDataClassArray = @[[SCNormalCellData class],
                                [SCNormalCellData class],
                                [SCNormalCellData class]];
    
    NSArray *section0Data = @[
                              @{
                                  @"leftIconName"  : KSCImageClassSircleControllerTimes,
                                  @"leftTitle"     : @"班级动态",
                                  @"newsCount"     : @(userInfo.unreadCDCount),
                                  
                                },
                              ];
    
    NSArray *section1Data = @[
                              @{
                                  @"leftIconName"  : KSCImageClassSircleControllerNotice,
                                  @"leftTitle"     : @"班级通知",
                                  @"newsCount"     : @(userInfo.unreadCNCount),
                                  
                                  },
                              @{
                                  @"leftIconName"  : KSCImageClassSircleControllerWork,
                                  @"leftTitle"     : @"作业",
                                  @"newsCount"     : @(userInfo.unreadCWCount),
                                  
                                  },
                              ];

    
    NSArray *section2Data = @[
                              @{
                                  @"leftIconName"  : KSCImageClassSircleControllerAttendance,
                                  @"leftTitle"     : @"考勤",
                                  @"newsCount"     : @(userInfo.unreadCACount),
                                  
                                  },
                              @{
                                  @"leftIconName"  : KSCImageClassSircleControllerLeave,
                                  @"leftTitle"     : @"请假",
                                  @"newsCount"     : @(userInfo.unreadCLCount),
                                  
                                  },
                              ];

    
    DCKeyValueObjectMapping *KVOMapping = [DCKeyValueObjectMapping mapperForClass:[SCNormalCellData class]];
    
    self.dataArray = [@[[KVOMapping parseArray:section0Data],
                       [KVOMapping parseArray:section1Data],
                       [KVOMapping parseArray:section2Data]] mutableCopy];
    
    if ([SCUserInfo sharedInstance].accountInfo.userType == 1) {
        [self.dataArray removeLastObject];
    }

    [self.observer observe:userInfo keyPath:@"unreadCDCount" blockForNew:^(HSCClassCircleController *  _Nullable observer, id  _Nonnull object, NSNumber *  _Nonnull change) {
        SCNormalCellData *data = [observer getCellDataWith:0 row:0];
        data.newsCount = change.integerValue;
        [observer reloadCell:0 row:0];
    }];
    
    [self.observer observe:userInfo keyPath:@"unreadCNCount" blockForNew:^(HSCClassCircleController *  _Nullable observer, id  _Nonnull object, NSNumber *  _Nonnull change) {
        SCNormalCellData *data = [observer getCellDataWith:1 row:0];
        data.newsCount = change.integerValue;
        [observer reloadCell:1 row:0];
    }];
    
    [self.observer observe:userInfo keyPath:@"unreadCWCount" blockForNew:^(HSCClassCircleController *  _Nullable observer, id  _Nonnull object, NSNumber *  _Nonnull change) {
        SCNormalCellData *data = [observer getCellDataWith:1 row:1];
        data.newsCount = change.integerValue;
        [observer reloadCell:1 row:1];
    }];
    
    [self.observer observe:userInfo keyPath:@"unreadCACount" blockForNew:^(HSCClassCircleController *  _Nullable observer, id  _Nonnull object, NSNumber *  _Nonnull change) {
        SCNormalCellData *data = [observer getCellDataWith:2 row:0];
        data.newsCount = change.integerValue;
        [observer reloadCell:2 row:0];
    }];
    
    [self.observer observe:userInfo keyPath:@"unreadCLCount" blockForNew:^(HSCClassCircleController *  _Nullable observer, id  _Nonnull object, NSNumber *  _Nonnull change) {
        SCNormalCellData *data = [observer getCellDataWith:2 row:1];
        data.newsCount = change.integerValue;
        [observer reloadCell:2 row:1];
    }];
    
    [super viewDidLoad];
    
    [self.tableView reloadData];
    
}

#pragma mark - UITableViewDataSource/UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    switch (indexPath.section) {
        case 0:
            [self.navigationController pushViewController:[HSCCDViewController new] animated:YES];
            break;
        case 1:
            [self.navigationController pushViewController:indexPath.row == 0 ? [HSCCNViewController new] : [HSCCWViewController new] animated:YES];
            break;
        case 2:
            [self.navigationController pushViewController:indexPath.row == 0 ? [HSCAttendanceRecordsController new] : [HSCAskForLeaveController new]  animated:YES];
            break;
            
        default:
            break;
    }
    
}

@end
