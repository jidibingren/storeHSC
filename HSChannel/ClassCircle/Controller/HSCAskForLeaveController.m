//
//  HSCAskForLeaveController.m
//  HSChannel
//
//  Created by SC on 16/9/4.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "HSCAskForLeaveController.h"

@interface HSCAskForLeaveController ()

@property (nonatomic, strong)SCChildInfo *childInfo;
@property (nonatomic, assign)NSInteger   dateType;

@end

@implementation HSCAskForLeaveController

- (void)viewDidLoad{
    
    self.title = @"请假";
    
    self.cellHeightArray = @[@45];
    
    self.cellClassArray = @[[SCNormalTableViewCell6 class]];
    
    
    self.cellDataClassArray = @[[SCNormalCellData class]];
    
    NSArray *section0Data = @[
                              @{
                                  @"leftTitle"     : @"孩子姓名",
                                  @"placeholder"   : @"请选择孩子姓名",
                                  },
                              @{
                                  @"leftTitle"     : @"事由",
                                  @"placeholder"   : @"请选择事由",
                                  },
                              @{
                                  @"leftTitle"     : @"时间",
                                  @"placeholder"   : @"请选择时间",
                                  },
                              @{
                                  @"leftTitle"     : @"请假老师",
                                  @"placeholder"   : @"请选择老师姓名",
                                  },
                              ];

    
    
    DCKeyValueObjectMapping *KVOMapping = [DCKeyValueObjectMapping mapperForClass:[SCNormalCellData class]];
    
    self.dataArray = @[[KVOMapping parseArray:section0Data]];
    
    
    [super viewDidLoad];
    
    self.tableView.mj_header = nil;
    
    self.tableView.mj_footer = nil;
    
    self.separatorLineMarginLeft = 10;
    
    self.separatorLineMarginRight = 10;
    
    [self.tableView reloadData];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SCNormalTableViewCell6 *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    cell.middleTextField.textAlignment = NSTextAlignmentRight;
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DEFINE_WEAK(self);
    SCNormalCellData *data = [wself getCellDataWith:indexPath.section row:indexPath.row];
    
    switch (indexPath.row) {
        case 0:
        {
            NSMutableArray *names = [NSMutableArray new];
            
            for (SCChildInfo *model in [SCUserInfo sharedInstance].children) {
                [names addObject:model.name];
            }
            
            [SCSpinner showSpinnerWithType:SCSpinnerBorderFixedWidthWithTriangle rows:names initialSelection:-1 origin:[tableView cellForRowAtIndexPath:indexPath] doneBlock:^(int selectedIndex, id selectedValue) {
                data.middleText = selectedValue;
                wself.childInfo = [SCUserInfo sharedInstance].children[selectedIndex];
                [wself getCellDataWith:indexPath.section row:3].middleText = wself.childInfo.tchName;
                [wself reloadSection:indexPath.section];
            } cancel:nil];
        }
            break;
            
        case 1:
        {
            
            [SCSpinner showSpinnerWithType:SCSpinnerBorderFixedWidthWithTriangle rows:@[@"事假",@"病假"] initialSelection:-1 origin:[tableView cellForRowAtIndexPath:indexPath] doneBlock:^(int selectedIndex, id selectedValue) {
                data.middleText = selectedValue;
                [wself reloadCell:indexPath.section row:indexPath.row];
            } cancel:nil];
        }
            break;
        case 2:
        {
            
            [SCSpinner showSpinnerWithType:SCSpinnerBorderFixedWidthWithTriangle rows:@[@"今天",@"明天"] initialSelection:-1 origin:[tableView cellForRowAtIndexPath:indexPath] doneBlock:^(int selectedIndex, id selectedValue) {
                data.middleText = selectedValue;
                wself.dateType = selectedIndex+1;
                [wself reloadCell:indexPath.section row:indexPath.row];
            } cancel:nil];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)setupSubviews{
    
    [super setupSubviews];
    
    DEFINE_WEAK(self);
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    contentView.backgroundColor = [SCColor getColor:@"f4f4f4"];
    
    self.tableView.backgroundColor = [SCColor getColor:@"f4f4f4"];
    
    __weak UIView *tempView = contentView;
    
    UIButton *confirmBtn = [UIButton new];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[SCColor getColor:SC_COLOR_4] forState:UIControlStateNormal];
    confirmBtn.backgroundColor = [SCColor getColor:SC_COLOR_BUTTON_NORMAL];
    confirmBtn.layer.cornerRadius = 5;
    confirmBtn.layer.masksToBounds = YES;
    [tempView addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tempView);
        make.left.mas_equalTo(tempView).offset(SC_MARGIN_LEFT);
        make.right.mas_equalTo(tempView).offset(SC_MARGIN_RIGHT);
        make.height.mas_equalTo(44);
    }];
    
    
    [confirmBtn bk_whenTapped:^{
        
        [wself publish];
        
    }];
    
    self.tableView.tableFooterView = contentView;
    
}

- (void)publish{
    
    DEFINE_WEAK(self);
    
    
    NSMutableArray<SCNormalCellData*> *dataArray = self.dataArray[0];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    
    params[@"stuId"] = self.childInfo ? @(self.childInfo.id) : nil;
    params[@"leaveDate"] = self.dateType > 0 ? @(self.dateType) : nil;
    params[@"reason"] = dataArray[1].middleText;
    
    if (![Utils isNonnull:params[@"stuId"]]) {
        [self.view makeShortToastAtCenter:@"请选择孩子姓名"];
        return;
    }
    
    if (![Utils isNonnull:params[@"leaveDate"]]) {
        [self.view makeShortToastAtCenter:@"请选择时间"];
        return;
    }
    
    
    if (![Utils isValidStr:params[@"reason"]]) {
        [self.view makeShortToastAtCenter:@"请选择事由"];
        return;
    }
    
    [SCHttpTool postWithURL:HSC_URL_PARENT_LEAVE params:params success:^(NSDictionary *json) {
        [wself.navigationController popViewControllerAnimated:YES];
    } failure:nil];
    
    }


@end
