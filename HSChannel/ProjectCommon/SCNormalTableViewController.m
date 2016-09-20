//
//  SCNormalTableViewController.m
//  HSChannel
//
//  Created by SC on 16/8/31.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "SCNormalTableViewController.h"

@implementation SCNormalTableViewController

- (void)viewDidLoad{
    
    self.dontAutoLoad = YES;
    
    [super viewDidLoad];
    
    self.tableView.mj_header = nil;
    
    self.tableView.mj_footer = nil;
    
}

- (NSArray *)getSectionDataWith:(NSInteger)section{
    
    if (section >= [self.dataArray count]){
        return nil;
    }
    return self.dataArray[section];
}


- (SCNormalCellData *)getCellDataWith:(NSInteger)section row:(NSInteger)row{
    
    if (section >= [self.dataArray count] || row >= [(NSArray*)self.dataArray[section] count]){
        return nil;
    }
    return self.dataArray[section][row];
}

- (void)reloadSection:(NSInteger)section{
    
    if (section >= [self.dataArray count]){
        return ;
    }
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section]  withRowAnimation:UITableViewRowAnimationNone];
}

- (void)reloadCell:(NSInteger)section row:(NSInteger)row{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    if ([Utils isNilOrNSNull:indexPath]) {
        return;
    }
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - UITableViewDataSource/UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SCNormalCellData *data = [self getCellDataWith:indexPath.section row:indexPath.row];
    
    if (data.newsCount > 0) {
        data.newsCount = 0;
        [self reloadCell:indexPath.section row:indexPath.row];
    }
    
}

@end
