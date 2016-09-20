//
//  SCMessageViewController.m
//  SC56
//
//  Created by SC on 16/7/26.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "SCMessageViewController.h"


@interface SCMessageViewController ()<EaseMessageViewControllerDataSource>

@property (nonatomic, strong)NSString     *conversationChatter;

@end

@implementation SCMessageViewController

- (instancetype)initWithConversationChatter:(NSString *)conversationChatter  conversationName:(NSString*)conversationName {
    
    return [self initWithConversationChatter:conversationChatter conversationName:(NSString*)conversationName conversationType:SCConversationTypeChat];
}

- (instancetype)initWithConversationChatter:(NSString *)conversationChatter conversationName:(NSString*)conversationName conversationType:(SCConversationType)conversationType
{
    if ([conversationChatter length] == 0) {
        return nil;
    }
    
    self.hidesBottomBarWhenPushed = YES;
    
    self.title = conversationName;
    self.conversationChatter = conversationChatter;
    
    if (self = [super initWithConversationChatter:conversationChatter conversationType:conversationType]){
        self.dataSource = self;
        self.fromAvatarURLPath = [SCUserInfo sharedInstance].accountInfo.signPhoto;
        
    }
    
    return self;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self setupNavigationBar];
    
    [self setupHeaderView];
    
}

- (void)setupNavigationBar{
    
//    DEFINE_WEAK(self);
//    
//    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"search_icon_back"] style:UIBarButtonItemStylePlain handler:^(id sender) {
//        [wself.navigationController popViewControllerAnimated:YES];
//    }];
//    
//    self.navigationItem.leftBarButtonItem = backButtonItem;
}

- (void)setupHeaderView{
    
    CGFloat leftMargin  = 10;
    CGFloat rightMargin = -10;
    CGRect tempFrame = CGRectZero;
    
    DEFINE_WEAK(self);
    
    
    tempFrame.size.width = ScreenWidth;
    tempFrame.size.height = 10;
    UIView *headView = [[UIView alloc]initWithFrame:tempFrame];
    headView.backgroundColor = [SCColor getColor:@"f3f3f3"];
    
    self.tableView.tableHeaderView = headView;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(tableViewDidTriggerHeaderRefresh)];
    
    //    self.tableView.mj_header.ignoredScrollViewContentInsetTop = -headView.frame.size.height;
    
}

- (void)_sendMessage:(EMMessage *)message
{
    
    NSMutableDictionary * ext = [[NSMutableDictionary alloc]initWithDictionary:[Utils isValidDictionary:message.ext] ? message.ext : @{}];
    ext[SCFromAvatarURLPath] = _fromAvatarURLPath;
    
    ext[SCEMUserName] = [SCUserInfo sharedInstance].accountInfo.username;
    
    message.ext = ext;
    
    if (self.conversation.type == EMConversationTypeGroupChat){
        message.chatType = EMChatTypeGroupChat;
    }
    else if (self.conversation.type == EMConversationTypeChatRoom){
        message.chatType = EMChatTypeChatRoom;
    }
    
    [self addMessageToDataSource:message
                        progress:nil];
    
    __weak typeof(self) weakself = self;
    [[EMClient sharedClient].chatManager asyncSendMessage:message progress:nil completion:^(EMMessage *aMessage, EMError *aError) {
        [weakself.tableView reloadData];
    }];
}
#pragma mark - EMChatManagerDelegate

- (void)_sendHasReadResponseForMessages:(NSArray*)messages
                                 isRead:(BOOL)isRead
{
    NSMutableArray *unreadMessages = [NSMutableArray array];
    for (NSInteger i = 0; i < [messages count]; i++)
    {
        EMMessage *message = messages[i];
        BOOL isSend = YES;
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(messageViewController:shouldSendHasReadAckForMessage:read:)]) {
            isSend = [self.dataSource messageViewController:self
                             shouldSendHasReadAckForMessage:message read:isRead];
        }
        else{
            isSend = [self shouldSendHasReadAckForMessage:message
                                                     read:isRead];
        }
        
        if (isSend)
        {
            [unreadMessages addObject:message];
        }
    }
    
    if ([unreadMessages count])
    {
        for (EMMessage *message in unreadMessages)
        {
            [[EMClient sharedClient].chatManager asyncSendReadAckForMessage:message];
        }
    }
}

- (BOOL)_shouldMarkMessageAsRead
{
    BOOL isMark = YES;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(messageViewControllerShouldMarkMessagesAsRead:)]) {
        isMark = [self.dataSource messageViewControllerShouldMarkMessagesAsRead:self];
    }
    else{
        if (([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) || !self.isViewDidAppear)
        {
            isMark = NO;
        }
    }
    
    return isMark;
}

- (void)didReceiveMessages:(NSArray *)aMessages
{
    for (EMMessage *message in aMessages) {
        if ([self.conversation.conversationId isEqualToString:message.conversationId]) {
            
            if (![self.conversation.latestMessage.messageId isEqualToString:message.messageId]) {
                
                [self addMessageToDataSource:message progress:nil];
                
            }
            
            [self _sendHasReadResponseForMessages:@[message]
                                           isRead:NO];
            
            if ([self _shouldMarkMessageAsRead])
            {
                [self.conversation markMessageAsReadWithId:message.messageId];
            }
        }
    }
}

#pragma mark - EaseMessageViewControllerDataSource

- (id<IMessageModel>)messageViewController:(EaseMessageViewController *)viewController
                           modelForMessage:(EMMessage *)message{
    
    id<IMessageModel> model = [[EaseMessageModel alloc] initWithMessage:message];
    model.avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
    model.failImageName = @"imageDownloadFail";
    
    if (![Utils isValidStr:model.avatarURLPath]) {
        model.avatarURLPath = message.ext[SCFromAvatarURLPath];
    }
    
    if ([Utils isValidStr:message.ext[SCEMUserName]]) {
        model.nickname = message.ext[SCEMUserName];
    }
    
    return model;
    
}

@end
