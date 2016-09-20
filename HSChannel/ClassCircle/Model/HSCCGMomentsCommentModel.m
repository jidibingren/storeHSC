//
//  HSCCGMomentsCommentModel.m
//  HSChannel
//
//  Created by SC on 16/9/1.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "HSCCGMomentsCommentModel.h"

@implementation HSCCGMomentsCommentModel

-(NSString *)commentString{
    return _model.content;
}

-(NSString *)firstUserName{
    return _model.name;
}

-(NSString *)firstUserId{
    return _model.id;
}

-(NSString *)secondUserName{
    return _model.level == 1 ? nil : _model.replyName;
}

-(NSString *)secondUserId{
    return _model.level == 1 ? nil : _model.replyId;
}

@end
