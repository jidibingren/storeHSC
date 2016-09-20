//
//  SCChatToolbar.m
//  HSChannel
//
//  Created by SC on 16/9/2.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "SCChatToolbar.h"

@implementation SCChatToolbar

- (instancetype)initWithFrame:(CGRect)frame Type:(SCChatToolbarType)type{
    
    //初始化页面
    CGFloat chatbarHeight = [EaseChatToolbar defaultHeight];
    frame.size.height = chatbarHeight;
    self = [super initWithFrame:frame type:EMChatToolbarTypeChat];
    self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
    NSMutableArray *emotions = [NSMutableArray array];
    for (NSString *name in [EaseEmoji allEmoji]) {
        EaseEmotion *emotion = [[EaseEmotion alloc] initWithName:@"" emotionId:name emotionThumbnail:name emotionOriginal:name emotionOriginalURL:@"" emotionType:EMEmotionDefault];
        [emotions addObject:emotion];
    }
    EaseEmotion *emotion = [emotions objectAtIndex:0];
    EaseEmotionManager *manager= [[EaseEmotionManager alloc] initWithType:EMEmotionDefault emotionRow:3 emotionCol:7 emotions:emotions tagImage:[UIImage imageNamed:emotion.emotionId]];
    [(EaseFaceView*)self.faceView setEmotionManagers:@[manager]];
    
    if (type == SCChatToolbarText) {
        NSMutableArray *tempItems = [[NSMutableArray alloc]initWithObjects:self.inputViewRightItems[1],nil];
        self.inputViewLeftItems = nil;
        self.inputViewRightItems = tempItems;
    }
    
    return self;
}

@end
