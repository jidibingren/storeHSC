//
//  HSCMineController.m
//  HSChannel
//
//  Created by SC on 16/8/22.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "HSCMineController.h"
#import "HSCLoginController.h"

@interface HSCMineController (){
    __weak SCUserInfo *userInfo;
    UIView *_tempView;
}

@property (nonatomic, strong)UIImageView  *signedPhotoView;
@property (nonatomic, strong)UILabel      *nameLabel;
@property (nonatomic, strong)UILabel      *phoneLabel;

@end

@implementation HSCMineController

- (void)customizeWhenInit {
    
    self.scHasBottomBar = YES;
    self.title = @"我的";
}

- (void)changeStatus{
//    [self.tableView reloadData];
    [_signedPhotoView sc_setImageWithURL:[Utils isValidStr:userInfo.accountInfo.signPhoto] ? userInfo.accountInfo.signPhoto : @"" placeHolderImage:[UIImage imageNamed:@"me_icon_head"]];
    
    _nameLabel.text = userInfo.accountInfo.name;
    
    _phoneLabel.text = userInfo.accountInfo.telphone;
    _tempView.hidden = NO;
    

}

- (void)viewDidLoad{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeStatus) name:@"1234" object:nil];
    
    userInfo = [SCUserInfo sharedInstance];
    
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
                                  @"leftIconName"  : @"me_icon_album",
                                  @"leftTitle"     : @"相册",
                                  
                                  },
                              @{
                                  @"leftIconName"  : @"me_icon_leave",
                                  @"leftTitle"     : @"请假记录",
                                  
                                  },
                              ];
    
    if ([SCUserInfo sharedInstance].accountInfo.userType == 1) {
        section0Data = @[
                         @{
                             @"leftIconName"  : @"me_icon_album",
                             @"leftTitle"     : @"相册",
                             
                             },
                         ];
    }
    
    
    NSArray *section1Data = @[
                              @{
                                  @"leftIconName"  : @"me_icon_share",
                                  @"leftTitle"     : @"分享给好友",
                                  
                                  },
                              @{
                                  @"leftIconName"  : @"me_icon_feedback",
                                  @"leftTitle"     : @"意见反馈",
                                  
                                  },
                              @{
                                  @"leftIconName"  : @"me_icon_about",
                                  @"leftTitle"     : @"关于书香源",
                                  
                                  },
                              ];
    
    
    DCKeyValueObjectMapping *KVOMapping = [DCKeyValueObjectMapping mapperForClass:[SCNormalCellData class]];
    
    self.dataArray = @[[KVOMapping parseArray:section0Data],
                       [KVOMapping parseArray:section1Data]];
    
    [self.observer observe:userInfo keyPath:@"accountInfo" blockForNew:^(HSCMineController *  _Nullable observer, id  _Nonnull object, SCAccountInfo *  _Nonnull change) {
        
        [observer.signedPhotoView sc_setImageWithURL:[Utils isValidStr:change.signPhoto] ? change.signPhoto : @"" placeHolderImage:[UIImage imageNamed:@"me_icon_head"]];
        
        observer.nameLabel.text = change.name;
        
        observer.phoneLabel.text = change.telphone;
        
    }];
    
    [super viewDidLoad];
    
    [self.tableView reloadData];
    
}

- (void)customizeTableView{
    
    [super customizeTableView];
    
    [self setupTableHeaderView];
    
    [self setupTableFooterView];
    
}

- (void)setupTableHeaderView{
    
    DEFINE_WEAK(self);
    
    UIView *tempView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 110)];
    
    tempView.backgroundColor = [SCColor getColor:@"ffffff"];
    _signedPhotoView = [UIImageView new];
    _signedPhotoView.contentMode = UIViewContentModeScaleAspectFit;
    _signedPhotoView.image = [UIImage imageNamed:@"me_icon_head"];
    _signedPhotoView.layer.cornerRadius = 35;
    _signedPhotoView.layer.masksToBounds = YES;
    [tempView addSubview:_signedPhotoView];
    [_signedPhotoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tempView);
        make.left.mas_equalTo(tempView).offset(15);
        make.height.mas_equalTo(70);
        make.width.mas_equalTo(70);
        
    }];
    tempView.userInteractionEnabled = YES;
    
    [tempView bk_whenTapped:^{
        
        if (userInfo.isLogined) {
            [wself.navigationController pushViewController:[HSCMineBaseInfoController new] animated:YES];
        }else{

            [wself.navigationController pushViewController:[HSCLoginController new] animated:YES];
        }
    }];
    
    _nameLabel = [UILabel new];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.textColor = [SCColor getColor:SC_COLOR_TEXT_2];
    _nameLabel.font = [Utils fontWithSize:SC_FONT_2];
    [tempView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_signedPhotoView);
        make.left.mas_equalTo(_signedPhotoView.mas_right).offset(10);
        make.width.mas_greaterThanOrEqualTo(40);
        make.height.mas_equalTo(25);
    }];
    
    
    _phoneLabel = [UILabel new];
    _phoneLabel.textAlignment = NSTextAlignmentLeft;
    _phoneLabel.textColor = [SCColor getColor:SC_COLOR_TEXT_2];
    _phoneLabel.font = [Utils fontWithSize:SC_FONT_2];
    [tempView addSubview:_phoneLabel];
    [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_nameLabel.mas_bottom).offset(12);
        make.left.mas_equalTo(_nameLabel);
        make.width.mas_greaterThanOrEqualTo(40);
        make.height.mas_equalTo(25);
    }];
    
    if (userInfo.accountInfo) {
        
        [_signedPhotoView sc_setImageWithURL:[Utils isValidStr:userInfo.accountInfo.signPhoto] ? userInfo.accountInfo.signPhoto : @"" placeHolderImage:[UIImage imageNamed:@"me_icon_head"]];
        
        _nameLabel.text = userInfo.accountInfo.name;
        
        _phoneLabel.text = userInfo.accountInfo.telphone;
        
    }else{
        
        
        _nameLabel.text = @"未登录";
        
        _phoneLabel.text = @"";
        
    }
    
    self.tableView.tableHeaderView = tempView;

}


- (void)setupTableFooterView{
    
    DEFINE_WEAK(self);
    _tempView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
    
    if (userInfo.accountInfo) {
        _tempView.hidden = NO;
    }else{
        _tempView.hidden = YES;
    }
    
    _tempView.backgroundColor = [SCColor getColor:@"f3f3f3"];
    
    UIButton *logoutBtn = [UIButton new];
    logoutBtn.backgroundColor = [SCColor getColor:@"ffffff"];
    [logoutBtn setTitle:@"退出当前账号" forState:UIControlStateNormal];
    [logoutBtn setTitleColor:[SCColor getColor:@"f75646"] forState:UIControlStateNormal];
    [_tempView addSubview:logoutBtn];
    [logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_tempView).offset(0);
        make.left.mas_equalTo(_tempView);
        make.right.mas_equalTo(_tempView);
        make.height.mas_equalTo(44);
    }];
    [logoutBtn bk_whenTapped:^{
        //注销
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您确定要退出登录吗？" preferredStyle:UIAlertControllerStyleAlert];
        //创建一个action
        UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [wself.tableView reloadData];
        }];
        UIAlertAction *confirm=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            wself.nameLabel.text = @"未登录";
            
            wself.phoneLabel.text = @"";
            [Utils setLoginToken:@""];
            userInfo.isLogined = NO;
            
            [self.tableView reloadData];
            
            [wself.navigationController pushViewController:[HSCLoginController new] animated:YES];

            _tempView.hidden = YES;
        }];
        
        [alert addAction:cancel];
        [alert addAction:confirm];
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }];
    
    self.tableView.tableFooterView = _tempView;
    
    return ;
}

#pragma mark - UITableViewDataSource/UITableViewDelegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SCNormalTableViewCell5 *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    [cell.leftIcon mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(20,20));
    }];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    switch (indexPath.section) {
        case 0:
            [self.navigationController pushViewController:indexPath.row == 0 ? [HSCMinePhotoAlbumController new] : [HSCMineLeaveRecordsController new] animated:YES];
            break;
        case 1:
        {
            if (indexPath.row == 0) {
                
            }else if (indexPath.row == 1){
                
                [self.navigationController pushViewController:[HSCMinefeedbackController new] animated:YES];
                
            }else{
                
            }
        }
            break;
            
        default:
            break;
    }
    
}

@end
