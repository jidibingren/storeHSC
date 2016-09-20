//
//  HSCContactSelectController.m
//  HSChannel
//
//  Created by SC on 16/9/3.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "HSCContactSelectController.h"

typedef NS_ENUM(NSInteger, HSCContactSelectBaseType) {
    HSCContactSelectBaseDefault = 0,
    HSCContactSelectBaseClass,
    HSCContactSelectBaseParent
};


@protocol HSCContactSelectBaseControllerDelegate <NSObject>

- (void)didSelectContact:(HSCContactModel*)contact;

@end

@interface HSCContactSelectBaseController : SCTableViewController

@property (nonatomic, assign)HSCContactSelectBaseType type;

@property (nonatomic, weak  )id<HSCContactSelectBaseControllerDelegate> delegate;

- (instancetype)initWithType:(HSCContactSelectBaseType)type;

@end

@implementation HSCContactSelectBaseController

- (instancetype)initWithType:(HSCContactSelectBaseType)type{
    
    if (self = [super init]) {
        self.type = type;
    }
    
    return self;
}

- (void)viewDidLoad{
    
    self.dontAutoLoad = YES;
    
    self.cellHeight = 60;
    
    self.cellClass = [HSCContactCell2 class];
    
    self.cellDataClass = [HSCContactModel class];
    
    [super viewDidLoad];
    
    self.tableView.mj_header = nil;
    
    self.tableView.mj_footer = nil;
    
    
    switch (_type) {
        case HSCContactSelectBaseDefault:
            self.dataArray = [SCUserInfo sharedInstance].recentContacts;
            break;
        case HSCContactSelectBaseClass:
            self.dataArray = [SCUserInfo sharedInstance].classesContacts;
            break;
        case HSCContactSelectBaseParent:
            self.dataArray = [SCUserInfo sharedInstance].parentsContacts;
            break;
            
        default:
            break;
    }
    
    [self.tableView reloadData];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HSCContactCell2 *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.cellData.isSelected = !cell.cellData.isSelected;
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    [self.delegate didSelectContact:cell.cellData];
}

@end


@interface HSCContactSelectController ()<HSCContactSelectBaseControllerDelegate>

@end

@implementation HSCContactSelectController

- (instancetype)initWithCallback:(void(^)(NSArray *contacts))callback{
    
    if (self = [super init]) {
        _callback = callback;
    }
 
    return self;
}

- (void)setupPageControllerBefore{
    
    [super setupPageControllerBefore];
    
    self.viewFrame = CGRectMake(0, 2, ScreenWidth, ScreenHeight - 64 - 2 - 64);
    
    self.titles = @[@"最近", @"选班级", @"选家长"];
    
    self.viewControllerClasses = @[[HSCContactSelectBaseController class], [HSCContactSelectBaseController class], [HSCContactSelectBaseController class]];
    
    self.title = @"我的消息";
    
}

-(void)setupPageControllerAfter{
    
    [super setupPageControllerAfter];
    
    DEFINE_WEAK(self);
    
    UIButton *confirmBtn = [UIButton new];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[SCColor getColor:SC_COLOR_4] forState:UIControlStateNormal];
    confirmBtn.backgroundColor = [SCColor getColor:SC_COLOR_BUTTON_NORMAL];
    confirmBtn.layer.cornerRadius = 5;
    confirmBtn.layer.masksToBounds = YES;
    [self.view addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(wself.view).offset(-10);
        make.left.mas_equalTo(wself.view).offset(SC_MARGIN_LEFT);
        make.right.mas_equalTo(wself.view).offset(SC_MARGIN_RIGHT);
        make.height.mas_equalTo(44);
    }];
    
    
    [confirmBtn bk_whenTapped:^{
        
        if (wself.callback) {
            [wself.navigationController popViewControllerAnimated:YES];
            wself.callback([wself.selectedContacts allValues]);
            
            SCUserInfo *userInfo = [SCUserInfo sharedInstance];
            
            for (HSCContactModel *model in userInfo.recentContacts) {
                model.isSelected = NO;
            }
            
            for (HSCContactModel *model in userInfo.classesContacts) {
                model.isSelected = NO;
            }
            
            for (HSCContactModel *model in userInfo.parentsContacts) {
                model.isSelected = NO;
            }
        }
        
    }];
    
    
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    HSCContactSelectBaseController *viewController  = nil;
    switch (index) {
        case 0:
            viewController = [[HSCContactSelectBaseController alloc]initWithType:HSCContactSelectBaseDefault];
            viewController.delegate = self;
            break;
            
        case 1:
            viewController = [[HSCContactSelectBaseController alloc]initWithType:HSCContactSelectBaseClass];
            viewController.delegate = self;
            break;
            
        case 2:
            viewController = [[HSCContactSelectBaseController alloc]initWithType:HSCContactSelectBaseParent];
            viewController.delegate = self;
            break;
            
        default:
            break;
    }
    return viewController;
}

#pragma mark - HSCContactSelectBaseControllerDelegate

- (void)didSelectContact:(HSCContactModel *)contact{
    
    if (!self.selectedContacts) {
        self.selectedContacts = [NSMutableDictionary new];
    }
    
    
    NSString *criteriaStr = nil;
    if (contact.contactType == HSCContactClass) {
        self.selectedContacts[@(contact.classId)] = contact.isSelected ? contact : nil;
        criteriaStr = [NSString stringWithFormat:@"where classId = %lld",contact.classId];
    }else{
        self.selectedContacts[contact.username] = contact.isSelected ? contact : nil;
        criteriaStr = [NSString stringWithFormat:@"where username = %@",contact.username];
    }
    
    if ([contact isKindOfClass:[HSCRecentContactModel class]]) {
        return;
    }
    
    if (![SCUserInfo sharedInstance].recentContacts) {
        [SCUserInfo sharedInstance].recentContacts = [NSMutableArray new];
    }
    
    
    [HSCRecentContactModel findFirstByCriteriaAsync:criteriaStr callback:^(JDModel *model) {
        
        if (model == nil) {
            HSCRecentContactModel *recentModel = [[HSCRecentContactModel alloc]init];
            recentModel.contactType = contact.contactType;
            recentModel.username = contact.username;
            recentModel.name = contact.name;
            recentModel.signPhoto = contact.signPhoto;
            recentModel.hxAccount = contact.hxAccount;
            recentModel.telphone = contact.telphone;
            recentModel.className = contact.className;
            recentModel.classId = contact.classId;
            recentModel.chatType = contact.chatType;
            NSMutableArray *tempArray = [[NSMutableArray alloc]initWithObjects:recentModel, nil];
            [tempArray addObjectsFromArray:[SCUserInfo sharedInstance].recentContacts];
            [SCUserInfo sharedInstance].recentContacts = tempArray;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                [recentModel saveAsync:nil];
            });
        }
    }];
    
}

@end
