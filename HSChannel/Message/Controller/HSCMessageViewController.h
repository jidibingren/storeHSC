//
//  HSCMessageViewController.h
//  HSChannel
//
//  Created by SC on 16/8/22.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "SCBaseViewController.h"
#import "HSCMessageModel.h"
#import "HSCMessageCell.h"
#import "HSCSysMessageCell.h"
#import "HSCSysNoticeDetailController.h"
#import "HSCCDViewController.h"
#import "HSCCNViewController.h"
#import "HSCCWViewController.h"

@interface HSCMessageListBaseController : SCDBTableViewController<SWTableViewCellDelegate>

@property (nonatomic, strong)NSMutableArray *hxMessagesArray;

+ (void)requestHXMessage:(void(^)(NSMutableArray *messages))callback;

- (void)requestData;

@end

@interface HSCMSystemListController : HSCMessageListBaseController

@end

@interface HSCMAllListController : HSCMessageListBaseController<EMClientDelegate,EMGroupManagerDelegate,EMContactManagerDelegate,EMChatroomManagerDelegate,EMChatManagerDelegate>

@end

@interface HSCMHuanXinListController : HSCMessageListBaseController

@end
