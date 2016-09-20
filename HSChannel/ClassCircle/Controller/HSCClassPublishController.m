//
//  HSCClassPublishController.m
//  HSChannel
//
//  Created by SC on 16/9/3.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "HSCClassPublishController.h"

@interface HSCClassPublishController ()<HSCImageSlecteCellDelegate>

@property (nonatomic, strong)NSMutableArray<UIImage*>* iconArray;

@property (nonatomic, strong)NSMutableArray<HSCContactModel*>* contacts;

@end

@implementation HSCClassPublishController

- (instancetype)initWithType:(HSCClassPublishType)type{
    
    if (self = [super init]) {
        self.type = type;
    }
    
    return self;
    
}

- (void)viewDidLoad{
    
    self.cellHeightArray = [@[@45,@45,@155,@(UITableViewAutomaticDimension)] mutableCopy];
    
    self.footerHeightArray = [@[@0.5,@0.5,@15,@15] mutableCopy];
    
    self.cellClassArray = [@[[SCNormalTableViewCell6 class],
                             [SCNormalTableViewCell7 class],
                            [SCNormalTableViewCell8 class],
                            [SCNormalTableViewCell5 class]] mutableCopy];
    
    
    self.cellDataClassArray = [@[[SCNormalCellData class],
                                [SCNormalCellData class],
                                [SCNormalCellData class],
                                [SCNormalCellData class]] mutableCopy];
    
    NSArray *section0Data = @[
                              @{
                                  @"leftTitle"     : @"发送对象",
                                  },
                              ];
    
    NSArray *section1Data = @[
                              @{
                                  @"placeholder"     : @"请输入标题",
                                  @"middleTextEnabled"     : @1,
                                  },
                              ];
    
    NSArray *section2Data = @[
                              @{
                                  @"placeholder"     : @"请输入内容",
                                  @"middleTextEnabled"     : @1,
                                  },
                              ];
    
    NSArray *section3Data = @[
                              @{
                                  @"leftIconName"  : @"moments_icon_notice",
                                  @"leftTitle"     : @"班级通知",
                                  
                                  },
                              ];
    
    
    DCKeyValueObjectMapping *KVOMapping = [DCKeyValueObjectMapping mapperForClass:[SCNormalCellData class]];
    
    self.dataArray = [@[[KVOMapping parseArray:section0Data],
                       [KVOMapping parseArray:section1Data],
                       [KVOMapping parseArray:section2Data],
                       [KVOMapping parseArray:section3Data]] mutableCopy];
    
    if (_type == HSCClassPublishDynamic) {
        [self.cellHeightArray removeObjectAtIndex:1];
        [self.footerHeightArray removeObjectAtIndex:1];
        [self.cellClassArray removeObjectAtIndex:1];
        [self.cellDataClassArray removeObjectAtIndex:1];
        [self.dataArray removeObjectAtIndex:1];
    }
    
    switch (_type) {
        case HSCClassPublishNotice:
            self.title = @"发布通知";
            break;
        case HSCClassPublishDynamic:
            self.title = @"发布动态";
            break;
        case HSCClassPublishWork:
            self.title = @"发布作业";
            break;
            
        default:
            break;
    }

    
    [super viewDidLoad];
    
    self.tableView.mj_header = nil;
    
    self.tableView.mj_footer = nil;
    
    [self.tableView reloadData];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ((_type == HSCClassPublishDynamic && indexPath.section < 2) || (_type != HSCClassPublishDynamic && indexPath.section < 3)) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    HSCImageSlecteCell *cell = [[HSCImageSlecteCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HSCImageSlecteCell"];
    cell.delegate = self;
    [cell setIcons:_iconArray atIndexPath:indexPath];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        DEFINE_WEAK(self);
        [self.navigationController pushViewController:[[HSCContactSelectController alloc]initWithCallback:^(NSArray *contacts) {
            wself.contacts = contacts;
        }] animated:YES];
        
    }
    
}

#pragma mark - HSCImageSlecteCellDelegate

-(void)iconChanged:(NSMutableArray *)icons indexPath:(NSIndexPath *)indexPath{
    
    _iconArray = icons;
    
    [self reloadCell:indexPath.section row:indexPath.row];
    
}

- (void)setupSubviews{
    
    [super setupSubviews];
    
    [self setupSubview];
    
}

- (void)setupSubview{
    
    DEFINE_WEAK(self);
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    contentView.backgroundColor = [SCColor getColor:SC_COLOR_4];
    
    __weak UIView *tempView = contentView;
    
    UIButton *confirmBtn = [UIButton new];
    [confirmBtn setTitle:@"发布" forState:UIControlStateNormal];
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
    
    
    NSMutableArray<SCNormalCellData*> *dataArray = self.dataArray[1];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    NSMutableString *classIds = nil;
    NSMutableString *parentUsernames = nil;
    NSString *title = nil;
    
    NSString *content = nil;
    
    NSString *url = nil;
    switch (_type) {
        case HSCClassPublishNotice:
            
            url = HSC_URL_CLASS_NOTICE_ADD;
            
            title = dataArray[0].middleText;
            
            dataArray = self.dataArray[2];
            content = dataArray[0].middleText;
            
            
            break;
        case HSCClassPublishDynamic:
            url = HSC_URL_CLASS_DYNAMICS_ADD;
            content = dataArray[0].middleText;
            
            break;
        case HSCClassPublishWork:
            
            url = HSC_URL_HOMEWORK_ADD;
            
            title = dataArray[0].middleText;
            
            dataArray = self.dataArray[2];
            content = dataArray[0].middleText;
            
            break;
            
        default:
            break;
    }
    
    for (HSCContactModel *contact in _contacts) {
        if (contact.contactType == HSCContactParent) {
            if (!parentUsernames) {
                parentUsernames = [NSMutableString new];
            }
            [parentUsernames appendString:[NSString stringWithFormat:@"%@,",contact.username]];
        }else if (contact.contactType == HSCContactClass) {
            if (!classIds) {
                classIds = [NSMutableString new];
            }
            [classIds appendString:[NSString stringWithFormat:@"%@,",contact.username]];
        }
    }
    
    params[@"classIds"] = classIds;
    params[@"parentUsernames"] = parentUsernames;
    params[@"title"] = title;
    params[@"content"] = content;
    
    if (![Utils isValidStr:params[@"classIds"]] && ![Utils isValidStr:params[@"parentUsernames"]]) {
        [self.view makeShortToastAtCenter:@"请选择对象"];
        return;
    }
    
    if (_type != HSCClassPublishDynamic && ![Utils isValidStr:params[@"title"]]) {
        [self.view makeShortToastAtCenter:@"请输入标题"];
        return;
    }
    
    
    if (![Utils isValidStr:params[@"content"]]) {
        [self.view makeShortToastAtCenter:@"请输入内容"];
        return;
    }
    
    [SCHttpTool uploadImageWithUrl:url params:params images:self.iconArray fileNames:@[@"file1",@"file2",@"file3",@"file4",@"file5",@"file6",] success:^(id response) {
        
        [wself.navigationController popViewControllerAnimated:YES];
        
    } withinView:self.view progressText:nil];
    
}

@end
