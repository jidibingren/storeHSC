//
//  SCDBTableViewController.m
//  HSChannel
//
//  Created by SC on 16/8/25.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "SCDBTableViewController.h"

@implementation SCDBTableViewController

- (void)loadData:(BOOL)newer
{
    
    SCDBModel *model = [self.cellDataClass new];
    [[model class] findByCriteriaAsync:[self findSQL:newer] callback:^(NSArray *models) {
        
        dispatch_main_async_safe(^{
            
            if ([Utils isNilOrNSNull:models] || models.count == 0) {
                
                if (newer) {
                    
//                    [self.dataArray removeAllObjects];
//                    [self.tableView reloadData];
                    
                }else{
                    [[Utils getDefaultWindow] makeShortToastAtCenter:@"没有更多了"];
                }
                
            }else{
                
                if (newer) {
                    
                    [self.dataArray removeAllObjects];
                    
                }
                
                [self.dataArray addObjectsFromArray:models];
                [self.tableView reloadData];
            }
            
            [self endRefreshing: newer];
            
        });
    }];
    
}

- (NSString *)findSQL:(BOOL)newer{
    return @"";
}


@end
