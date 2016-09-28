//
//  HSCCGMomentsViewModel.h
//  HSChannel
//
//  Created by SC on 16/9/1.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "SCMomentsViewModel.h"

@interface HSCCGMomentsViewModel : SCMomentsViewModel

@property (nonatomic, strong)HSCMessageModel *model;

@property (nonatomic, strong)NSString *id;

@property (nonatomic, strong)NSMutableArray *commentsArray;

@property (nonatomic, strong)NSMutableArray *likesArray;

@end
