//
//  SCMessageViewController.h
//  SC56
//
//  Created by SC on 16/7/26.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "EaseMessageViewController.h"

#define SCEMConversationName @"SCEMConversationName"
#define SCFromAvatarURLPath @"SCFromAvatarURLPath"
#define SCEMUserName @"SCEMUserName"

typedef enum{
    SCConversationTypeChat  = 0,    /*! \~chinese 单聊会话 \~english Chat */
    SCConversationTypeGroupChat,    /*! \~chinese 群聊会话 \~english Group chat */
    SCConversationTypeChatRoom      /*! \~chinese 聊天室会话 \~english Chatroom chat */
} SCConversationType;

@interface SCMessageViewController : EaseMessageViewController

@property (strong, nonatomic) NSString *fromAvatarURLPath;
@property (strong, nonatomic) NSString *toAvatarURLPath;
@property (strong, nonatomic) NSString *conversationName;

- (instancetype)initWithConversationChatter:(NSString *)conversationChatter conversationName:(NSString*)conversationName;

- (instancetype)initWithConversationChatter:(NSString *)conversationChatter conversationName:(NSString*)conversationName conversationType:(SCConversationType)conversationType;

@end
