//
//  HSCLoginController.m
//  HSChannel
//
//  Created by wangliang on 16/9/9.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "HSCLoginController.h"
#import "SCHttpTool.h"
#import "Utils.h"

@interface HSCLoginController ()<UITextFieldDelegate>
{
    UITextField *account;
    UITextField *passward;
    JYAccount *jyaccount;
    UIButton *loginBtn;
}
@end

@implementation HSCLoginController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"登录";
    self.view.backgroundColor = [SCColor getColor:@"efefef"];
    [self addTextField];
   
}

- (void)addTextField{
    
    account = [[UITextField alloc] initWithFrame:CGRectMake(20, 30, ScreenWidth-40, 60)];
    account.delegate = self;
    
    account.backgroundColor = [UIColor whiteColor];
    account.placeholder = @" 请输入您的手机号";
    account.textColor = [UIColor grayColor];
    account.font = [UIFont systemFontOfSize:18];
    account.layer.cornerRadius = 5;
    account.clipsToBounds = YES;
    
    [self.view addSubview:account];
    
    passward = [[UITextField alloc] initWithFrame:CGRectMake(20, 92, ScreenWidth-40, 60)];
    passward.backgroundColor = [UIColor whiteColor];
    passward.placeholder = @" 请输入您的密码";
    passward.textColor = [UIColor grayColor];
    passward.font = [UIFont systemFontOfSize:18];
    passward.layer.cornerRadius = 5;
    passward.clipsToBounds = YES;
    [self.view addSubview:passward];
    
    loginBtn = [UIButton new];
//    loginBtn.enabled = NO;
    loginBtn.backgroundColor = [SCColor getColor:@"999999"];
    loginBtn.layer.cornerRadius = 5;
    loginBtn.clipsToBounds = YES;
    [loginBtn setTitleColor:[SCColor getColor:@"efefef"] forState:UIControlStateNormal];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    loginBtn.selected = NO;
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passward.mas_bottom).offset(25);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@50);
    }];
    
//    UIButton *findPassward = [UIButton new];
//    [findPassward setTitle:@"找回密码" forState:UIControlStateNormal];
//    [findPassward setTitleColor:[SCColor getColor:@"666666"] forState:UIControlStateNormal];
//    [self.view addSubview:findPassward];
//    
//    [findPassward mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(loginBtn.mas_bottom).offset(20);
//        make.left.equalTo(self.view).offset(20);
//        make.size.mas_equalTo(CGSizeMake(80, 20));
//    }];
}
//   18560126362

//登录按钮
- (void)loginAction{
    
    if(loginBtn.selected == NO){
        [MBProgressHUD showError:@"请输入您的账号密码"];
    }else{
        if ([Utils isValiadateMobile:account.text]) {
            NSDictionary *params = @{@"username":account.text,@"password":passward.text};
            
            [SCHttpTool postWithURL:HSC_URL_USER_LOGIN params:params success:^(NSDictionary *json) {
                NSLog(@"json:%@",json);
                
                if ([[json objectForKey:@"status"]  isEqual: @1]) {
                    if (jyaccount == nil) {
                        jyaccount = [[JYAccount alloc] init];
                    }
                    
                    SCUserInfo * userInfo = [SCUserInfo sharedInstance];
                    userInfo.isLogined = YES;
                    jyaccount.token = [json objectForKey:@"token"];
                    jyaccount.username = account.text;
                    jyaccount.password = passward.text;
                    [JYAccountTool saveAccount:jyaccount];
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    [MBProgressHUD showError:@"登录成功"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"1234" object:nil];
                }else{
                    [MBProgressHUD showError:[NSString stringWithFormat:@"%@",[json objectForKey:@"info"]]];
                }
                
            } failure:^(NSError *error) {
                //            NSLog(@"error:%@",error);
                [MBProgressHUD showError:@"密码为5-18位英文字母"];
            }];
            
        }else{
            [MBProgressHUD showError:@"用户名或密码输入不正确"];
        }

    }
    
    
}

#pragma mark -- UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if(textField.text.length>0){
        loginBtn.selected = YES;
        loginBtn.backgroundColor = [SCColor getColor:SC_COLOR_NAV_BG];
    }
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [account resignFirstResponder];
    [passward resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
