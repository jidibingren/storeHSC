//
//  HSCMineBaseInfoController.m
//  HSChannel
//
//  Created by SC on 16/9/5.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "HSCMineBaseInfoController.h"

@interface HSCMineBaseInfoController (){
    __weak SCUserInfo *userInfo;
}

@property (nonatomic, strong)UIImageView  *signedPhotoView;
@property (nonatomic, strong)UILabel      *nameLabel;

@end

@implementation HSCMineBaseInfoController

- (void)viewDidLoad{
    
    self.title = @"基本信息";
    
    userInfo = [SCUserInfo sharedInstance];
    
    self.separatorLineMarginLeft = SC_MARGIN_LEFT;
    
    self.cellHeightArray = @[@45,@45];
    
    self.headerHeightArray = @[@15,@15];
    
    self.cellClassArray = @[[SCNormalTableViewCell9 class],
                            [SCNormalTableViewCell9 class]];
    
    
    self.cellDataClassArray = @[[SCNormalCellData class],
                                [SCNormalCellData class]];
    
    NSArray *section0Data = @[
                              @{
                                  @"leftIconName"  : @"info_icon_name",
                                  @"leftTitle"     : @"孩子姓名",
                                  @"placeholder"     : @"请选择孩子姓名",
                                  },
                              @{
                                  @"leftIconName"  : @"info_icon_password",
                                  @"leftTitle"     : @"修改密码",
                                  @"placeholder"     : @"请输入新密码",
                                  },
                              @{
                                  @"leftIconName"  : @"info_icon_account",
                                  @"leftTitle"     : @"书香源账号",
                                  @"placeholder"     : @"请输入书香源账号",
                                  @"middleText"     : @"",
                                  },
                              @{
                                  @"leftIconName"  : @"info_icon_join",
                                  @"leftTitle"     : @"加盟校",
                                  @"placeholder"     : @"请输入加盟校名称",
                                  },
                              ];
    
    
    NSArray *section1Data = @[
                              @{
                                  @"leftIconName"  : @"info_icon_local",
                                  @"leftTitle"     : @"地区",
                                  @"placeholder"     : @"请输入所在地区",
                                  @"middleTextEnabled":@(YES),
                                  },
                              @{
                                  @"leftIconName"  : @"info_icon_school",
                                  @"leftTitle"     : @"学校",
                                  @"placeholder"     : @"请输入学校名称",
                                  @"middleTextEnabled":@(YES),
                                  },
                              @{
                                  @"leftIconName"  : @"info_icon_grade",
                                  @"leftTitle"     : @"年级",
                                  @"placeholder"     : @"请输入年级",
                                  @"middleTextEnabled":@(YES),
                                  },
                              @{
                                  @"leftIconName"  : @"info_icon_phone",
                                  @"leftTitle"     : @"手机号",
                                  @"placeholder"     : @"请输入手机号",
                                  @"middleTextEnabled":@(YES),
                                  },
                              @{
                                  @"leftIconName"  : @"info_icon_connection",
                                  @"leftTitle"     : @"其他联系方式",
                                  @"placeholder"     : @"请输入其他联系方式",
                                  @"middleTextEnabled":@(YES),
                                  },


                              ];
    
    
    DCKeyValueObjectMapping *KVOMapping = [DCKeyValueObjectMapping mapperForClass:[SCNormalCellData class]];
    
    self.dataArray = @[[KVOMapping parseArray:section0Data],
                       [KVOMapping parseArray:section1Data]];
    
    NSArray<SCNormalCellData *> *tempArray = self.dataArray[0];
    tempArray[0].middleText = userInfo.selectedChildren.name;
    tempArray[2].middleText = nil;
    tempArray[3].middleText = userInfo.selectedChildren.jmSchName;
    tempArray = self.dataArray[1];
    tempArray[0].middleText = userInfo.selectedChildren.address;
    tempArray[1].middleText = userInfo.selectedChildren.schName;
    tempArray[2].middleText = userInfo.selectedChildren.grade;
    tempArray[3].middleText = userInfo.accountInfo.telphone;
    tempArray[4].middleText = userInfo.accountInfo.phone2;
    
    
    [super viewDidLoad];
    
    [self.tableView reloadData];
    
}

- (void)customizeTableView{
    
    [super customizeTableView];
    
    [self setupTableHeaderView];
    
    [self setupTableFooterView];
    
}

- (void)setupTableHeaderView{
    
    UIImageView *tempView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 120)];
    
    tempView.backgroundColor = [SCColor getColor:@"ffffff"];
    tempView.image = [UIImage imageNamed:@"info_bg_head"];
    tempView.userInteractionEnabled = YES;
    _signedPhotoView = [UIImageView new];
    _signedPhotoView.contentMode = UIViewContentModeScaleAspectFit;
    _signedPhotoView.image = [UIImage imageNamed:@"info_icon_head"];
    _signedPhotoView.layer.cornerRadius = 35;
    _signedPhotoView.layer.masksToBounds = YES;
    [tempView addSubview:_signedPhotoView];
    [_signedPhotoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(tempView);
        make.top.mas_equalTo(tempView).offset(10);
        make.height.mas_equalTo(70);
        make.width.mas_equalTo(70);
        
    }];
    _signedPhotoView.userInteractionEnabled = YES;
    [_signedPhotoView bk_whenTapped:^{
        DEFINE_WEAK(self);
        [SCImageSelector showIn:wself callback:^(UIImage* image) {
            if (image) {
                
                wself.signedPhotoView.image = image;
                [SCHttpTool uploadImageWithUrl:HSC_URL_USER_AVATOR_UPLOAD data:UIImagePNGRepresentation(image) success:^(id response) {
                    ;
                } withinView:wself.view progressText:nil];
                
            }
        } cropAspectRatio:1];
    }];
    
    _nameLabel = [UILabel new];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.textColor = [SCColor getColor:SC_COLOR_TEXT_6];
    _nameLabel.font = [Utils fontWithSize:SC_FONT_2];
    [tempView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_signedPhotoView.mas_bottom).offset(10);
        make.left.mas_equalTo(tempView);
        make.right.mas_equalTo(tempView);
        make.height.mas_equalTo(20);
    }];
    
    if (userInfo.accountInfo) {
        
        [_signedPhotoView sc_setImageWithURL:[Utils isValidStr:userInfo.accountInfo.signPhoto] ? userInfo.accountInfo.signPhoto : @"" placeHolderImage:[UIImage imageNamed:@"info_icon_head"]];
        
        _nameLabel.text = userInfo.accountInfo.name;
        
        
    }
    
    self.tableView.tableHeaderView = tempView;
    
}

- (void)setupTableFooterView{
    
    DEFINE_WEAK(self);
    UIView *tempView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
    tempView.backgroundColor = [SCColor getColor:@"f3f3f3"];
    
    UIButton *logoutBtn = [UIButton new];
    logoutBtn.backgroundColor = [SCColor getColor:@"ffffff"];
    [logoutBtn setTitle:@"提交修改" forState:UIControlStateNormal];
    [logoutBtn setTitleColor:[SCColor getColor:@"f75646"] forState:UIControlStateNormal];
    [tempView addSubview:logoutBtn];
    [logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(tempView).offset(0);
        make.left.mas_equalTo(tempView);
        make.right.mas_equalTo(tempView);
        make.height.mas_equalTo(44);
    }];
    
    [logoutBtn bk_whenTapped:^{
        
        NSArray<SCNormalCellData*> *tempData = self.dataArray[1];
        
        NSMutableDictionary *params = [NSMutableDictionary new];
        params[@"id"] = @(userInfo.selectedChildren.id);
        params[@"schName"] = tempData[1].middleText;
        params[@"grade"] = tempData[2].middleText;
        params[@"address"] = tempData[0].middleText;
        params[@"telphone"] = tempData[3].middleText;
        params[@"othTelphone"] = tempData[4].middleText;
        
        [SCHttpTool postWithURL:HSC_URL_CHILD_INFO_MODIFY params:params success:^(NSDictionary *json) {
            
            [wself.navigationController popViewControllerAnimated:YES];
            
        } failure:nil];
        
        
    }];
    
    self.tableView.tableFooterView = tempView;
    
    return ;
}

#pragma mark - UITableViewDataSource/UITableViewDelegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SCNormalTableViewCell9 *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    [cell.leftIcon mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(20,20));
    }];
    
    cell.middleTextField.textAlignment = NSTextAlignmentRight;
    cell.middleTextField.textColor = [SCColor getColor:SC_COLOR_TEXT_3];
    cell.middleTextField.font = [Utils fontWithSize:SC_FONT_4];
    
    return cell;
}

@end
