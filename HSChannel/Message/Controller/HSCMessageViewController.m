//
//  HSCMessageViewController.m
//  HSChannel
//
//  Created by SC on 16/8/22.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "HSCMessageViewController.h"

@implementation HSCMessageListBaseController

- (void)viewDidLoad {
    
    self.url = HSC_URL_NOTICE_LIST;
    self.listPath = @"data";
    
    self.cellHeight = 90;
    self.cellClass = [HSCMessageCell class];
    self.cellDataClass = [HSCMessageModel class];
    self.separatorLineMarginLeft = 70;
    
    CGRect frame = CGRectZero;
    frame.origin.y = 2;
    frame.size.width = ScreenWidth;
    frame.size.height = ScreenHeight - 64 - 2;
    self.customFrame = frame;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)requestData{
    
    DEFINE_WEAK(self);
    
    [self.class requestHXMessage:^(NSMutableArray *messages) {
        
        [wself sortData:messages];
        
        wself.hxMessagesArray = messages;
        
        [wself resetData];
        
    }];
    
}

- (void)resetData{
    
    if (self.dataArray == nil) {
        self.dataArray = [NSMutableArray new];
    }
    
    SCUserInfo *userInfo = [SCUserInfo sharedInstance];
    NSMutableArray *tempArray = [NSMutableArray new];
    
    if (userInfo.unreadMessage.count > 0) {
        
        HSCMessageModel *lastModel = userInfo.unreadMessage.firstObject;
        
        lastModel.unreadCount = userInfo.unreadMessageCount;
        
        [tempArray addObject:lastModel];
        
    }
    
    if (userInfo.unreadSN.count > 0) {
        
        HSCMessageModel *lastModel = userInfo.unreadSN.firstObject;
        
        lastModel.unreadCount = userInfo.unreadSNCount;
        
        [tempArray addObject:lastModel];
        
    }
    
    if (userInfo.unreadCN.count > 0) {
        
        HSCMessageModel *lastModel = userInfo.unreadCN.firstObject;
        
        lastModel.unreadCount = userInfo.unreadCNCount;
        
        [tempArray addObject:lastModel];
        
    }
    
    if (userInfo.unreadCD.count > 0) {
        
        HSCMessageModel *lastModel = userInfo.unreadCD.firstObject;
        
        lastModel.unreadCount = userInfo.unreadCDCount;
        
        [tempArray addObject:lastModel];
        
    }
    
    if (userInfo.unreadCW.count > 0) {
        
        HSCMessageModel *lastModel = userInfo.unreadCW.firstObject;
        
        lastModel.unreadCount = userInfo.unreadCWCount;
        
        [tempArray addObject:lastModel];
        
    }
    
    [self.dataArray removeAllObjects];
    
    if (tempArray.count > 0) {
        
        [self.dataArray addObjectsFromArray:tempArray];
        
    }
    
    if (self.hxMessagesArray.count > 0) {
        
        [self.dataArray addObjectsFromArray:self.hxMessagesArray];
        
    }
    
    [self.tableView reloadData];
    
}

+ (void)requestHXMessage:(void(^)(NSMutableArray *messages))callback{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
        if (![Utils isValidArray:conversations]) {
            conversations = [[EMClient sharedClient].chatManager loadAllConversationsFromDB];
        }
        NSMutableArray *tempArray = [NSMutableArray new];
        
        NSInteger unreadCount = 0;
        
        for (EMConversation *item in conversations) {
            
//            if (item.type != EMConversationTypeChat) {
//                continue;
//            }
            
            HSCMessageModel *data = [HSCMessageModel new];
            data.fromUsername = item.conversationId;
            data.chatType = item.type;
            
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            EMMessage *message = item.latestMessage;
            double timeInterval = message.timestamp ;
            if(timeInterval > 140000000000) {
                timeInterval = timeInterval / 1000;
            }
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
            data.timeStr = [dateFormatter stringFromDate:date];
            data.createTim = (NSInteger)timeInterval;
            data.title =  message.ext[SCEMUserName];
            data.message = item.latestMessage;
            data.messageType = HSCMessageHuanXin;
            data.unreadCount = item.unreadMessagesCount;
            unreadCount += item.unreadMessagesCount;
            data.imgUrl = message.ext[SCFromAvatarURLPath];
            
            switch (item.type) {
                case EMConversationTypeChat:
                {
                    NSArray<HSCContactModel*> *contacts = [HSCContactModel findByCriteria:[NSString stringWithFormat:@"WHERE hxAccount IS \'%@\'", item.conversationId]];
                    data.title = contacts.count > 0 ? contacts[0].name : item.conversationId;
                }
                    break;
                case EMConversationTypeGroupChat:
                {
                    EMGroup *group = [[EMClient sharedClient].groupManager fetchGroupInfo:item.conversationId includeMembersList:NO error:nil];
                    data.title = group.subject;
                }
                    break;
                case EMConversationTypeChatRoom:
                {
                    EMChatroom *chatroom = [[EMClient sharedClient].roomManager fetchChatroomInfo:item.conversationId includeMembersList:NO error:nil];
                    data.title = chatroom.subject;
                }
                    break;
                    
                default:
                    break;
            }
            
            [tempArray addObject:data];
        }
        
        if (tempArray.count > 0) {
            
            if (callback) {
                callback(tempArray);
            }
            
        }
        
    });
    
}

- (void)sortData:(NSMutableArray*)array{
    
    [array sortUsingComparator:^NSComparisonResult(HSCMessageModel *obj1, HSCMessageModel *obj2) {
        return obj1.createTim < obj2.createTim;
    }];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HSCMessageCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.dataArray.count) {
        HSCMessageModel *data = self.dataArray[indexPath.row];
        if (data.messageType == HSCMessageSystem) {
            if ([self isMemberOfClass:[HSCMSystemListController class]]) {
                if (!data.isRead) {
                    [SCUserInfo sharedInstance].unreadMessageCount -= 1;;
                }
                data.isRead = YES;
                NSMutableDictionary *params = [NSMutableDictionary new];
                params[@"msgeIds"] = data.id;
                [SCHttpTool postWithURL:HSC_URL_NOTICE_READ params:params success:nil failure:nil];
                [data update];
                
                [self.navigationController pushViewController:[[HSCSysNoticeDetailController alloc]initWithNoticeId:data] animated:YES];
                
            }else{
                
                data.unreadCount = 0;
                
                switch (data.type) {
                    case 0:
                        
                        [SCUserInfo sharedInstance].unreadMessageCount = 0;
                        
                        [self.navigationController pushViewController:[HSCMSystemListController new] animated:YES];
                        
                        break;
                    case 1:
                        
                        [SCUserInfo sharedInstance].unreadSNCount = 0;
                        
                        [self.navigationController pushViewController:[[HSCSNListController alloc]initWithAutoLoad:NO] animated:YES];
                        
                        break;
                    case 2:
                        
                        [SCUserInfo sharedInstance].unreadCNCount = 0;
                        
                        [self.navigationController pushViewController:[[HSCCNViewController alloc]initWithModels:[SCUserInfo sharedInstance].unreadCN] animated:YES];
                        
                        break;
                    case 3:
                        
                        [SCUserInfo sharedInstance].unreadCDCount = 0;
                        
                        [self.navigationController pushViewController:[[HSCCDViewController alloc]initWithModels:[SCUserInfo sharedInstance].unreadCD] animated:YES];
                        
                        break;
                    case 4:
                        
                        [SCUserInfo sharedInstance].unreadCWCount = 0;
                        
                        [self.navigationController pushViewController:[[HSCCWViewController alloc]initWithModels:[SCUserInfo sharedInstance].unreadCW] animated:YES];
                        
                        break;
                        
                    default:
                        break;
                }
            }
            
        }else{
            
            data.unreadCount = 0;
            
            [self.navigationController pushViewController:[[SCMessageViewController alloc]initWithConversationChatter:data.fromUsername conversationName:data.title conversationType:data.chatType] animated:YES];
        }
        
        [self.tableView reloadData];
    }
}

#pragma mark - SWTableViewCellDelegate

- (void)swipeableTableViewCell:(HSCMessageCell *)cell scrollingToState:(SWCellState)state
{
    switch (state) {
        case 0:
            NSLog(@"utility buttons closed");
            break;
        case 1:
            NSLog(@"left utility buttons open");
            break;
        case 2:
            [self deleteCell:cell];
            break;
        default:
            break;
    }
}

-(void)swipeableTableViewCell:(HSCMessageCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index{
    
    if (index == 0) {
        
        [self deleteCell:cell];
        
    }
}

- (void)deleteCell:(HSCMessageCell *)cell{
    
    if (cell.cellData.messageType == HSCMessageSystem) {
        
        if ([self isKindOfClass:[HSCMAllListController class]]) {
            
            SCUserInfo *userInfo = [SCUserInfo sharedInstance];
            
            switch (cell.cellData.type) {
                case 0:
                    
                    userInfo.unreadMessageCount = 0;
                    
                    [userInfo.unreadMessage removeAllObjects];
                    
                    break;
                case 1:
                    
                    userInfo.unreadSNCount = 0;
                    
                    [userInfo.unreadSN removeAllObjects];
                    
                    break;
                case 2:
                    
                    userInfo.unreadCNCount = 0;
                    
                    [userInfo.unreadCN removeAllObjects];
                    
                    break;
                case 3:
                    
                    userInfo.unreadCDCount = 0;
                    
                    [userInfo.unreadCD removeAllObjects];
                    
                    break;
                case 4:
                    
                    userInfo.unreadCWCount = 0;
                    
                    [userInfo.unreadCW removeAllObjects];
                    
                    break;
                    
                default:
                    break;
            }
        }
        
        [cell.cellData deleteObject];
        
    }else if (cell.cellData.messageType == HSCMessageHuanXin) {
        [[EMClient sharedClient].chatManager deleteConversation:cell.cellData.fromUsername deleteMessages:YES];
    }
    
    [self.dataArray removeObject:cell.cellData];
    
    [self.tableView deleteRowsAtIndexPaths:@[cell.indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}

@end

@implementation HSCMSystemListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"系统通知";
}

- (void)customizeTableView{
    
    [super customizeTableView];
    
    self.cellHeight = 100;
    self.cellClass = [HSCSysMessageCell class];
    self.cellDataClass = [HSCMessageModel class];
    self.separatorLineMarginLeft = 10;
    
}

- (NSString *)findSQL:(BOOL)newer{
    
    NSString *sqlStr = nil;
    
    if (newer) {
        
        sqlStr = @"order by createTim desc limit 10";
        
    }else{
        
        HSCMessageModel *data = self.dataArray.lastObject;
        
        sqlStr = [NSString stringWithFormat:@"where creat < %lld order by createTim desc limit 10",data.createTim];
        
    }
    
    return sqlStr;
}

@end

@implementation HSCMAllListController

- (void)viewDidLoad {
    
    self.dontAutoLoad = YES;
    
    [super viewDidLoad];
    
    self.title = @"消息";
    
    self.tableView.mj_header = nil;
    self.tableView.mj_footer = nil;
    
    DEFINE_WEAK(self);
    
//    [self requestData];
    
    [self.observer observe:[SCUserInfo sharedInstance] keyPath:@"unreadMessageCount" blockForNew:^(HSCMAllListController*  _Nullable observer, id  _Nonnull object, NSNumber * _Nonnull change) {
        
        [observer resetData];
//        [observer.tableView reloadData];
        
    }];
    
    [SCHttpTool requestNewMessage];
    
    [[EMClient sharedClient] addDelegate:self delegateQueue:dispatch_queue_create("HSC_EMCLIENT", 0)];
//
//    [[EMClient sharedClient].groupManager addDelegate:self delegateQueue:dispatch_queue_create("HSC_EMGROUP", 0)];
//    
//    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:dispatch_queue_create("HSC_EMCONTACT", 0)];
//    
//    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:dispatch_queue_create("HSC_EMCHAT", 0)];
//    
//    [[EMClient sharedClient].roomManager addDelegate:self delegateQueue:dispatch_queue_create("HSC_EMROOM", 0)];
    
}

- (void)dealloc{
    
    [[EMClient sharedClient].groupManager removeDelegate:self];
    
    [[EMClient sharedClient].contactManager removeDelegate:self];
    
    [[EMClient sharedClient].chatManager removeDelegate:self];
    
    [[EMClient sharedClient].roomManager removeDelegate:self];
    
    [[EMClient sharedClient] removeDelegate:self];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self requestData];
    
}

#pragma mark -
- (void)didConnectionStateChanged:(EMConnectionState)aConnectionState{
    
    if ([EMClient sharedClient].isLoggedIn) {
        
        [[EMClient sharedClient].groupManager addDelegate:self delegateQueue:dispatch_queue_create("HSC_EMGROUP", 0)];
        
        [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:dispatch_queue_create("HSC_EMCONTACT", 0)];
        
        [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:dispatch_queue_create("HSC_EMCHAT", 0)];
        
        [[EMClient sharedClient].roomManager addDelegate:self delegateQueue:dispatch_queue_create("HSC_EMROOM", 0)];
        
        [self requestData];
        
    }else{
        
        [[EMClient sharedClient].groupManager removeDelegate:self];
        
        [[EMClient sharedClient].contactManager removeDelegate:self];
        
        [[EMClient sharedClient].chatManager removeDelegate:self];
        
        [[EMClient sharedClient].roomManager removeDelegate:self];

    }
    
    
}

#pragma mark - EMGroupManagerDelegate

- (void)didReceiveGroupInvitation:(NSString *)aGroupId
                          inviter:(NSString *)aInviter
                          message:(NSString *)aMessage{
}

- (void)didReceiveAcceptedGroupInvitation:(EMGroup *)aGroup
                                  invitee:(NSString *)aInvitee{
    
}

- (void)didReceiveDeclinedGroupInvitation:(EMGroup *)aGroup
                                  invitee:(NSString *)aInvitee
                                   reason:(NSString *)aReason{
    
}

- (void)didJoinedGroup:(EMGroup *)aGroup
               inviter:(NSString *)aInviter
               message:(NSString *)aMessage{
    
}

- (void)didReceiveLeavedGroup:(EMGroup *)aGroup
                       reason:(EMGroupLeaveReason)aReason{
    
}


- (void)didReceiveJoinGroupApplication:(EMGroup *)aGroup
                             applicant:(NSString *)aApplicant
                                reason:(NSString *)aReason{
    
}

- (void)didReceiveDeclinedJoinGroup:(NSString *)aGroupId
                             reason:(NSString *)aReason{
    
}

- (void)didReceiveAcceptedJoinGroup:(EMGroup *)aGroup{
    
}

- (void)didUpdateGroupList:(NSArray *)aGroupList{
    
    [self requestData];
    
}

#pragma mark - EMContactManagerDelegate
- (void)didReceiveAgreedFromUsername:(NSString *)aUsername{

}

- (void)didReceiveDeclinedFromUsername:(NSString *)aUsername{
    
}

- (void)didReceiveDeletedFromUsername:(NSString *)aUsername{
    
}

- (void)didReceiveAddedFromUsername:(NSString *)aUsername{
    
}

- (void)didReceiveFriendInvitationFromUsername:(NSString *)aUsername
                                       message:(NSString *)aMessage{
    [self requestData];
}

#pragma mark - EMChatroomManagerDelegate
- (void)didReceiveUserJoinedChatroom:(EMChatroom *)aChatroom
                            username:(NSString *)aUsername{
    [self requestData];
}

- (void)didReceiveUserLeavedChatroom:(EMChatroom *)aChatroom
                            username:(NSString *)aUsername{
    
}

- (void)didReceiveKickedFromChatroom:(EMChatroom *)aChatroom
                              reason:(EMChatroomBeKickedReason)aReason{
    
}

#pragma mark - EMChatManagerDelegate

- (void)didUpdateConversationList:(NSArray *)aConversationList{
    
    [self requestData];
    
}

- (void)didReceiveMessages:(NSArray *)aMessages{
    
    [self requestData];
    
}

- (void)didReceiveCmdMessages:(NSArray *)aCmdMessages{
    
    [self requestData];
    
}

- (void)didReceiveHasReadAcks:(NSArray *)aMessages{
    
    [self requestData];
    
}

- (void)didReceiveHasDeliveredAcks:(NSArray *)aMessages{
    
    [self requestData];
    
}

- (void)didMessageStatusChanged:(EMMessage *)aMessage
                          error:(EMError *)aError{
    
}

- (void)didMessageAttachmentsStatusChanged:(EMMessage *)aMessage
                                     error:(EMError *)aError{
    
}

@end

@implementation HSCMHuanXinListController

- (void)viewDidLoad {
    
    self.dontAutoLoad = YES;
    [super viewDidLoad];
    
    self.title = @"聊天";
    
    self.tableView.mj_header = nil;
    self.tableView.mj_footer = nil;
    [self requestData];
}

@end
