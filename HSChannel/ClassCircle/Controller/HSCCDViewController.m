//
//  HSCCDViewController.m
//  HSChannel
//
//  Created by SC on 16/9/1.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "HSCCDViewController.h"

@implementation HSCCDViewController

- (void)viewDidLoad{

    
    self.url = HSC_URL_CLASS_DYNAMICS_LIST;
    
    self.listPath = @"data";
    
    [super viewDidLoad];
    
    self.title = @"班级动态";
    
    [self setupNavigationBar];
    
}

- (void)setupNavigationBar{
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    [rightBtn setTitle:@"发布" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[SCColor getColor:@"ffffff"] forState:UIControlStateNormal];
    [rightBtn bk_whenTapped:^{
        
        [self.navigationController pushViewController:[[HSCClassPublishController alloc]initWithType:HSCClassPublishDynamic] animated:YES];
        
    }];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark - SCMomentsCellDelegate

- (void)didClickDeleteButtonInCell:(SCMomentsCell *)cell{
    
    DEFINE_WEAK(self);
    
    NSIndexPath *indexPath = cell.indexPath;
    
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    params[@"id"] = [(HSCCGMomentsViewModel *)cell.viewModel id];
    
    [SCHttpTool postWithURL:HSC_URL_CLASS_DYNAMICS_DEL params:params success:^(NSDictionary *json) {
        [wself.viewModelsArray removeObjectAtIndex:indexPath.row];
        [wself.tableView reloadData];
    } failure:nil];
    
}


@end
