//
//  HSCMessageModel.h
//  HSChannel
//
//  Created by SC on 16/8/24.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import <JDModel/JDModel.h>

typedef NS_ENUM(NSInteger, HSCMessageType) {
    HSCMessageSystem = 0,
    HSCMessageHuanXin
};


@interface HSCMessageModel : SCDBModel

@property (nonatomic, assign)HSCMessageType messageType;
@property (nonatomic, strong)NSString *id;
@property (nonatomic, assign)NSInteger type;
@property (nonatomic, strong)NSString *typeName;
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *content;
@property (nonatomic, strong)NSArray  *images;
@property (nonatomic, assign)long long createTim;
@property (nonatomic, assign)NSInteger likeCount;
@property (nonatomic, assign)NSInteger replyCount;
@property (nonatomic, assign)NSInteger isLike;
@property (nonatomic, assign)NSInteger isRead;
@property (nonatomic, strong)NSString *range;
@property (nonatomic, strong)NSString *fromUser;
@property (nonatomic, strong)NSString *fromUserImage;
@property (nonatomic, strong)NSString *contentType;
@property (nonatomic, strong)NSString *contentId;

@property (nonatomic, assign)SCConversationType chatType;
@property (nonatomic, strong)NSString *fromUsername;
@property (nonatomic, strong)NSString *imgUrl;
@property (nonatomic, assign)NSInteger unreadCount;
@property (nonatomic, strong)EMMessage *message;
@property (nonatomic, strong)NSString  *timeStr;

@end
