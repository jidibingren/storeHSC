//
//  HSCHomepageController.m
//  HSChannel
//
//  Created by SC on 16/8/24.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "HSCHomepageController.h"

@implementation HSCHomepageController

- (void)customizeWhenInit {
    
    self.scHasBottomBar = YES;
    
}

- (void) setupSubviews {
    
    self.segmentTitles = @[@"消息", @"通讯录"];
    
    self.segmentChildViewControllers = @[[HSCMAllListController new], [HSCContactController new]];

    [super setupSubviews];
    
    [self setupNavigationBar];
}

- (void)setupNavigationBar{
    
    void( ^ right1ItemCallback )(NSUInteger index, id info)  = ^(NSUInteger index, id info){
        
        switch (index) {
            case 0:
            {
                [self.navigationController pushViewController:[[HSCContactController alloc]initWithType:HSCContactSelectMulti callback:^(NSArray *contacts) {
                    
                    NSMutableArray *tempArray = [NSMutableArray new];
                    for (HSCContactModel *contact in contacts) {
                        [tempArray addObject:contact.hxAccount];
                    }
                    
                    if (tempArray.count > 0) {
                        
                        LGAlertView *alertView = [[LGAlertView alloc] initWithTextFieldsAndTitle:@"请输入会话组信息" message:nil numberOfTextFields:2 textFieldsSetupHandler:^(UITextField *textField, NSUInteger index) {
                            switch (index) {
                                case 0:
                                    textField.placeholder = @"请输入会话组名称";
                                    break;
                                case 1:
                                    textField.placeholder = @"请输入会话组描述";
                                    break;
                                    
                                default:
                                    break;
                            }
                        } buttonTitles:@[@"确定"] cancelButtonTitle:@"取消" destructiveButtonTitle:nil actionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
                            
                            
                            if (![Utils isValidStr:[alertView.textFieldsArray[0] text]] || ![alertView.textFieldsArray[1] text]) {
                                return ;
                            }
                            
                            EMError *error = nil;
                            EMGroupOptions *setting = [[EMGroupOptions alloc] init];
                            setting.maxUsersCount = 500;
                            setting.style = EMGroupStylePrivateMemberCanInvite;
                            EMGroup *group = [[EMClient sharedClient].groupManager createGroupWithSubject:[alertView.textFieldsArray[0] text] description:[alertView.textFieldsArray[1] text] invitees:tempArray message:@"邀请您加入群组" setting:setting error:&error];
                            if(!error){
                                NSLog(@"创建成功 -- %@",group);
                                
                                [self.navigationController pushViewController:[[SCMessageViewController alloc]initWithConversationChatter:group.groupId conversationName:group.subject conversationType:SCConversationTypeGroupChat] animated:YES];
                                
                            }
                            
                        } cancelHandler:^(LGAlertView *alertView) {
                            ;
                        } destructiveHandler:nil];
                        
                        [alertView showAnimated:YES completionHandler:nil];
                    }
                    
                }] animated:YES];
            }
                break;
            case 1:
            {
                [self.navigationController pushViewController:[[HSCContactController alloc]initWithType:HSCContactSelectSingle callback:^(NSArray *contacts) {
                    
                    if (contacts.count > 0) {
                        EMError *error = [[EMClient sharedClient].contactManager addContact:[contacts[0] hxAccount] message:@"我想加您为好友"];
                        if (!error) {
                            NSLog(@"添加成功");
                        }
                    }
                    
                }] animated:YES];
            }
                break;
                
            default:
                
                break;
        }
    };
    
    DTKDropdownItem *right1Item1 = [DTKDropdownItem itemWithTitle:@"多人聊天" iconName:@"message_icon_chat" callBack:right1ItemCallback];
    DTKDropdownItem *right1Item2 = [DTKDropdownItem itemWithTitle:@"加好友" iconName:@"message_icon_addfrd" callBack:right1ItemCallback];
    
    NSArray *right1Items = @[right1Item1, right1Item2];
    
    DTKDropdownMenuView *right1View = [DTKDropdownMenuView dropdownMenuViewWithType:dropDownTypeRightItem frame:CGRectMake(0, 0, 20, 20) dropdownItems:right1Items icon:@"icon_message_normal"];
    right1View.textFont = [Utils fontWithSize:SC_FONT_4];
    right1View.textColor = [SCColor getColor:SC_COLOR_TEXT_2];
    right1View.cellSeparatorColor = [SCColor getColor:SC_COLOR_SEPARATOR_LINE];
    right1View.cellHeight = 44;
    right1View.dropWidth = 140;
    right1View.cellSeparatorEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:right1View];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.title = @"消息";
}


@end
