//
//  HSCClassGraphicBaseController.m
//  HSChannel
//
//  Created by SC on 16/9/1.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "HSCClassGraphicBaseController.h"

@interface HSCClassGraphicBaseController ()<UITableViewDataSource,UITableViewDelegate,SCMomentsCellDelegate,UITextFieldDelegate,EMChatToolbarDelegate>

@property (nonatomic, strong)SCChatToolbar *chatToolbar;

@end

@implementation HSCClassGraphicBaseController
{
    CGFloat _lastScrollViewOffsetY;
    UITextField *_textField;
    CGFloat _totalKeybordHeight;
    NSIndexPath *_currentEditingIndexthPath;
    UITapGestureRecognizer *_tap;
    HSCCGMomentsCommentModel *_commentModel;
    HSCCGMomentsCell *_cell;
    NSString *_linkText;
}

- (instancetype)initWithModels:(NSArray*)models{
    
    if (self = [super init]) {
        
        _viewModelsArray = [NSMutableArray new];
        
        for (HSCMessageModel *model in models) {
            HSCCGMomentsViewModel *viewModel = [[HSCCGMomentsViewModel alloc]init];
            viewModel.model = model;
            [_viewModelsArray addObject:viewModel];
        }
        
        [self customAfterInit];
    }
    
    return self;
    
}

- (instancetype)init{
    
    if (self = [super init]) {
        [self customAfterInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super initWithCoder:aDecoder]) {
        [self customAfterInit];
    }
    return self;
}

//- (instancetype)initWithStyle:(UITableViewStyle)style{
//    
//    if (self = [super initWithStyle:style]) {
//        [self customAfterInit];
//    }
//    return self;
//}

- (void)customAfterInit{
    
    self.hidesBottomBarWhenPushed = YES;
    
    self.cellClass = [HSCCGMomentsCell class];
    
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self customAfterInit];
    }
    return self;
}

// 键盘高度
static CGFloat textFieldH = 40;

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewDidLoad {
    
    if (!_viewModelsArray) {
        _viewModelsArray = [NSMutableArray new];
    }else{
        self.dontAutoLoad = YES;
    }
    
    [super viewDidLoad];
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
        
    }
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setupTableView];
    
    [self setupChatToolbar];
    
    if (self.dontAutoLoad) {
        [self.tableView reloadData];
    }else{
        
        [self.tableView.mj_header beginRefreshing];
    }
    
    // 键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

#pragma mark - setupChatToolbar

- (void)setupChatToolbar{
    
    _chatToolbar = [[SCChatToolbar alloc]initWithFrame:CGRectMake(0, ScreenHeight-49, ScreenWidth, 0) Type:SCChatToolbarText];
    _chatToolbar.delegate = self;
    [self.view addSubview:_chatToolbar];
    [_chatToolbar setHidden:YES];
    
    //初始化手势
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyBoardHidden:)];
    [self.view addGestureRecognizer:_tap];
    [_tap setEnabled:NO];
    
    
}
// 点击背景隐藏
-(void)keyBoardHidden:(UITapGestureRecognizer *)tapRecognizer
{
    if (tapRecognizer.state == UIGestureRecognizerStateEnded) {
        [self stopComment];
    }
}

- (void)stopComment{
    
    [_chatToolbar setHidden:YES];
    [_tap setEnabled:NO];
    [self.chatToolbar endEditing:YES];
}

#pragma mark - setupTableView
- (void)setupTableView {
    
    if (!_cellClass) {
        _cellClass = [HSCCGMomentsCell class];
    }
    
    if (!_modelClass) {
        _modelClass = [HSCMessageModel class];
    }
    
    if (!_viewModelClass) {
        _viewModelClass = [HSCCGMomentsViewModel class];
    }
    
    [self.tableView registerClass:_cellClass forCellReuseIdentifier:NSStringFromClass(_cellClass)];
    
    self.tableView.estimatedRowHeight = 300;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (!_disableHeaderRefresh)
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    if (!_disableFooterRefresh)
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];

    [self customizeTableView];

}

- (void)headerRereshing
{
    [self loadData: YES];
}

- (void)footerRereshing
{
    [self loadData: NO];
}

- (void)customizeTableView{
    
}

- (void)dataReceidSuccessful:(NSDictionary *)dic newer:(BOOL)newer
{
    
    if (newer) {
        [_viewModelsArray removeAllObjects];
        _pageNo = 1;
    }
    NSArray * array = [dic valueForKeyPath: _listPath];
    if ([Utils isNilOrNSNull:array] || array.count == 0) {
        [[Utils getDefaultWindow] makeShortToastAtCenter:@"没有更多了"];
        [self endRefreshing: newer];
        return;
    }
    _pageNo += 1;
    
    for (NSDictionary * item in array) {
        HSCMessageModel* model = [[_modelClass alloc] init];
        if ([item isKindOfClass:[NSDictionary class]]){
            [model updateWithDictionary:item];
            HSCCGMomentsViewModel *viewModel = [[_viewModelClass alloc]init];
            viewModel.model = model;
            [_viewModelsArray addObject:viewModel];
        }
    }
    [self.tableView reloadData];
    [self endRefreshing: newer];
}

// loadData, newer: 请求更加新的数据
- (void)loadData:(BOOL)newer
{
    
    NSInteger pageNo = 1;
    if (!newer && _viewModelsArray.count > 0) {
        pageNo = _pageNo;
    }
    if (!_requestParams)
        _requestParams = [[NSMutableDictionary alloc]initWithCapacity:1];
    
    [self customizeParams: _requestParams newer:newer];
    DEFINE_WEAK(self);
    
#ifdef SC_TP_AFNETWORKING
    [SCHttpTool postWithURL:_url params:_requestParams success:^(id json) {
        [wself dataReceidSuccessful:json newer: newer];
        wself.dataRequestedOnce = YES;
    } failure:^(NSError *error) {
        [wself.view makeShortToastAtCenter: [error localizedDescription]];
        [wself endRefreshing: newer];
        wself.dataRequestedOnce = YES;
    } ];
#endif
}

- (void) customizeParams: (NSMutableDictionary*)params newer:(BOOL)newer {
    
    HSCCGMomentsViewModel *viewModel = self.viewModelsArray.lastObject;
    
    if (newer) {
        
        viewModel = nil;
        
    }
    
    params[@"createTim"] = viewModel ? @(viewModel.model.createTim) : @(0);
    
}

- (void) endRefreshing: (BOOL) newer {
#ifdef SC_TP_MJREFRESH
    if (newer) {
        [self.tableView.mj_header endRefreshing];
    } else {
        [self.tableView.mj_footer endRefreshing];
    }
#endif
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModelsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCMomentsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(_cellClass) forIndexPath:indexPath];
    cell.indexPath = indexPath;
    if (cell.delegate == nil) {
        cell.delegate = self;
    }
    if (!cell.operationButtonClick) {
        [cell setOperationButtonClick:^(NSIndexPath *indexPath) {
            
        }];
    }
    
    SCMomentsViewModel *viewModel = self.viewModelsArray[indexPath.row];
    cell.viewModel = viewModel;
    
    return cell;
    
}

#pragma mark - SCMomentsCellDelegate

- (void)didClickOpenAllButtonInCell:(SCMomentsCell *)cell{
    
    NSIndexPath *indexPath = cell.indexPath;
    SCMomentsViewModel *model = self.viewModelsArray[indexPath.row];
    model.isOpening = !model.isOpening;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)didClickDeleteButtonInCell:(SCMomentsCell *)cell{
    
}

- (void)didClickLikeButtonInCell:(SCMomentsCell *)cell
{
    NSIndexPath *indexPath = cell.indexPath;
    
    HSCCGMomentsViewModel *model = cell.viewModel;
//    NSMutableArray *temp = [NSMutableArray arrayWithArray:model.likeItemsArray];

    DEFINE_WEAK(self);
    DEFINE_WEAK(model);
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    params[@"id"] = [model id];
    
    [SCHttpTool postWithURL:HSC_URL_NOTICE_LIKE params:params success:^(NSDictionary *json) {
        if (!wmodel.isLiked) {
            wmodel.liked = YES;
            wmodel.likeCount++;
        } else {
            wmodel.liked = NO;
            wmodel.likeCount--;
        }
        
        
        [wself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    } failure:nil];
    
}

- (void)didClickcCommentButtonInCell:(SCMomentsCell *)cell
{
    
    HSCCGMomentsViewModel *viewModel = cell.viewModel;
    
    if (viewModel.isCommentOpening) {
        
        [self startCommentText:nil commentModel:nil inCell:cell];
        
        return;
        
        viewModel.isCommentOpening = NO;
        
        [self.tableView reloadRowsAtIndexPaths:@[cell.indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }else{
        
        [self requestReplayWith:viewModel indexPath:cell.indexPath];
        
    }
    
    //    [_textField becomeFirstResponder];
    //    _currentEditingIndexthPath = [self.tableView indexPathForCell:cell];
    //    [self adjustTableViewToFitKeyboard];
}
- (void)didTapedComment:(SCMomentsCellCommentItemModel *)commentModel inCell:(SCMomentsCell *)cell{
    
    [self startCommentText:nil commentModel:commentModel inCell:cell];
}

- (void)didClickCommentText:(NSString *)commentText commentModel:(SCMomentsCellCommentItemModel *)commentModel inCell:(SCMomentsCell *)cell{
    
    [self startCommentText:commentText commentModel:commentModel inCell:cell];

}

- (void)didLongPressCommentText:(NSString *)commentText commentModel:(SCMomentsCellCommentItemModel *)commentModel inCell:(SCMomentsCell *)cell{
    
    
}

- (void)startCommentText:(NSString *)commentText commentModel:(SCMomentsCellCommentItemModel *)commentModel inCell:(SCMomentsCell *)cell{
    
    if (commentModel != nil && [(HSCCGMomentsCommentModel*)commentModel model].level != 1){
        
        return;
        
    }
    
    _linkText = commentText;
    
    _commentModel = commentModel;
    
    _cell = cell;
    
    [_chatToolbar setHidden:NO];
    [_tap setEnabled:YES];
    [_chatToolbar.inputTextView becomeFirstResponder];
    
}

- (void)stopCommentWithText:(NSString *)text ext:(NSString *)ext{
    
    if (![Utils isValidStr:text]) {
        [self.view makeShortToastAtCenter:@"内容为空!"];
        return;
    }
    
    [self stopComment];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    HSCCGMomentsViewModel *model = _cell.viewModel;
    
    params[@"noticeId"] = model.model.id;
    
    if (_commentModel) {
        params[@"replyUsername"] = _commentModel.model.name;
        params[@"level"] = @(2);
        params[@"replyId"] = _commentModel.model.id;
    }else{
        params[@"replyUsername"] = model.model.fromUser;
        params[@"level"] = @(1);
        params[@"replyId"] = model.id;
    }
    
    params[@"content"] = text;
    
    NSIndexPath *indexPath = _cell.indexPath;
    
    DEFINE_WEAK(self);
    
    [SCHttpTool postWithURL:HSC_URL_NOTICE_REPLY_ADD params:params success:^(NSDictionary *json) {
        
        [wself requestReplayWith:model indexPath:indexPath];
        
    } failure:nil];
    
    
    _linkText = nil;
    
    _commentModel = nil;
    
    _cell = nil;

    
}

- (void)requestReplayWith:(HSCCGMomentsViewModel *)viewModel indexPath:(NSIndexPath *)indexPath{
    DEFINE_WEAK(self);
    DEFINE_WEAK(viewModel);
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"noticeId"] = viewModel.model.id;
    
    [SCHttpTool postWithURL:HSC_URL_NOTICE_REPLY params:params success:^(NSDictionary *json) {
        if ([Utils isValidArray:[json valueForKeyPath:@"info.reply"]]) {
            
            NSMutableArray *tempArray = [NSMutableArray new];
            
            for (NSDictionary *dict in [json valueForKeyPath:@"info.reply"]) {
                
                HSCCGReplyModel *model = [[HSCCGReplyModel alloc]initWithDictionary:dict];
                HSCCGMomentsCommentModel *commentModel = [HSCCGMomentsCommentModel new];
                commentModel.model = model;
                
                [tempArray addObject:commentModel];
            }
            
            wviewModel.commentsArray = tempArray;
            
            
            wviewModel.isCommentOpening = YES;
            
            [wself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
        }
    } failure:nil];
}

- (void)adjustTableViewToFitKeyboard:(CGFloat)height
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_cell.indexPath];
    CGRect rect = [cell.superview convertRect:cell.frame toView:window];
    CGFloat delta = CGRectGetMaxY(rect) - (window.bounds.size.height - height);
    
    CGPoint offset = self.tableView.contentOffset;
    offset.y += delta;
    if (offset.y < 0) {
        offset.y = 0;
    }
    [self.tableView setContentOffset:offset animated:YES];
}

#pragma mark - EMChatToolbarDelegate

- (void)didSendText:(NSString *)text{
    
    [self stopCommentWithText:text ext:nil];
}

- (void)didSendText:(NSString *)text withExt:(NSDictionary*)ext{
    
    [self stopCommentWithText:text ext:ext];
}

- (void)didSendFace:(NSString *)faceLocalPath{
    
}


- (void)didDragOutsideAction:(UIView *)recordView{
    
}

- (void)didDragInsideAction:(UIView *)recordView{
    
}

- (void)chatToolbarDidChangeFrameToHeight:(CGFloat)toHeight{
    
    [self adjustTableViewToFitKeyboard:toHeight];
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length) {
        [_textField resignFirstResponder];
        
        SCMomentsViewModel *viewModel = self.viewModelsArray[_currentEditingIndexthPath.row];
        NSMutableArray *temp = [NSMutableArray new];
        [temp addObjectsFromArray:viewModel.commentItemsArray];
        
        SCMomentsCellCommentItemModel *commentItemModel = [SCMomentsCellCommentItemModel new];
        commentItemModel.firstUserName = @"二哥";
        commentItemModel.commentString = textField.text;
        commentItemModel.firstUserId = @"二哥";
        [temp addObject:commentItemModel];
        
        viewModel.commentItemsArray = [temp copy];
        
        [self.tableView reloadRowsAtIndexPaths:@[_currentEditingIndexthPath] withRowAnimation:UITableViewRowAnimationNone];
        
        _textField.text = @"";
        
        return YES;
    }
    return NO;
}

#pragma mark - 键盘处理
- (void)keyboardNotification:(NSNotification *)notification
{
//    NSDictionary *dict = notification.userInfo;
//    CGRect rect = [dict[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
//    
//    CGRect textFieldRect = CGRectMake(0, rect.origin.y - textFieldH, rect.size.width, textFieldH);
//    if (rect.origin.y == [UIScreen mainScreen].bounds.size.height) {
//        textFieldRect = rect;
//    }
//    
//    [UIView animateWithDuration:0.25 animations:^{
//        _textField.frame = textFieldRect;
//    }];
//    
//    CGFloat h = rect.size.height + textFieldH;
//    if (_totalKeybordHeight != h) {
//        _totalKeybordHeight = h;
//        [self adjustTableViewToFitKeyboard];
//    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 测试用
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_textField resignFirstResponder];
}
@end