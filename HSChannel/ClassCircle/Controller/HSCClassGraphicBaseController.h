//
//  HSCClassGraphicBaseController.h
//  HSChannel
//
//  Created by SC on 16/9/1.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "SCMomentsViewController.h"
#import "HSCCGMomentsViewModel.h"
#import "HSCCGMomentsCell.h"
#import "HSCCGMomentsCommentModel.h"

@interface HSCClassGraphicBaseController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic) BOOL dataRequestedOnce;

@property(nonatomic, strong) UITableView* tableView;

@property(nonatomic, strong) NSMutableArray* viewModelsArray;

@property(nonatomic, strong) NSString* url;

@property(nonatomic, strong) NSString* listPath;
// 当前页码
@property(atomic,          ) NSInteger pageNo;

@property(nonatomic, strong) Class modelClass;

@property(nonatomic, strong) Class viewModelClass;

@property (nonatomic, strong)Class cellClass;

@property BOOL dontAutoLoad;

// 可选的属性
@property(nonatomic, strong) NSMutableDictionary* requestParams;

@property BOOL disableHeaderRefresh;

@property BOOL disableFooterRefresh;

- (instancetype)initWithModels:(NSArray*)models;

- (void)customAfterInit;

@end
