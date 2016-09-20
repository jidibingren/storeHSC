//
//  SCNormalTableViewController.h
//  HSChannel
//
//  Created by SC on 16/8/31.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "SCTableViewController.h"
#import "SCNormalCellData.h"
#import "SCNormalTableViewCell.h"

@interface SCNormalTableViewController : SCGroupTableViewController

- (NSArray *)getSectionDataWith:(NSInteger)section;

- (SCNormalCellData *)getCellDataWith:(NSInteger)section row:(NSInteger)row;

- (void)reloadSection:(NSInteger)section;

- (void)reloadCell:(NSInteger)section row:(NSInteger)row;

@end
