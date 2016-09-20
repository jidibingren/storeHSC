//
//  SCSWTableViewController.m
//  HSChannel
//
//  Created by SC on 16/8/26.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "SCSWTableViewController.h"

@implementation SCSWTableViewController

#pragma mark - SWTableViewCellDelegate

- (void)swipeableTableViewCell:(SCSWTableViewCell *)cell scrollingToState:(SWCellState)state
{
    switch (state) {
        case 0:
            NSLog(@"utility buttons closed");
            break;
        case 1:
            NSLog(@"left utility buttons open");
            break;
        case 2:
            [self deleteCell:cell];
            break;
        default:
            break;
    }
}

-(void)swipeableTableViewCell:(SCSWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index{
    
    if (index == 0) {
        
        [self deleteCell:cell];
        
    }
}

- (void)deleteCell:(SCSWTableViewCell *)cell{
    
    [self.dataArray removeObject:cell.cellData];
    
    [self.tableView deleteRowsAtIndexPaths:@[cell.indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}

@end
