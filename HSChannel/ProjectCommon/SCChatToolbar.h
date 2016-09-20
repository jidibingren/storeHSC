//
//  SCChatToolbar.h
//  HSChannel
//
//  Created by SC on 16/9/2.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import <EaseUI/EaseUI.h>

typedef NS_ENUM(NSInteger, SCChatToolbarType) {
    SCChatToolbarDefault = 0,
    SCChatToolbarText
};

@interface SCChatToolbar : EaseChatToolbar

- (instancetype)initWithFrame:(CGRect)frame Type:(SCChatToolbarType)type;

@end
