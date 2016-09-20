//
//  HSCCGReplyModel.h
//  HSChannel
//
//  Created by SC on 16/9/1.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "SCTableViewController.h"

@interface HSCCGReplyModel : SCTableViewCellData

@property (nonatomic, strong)NSString *id;
@property (nonatomic, assign)NSInteger level;
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *username;
@property (nonatomic, strong)NSString *userImage;
@property (nonatomic, strong)NSString *replyId;
@property (nonatomic, strong)NSString *replyName;
@property (nonatomic, strong)NSString *replyUsername;
@property (nonatomic, strong)NSString *replyImage;
@property (nonatomic, strong)NSString *content;
@property (nonatomic, assign)long long createTim;

@end
