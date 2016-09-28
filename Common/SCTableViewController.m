//
//  SCTableViewController.m
//  ShiHua
//  Copyright (c) 2014 shuchuang. All rights reserved.
//

#import "SCTableViewController.h"
#ifdef SC_TP_MJREFRESH
#import "MJRefresh.h"
#endif
#ifdef SC_TP_KEYVALUE_MAPPING
#import "DCKeyValueObjectMapping.h"
#endif

#pragma mark - SCTableViewCell implementation
@implementation SCTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubviewsWithFrame:self.frame];
    }
    return self;
}

- (void)setupSubviewsWithFrame:(CGRect)frame{
    
}

@end

@implementation SCTableViewHeaderFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setupSubviewsWithFrame:self.frame];
    }
    return self;
}

- (void)setupSubviewsWithFrame:(CGRect)frame{
    
}

@end

#pragma mark - SCTableViewCellData implementation
@interface SCTableViewCellData () 
@end

@implementation SCTableViewCellData

- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self updateWithDictionary:dic];
    }
    return self;
}

- (void) updateWithDictionary: (NSDictionary*)dic
{
#ifdef SC_TP_KEYVALUE_MAPPING
    if (!_dicParser) {
        
        DCParserConfiguration *config = [DCParserConfiguration configuration];
        
        [self additionParserConfig:config];
        
        _dicParser = [DCKeyValueObjectMapping mapperForClass:self.class andConfiguration:config];
        
    }
    [_dicParser updateObject:self withDictionary:dic];
#endif
}

- (void)additionParserConfig:(DCParserConfiguration*)config{
    
}

@end

#pragma mark - SCTableViewController implementation
@interface SCTableViewController () {
}

@end

@implementation SCTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _pageNo = 1;
    
    if (![Utils isNonnull:_dataArray]) {
        
        _dataArray = [NSMutableArray arrayWithCapacity:1];
        
    }
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:self.contentFrame style:UITableViewStylePlain];
        
    }

    _tableView.delegate = self;
    _tableView.dataSource = self;
#ifdef SC_TP_COLOR
    _tableView.backgroundColor = COLOR_GRAY_BACKGROUND;
#endif
    [_tableView dontShowBlankRows];
#ifdef SC_TP_MJREFRESH
    if (!_disableHeaderRefresh)
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    if (!_disableFooterRefresh)
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
#endif
    [self customizeTableView];
    
//    //    顶部加上一条线
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 0.5f)];
//    label.backgroundColor = _tableView.separatorColor;
//    [_tableView addSubview:label];
    
    [self.view addSubview:_tableView];
#ifdef SC_TP_MJREFRESH
    if (!self.dontAutoLoad)
        [_tableView.mj_header beginRefreshing];
#endif
}

- (void)setupSubviews{
    
    
    if (_cellClass) {
        [_tableView registerClass:_cellClass forCellReuseIdentifier:NSStringFromClass(_cellClass)];
    }
    
    if (_cellNibName) {
        [_tableView registerNib:[[[NSBundle mainBundle] loadNibNamed:_cellNibName owner:self options:nil] lastObject] forCellReuseIdentifier:_cellNibName];
    }
    
}

- (void) customizeTableView {

}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = CGRectEqualToRect(_customFrame,CGRectZero) ? self.view.bounds : _customFrame;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:_tableView.indexPathForSelectedRow animated:YES];
}
- (void)dataReceidSuccessful:(NSDictionary *)dic newer:(BOOL)newer
{
    assert(_cellDataClass && [_cellDataClass isSubclassOfClass:[SCTableViewCellData class]]);
    if (newer) {
        [_dataArray removeAllObjects];
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
        SCTableViewCellData* data = [[_cellDataClass alloc] init];
        if ([item isKindOfClass:[NSDictionary class]]){
            [data updateWithDictionary:item];
            [_dataArray addObject:data];
        }
    }
    [_tableView reloadData];
    [self endRefreshing: newer];
}

// loadData, newer: 请求更加新的数据
- (void)loadData:(BOOL)newer
{
//    NSString* lastId = @"";
    NSInteger pageNo = 1;
    if (!newer && _dataArray.count > 0) {
//        lastId = ((SCTableViewCellData*)_dataArray.lastObject).id;
        pageNo = _pageNo;
    }
    if (!_requestParams)
        _requestParams = [[NSMutableDictionary alloc]initWithCapacity:1];
//    _requestParams[_lastIdKey ?: @"lastId"] = lastId;
//    _requestParams[@"page"] = @(pageNo);
//    _requestParams[@"lng"] = @([SCUserInfo sharedInstance].curAddress.pt.longitude);
//    _requestParams[@"lat"] = @([SCUserInfo sharedInstance].curAddress.pt.latitude);

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
}

- (void) endRefreshing: (BOOL) newer {
#ifdef SC_TP_MJREFRESH
    if (newer) {
        [_tableView.mj_header endRefreshing];
    } else {
        [_tableView.mj_footer endRefreshing];
    }
#endif
}

- (void)headerRereshing
{
    [self loadData: YES];
}

- (void)footerRereshing
{
    [self loadData: NO];
}

// #pragma mark - TableView Data source and delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    assert(_cellNibName || (_cellClass && [_cellClass isSubclassOfClass:[SCTableViewCell class]] ));
    assert(_cellNibName || (_cellClass && [_cellClass instancesRespondToSelector:@selector(setData:)]));
    SCTableViewCellData * data = _dataArray.count > indexPath.row ? [_dataArray objectAtIndex:indexPath.row] : nil;
    static NSString * cellIndentifier = @"cell";
    SCTableViewCell * cell = (SCTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        if (_cellNibName) {
            cell = [[[NSBundle mainBundle] loadNibNamed:_cellNibName owner:self options:nil] lastObject];
        } else {
            cell = [[_cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        }
    }
    
    if ([cell respondsToSelector:@selector(setData:indexPath:)]){
        
        [cell performSelector:@selector(setData:indexPath:) withObject:data withObject:indexPath];
        
    }else{
        
        [cell setData: data];

    }
    
    return cell;
}

// implement UITableViewNXEmptyViewDataSource
- (BOOL) tableViewShouldBypassNXEmptyView:(UITableView *)tableView {
    // 当请求过一次数据之后才显示empty view
    return !_dataRequestedOnce;
}


//高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    assert(_cellHeight);
    return _cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return _cellHeight;
    
}

//选中的时候调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

//IOS8 设置TableView Separatorinset 分割线从边框顶端开始(7  8  都可用)
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,_separatorLineMarginLeft,0,_separatorLineMarginRight)];
    }
#ifdef __IPHONE_8_0
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,_separatorLineMarginLeft,0,_separatorLineMarginRight)];
    }
#endif
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0,_separatorLineMarginLeft,0,_separatorLineMarginRight)];
    }
#ifdef __IPHONE_8_0
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0,_separatorLineMarginLeft,0,_separatorLineMarginRight)];
    }
#endif
}

@end

#pragma mark - SCTableViewController implementation
@interface SCGroupTableViewController () {
}
@property (nonatomic) BOOL dataRequestedOnce;
@end

@implementation SCGroupTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _pageNo = 1;
    
    if (![Utils isNonnull:_dataArray]) {
        
        _dataArray = [NSMutableArray arrayWithCapacity:1];
        
    }
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:self.contentFrame];
        
    }
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
#ifdef SC_TP_COLOR
    _tableView.backgroundColor = COLOR_GRAY_BACKGROUND;
#endif
    [_tableView dontShowBlankRows];
#ifdef SC_TP_MJREFRESH
    if (!_disableHeaderRefresh)
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    if (!_disableFooterRefresh)
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
#endif
    [self customizeTableView];
    
    //    //    顶部加上一条线
    //    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 0.5f)];
    //    label.backgroundColor = _tableView.separatorColor;
    //    [_tableView addSubview:label];
    
    [self.view addSubview:_tableView];
#ifdef SC_TP_MJREFRESH
    if (!self.dontAutoLoad)
        [_tableView.mj_header beginRefreshing];
#endif
}

- (void)setupSubviews{
    
    
    for (Class  class in _cellClassArray) {
        [_tableView registerClass:class forCellReuseIdentifier:NSStringFromClass(class)];
    }
    for (Class  class in _cellNibNameArray) {
        [_tableView registerClass:class forCellReuseIdentifier:NSStringFromClass(class)];
    }
    for (Class  class in _headerClassArray) {
        [_tableView registerClass:class forHeaderFooterViewReuseIdentifier:NSStringFromClass(class)];
    }
    for (Class  class in _footerClassArray) {
        [_tableView registerClass:class forHeaderFooterViewReuseIdentifier:NSStringFromClass(class)];
    }
}

- (void) customizeTableView {
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = CGRectEqualToRect(_customFrame,CGRectZero) ? self.view.bounds : _customFrame;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:_tableView.indexPathForSelectedRow animated:YES];
}
- (void)dataReceidSuccessful:(NSDictionary *)dic newer:(BOOL)newer
{
    assert([_cellDataClassArray lastObject] && [[_cellDataClassArray lastObject] isSubclassOfClass:[SCTableViewCellData class]]);
    if (newer) {
        [[_dataArray lastObject] removeAllObjects];
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
        SCTableViewCellData* data = [[[_cellDataClassArray lastObject] alloc] init];
        if ([item isKindOfClass:[NSDictionary class]]){
            [data updateWithDictionary:item];
            [[_dataArray lastObject] addObject:data];
        }
    }
    [_tableView reloadData];
    [self endRefreshing: newer];
}

// loadData, newer: 请求更加新的数据
- (void)loadData:(BOOL)newer
{
//    NSString* lastId = @"";
    NSInteger pageNo = 1;
    if (!newer && _dataArray && _dataArray.count > 0 && _dataArray.lastObject.count > 0) {
//        lastId = ((SCTableViewCellData*)_dataArray.lastObject.lastObject).id;
        pageNo = _pageNo;
    }
    if (!_requestParams)
        _requestParams = [[NSMutableDictionary alloc]initWithCapacity:1];
//    _requestParams[_lastIdKey ?: @"lastId"] = lastId;
//    _requestParams[@"page"] = @(pageNo);
//    _requestParams[@"lng"] = @([SCUserInfo sharedInstance].curAddress.pt.longitude);
//    _requestParams[@"lat"] = @([SCUserInfo sharedInstance].curAddress.pt.latitude);
    
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
}

- (void) endRefreshing: (BOOL) newer {
#ifdef SC_TP_MJREFRESH
    if (newer) {
        [_tableView.mj_header endRefreshing];
    } else {
        [_tableView.mj_footer endRefreshing];
    }
#endif
}

- (void)headerRereshing
{
    [self loadData: YES];
}

- (void)footerRereshing
{
    [self loadData: NO];
}

// #pragma mark - TableView Data source and delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray && _dataArray.count > 0 ? _dataArray.count : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray && _dataArray.count > section ? _dataArray[section].count : 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return _headerTitleArray && _headerTitleArray.count > section ? _headerTitleArray[section] : nil;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return _footerTitleArray && _footerTitleArray.count > section ? _footerTitleArray[section] : nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCTableViewCellData * data = _dataArray.count > indexPath. section && _dataArray[indexPath. section].count > indexPath.row ? _dataArray[indexPath. section][indexPath.row] : nil;
    NSString * cellIndentifier = _cellClassArray.count > indexPath. section ? NSStringFromClass(_cellClassArray[indexPath. section]) : @"SCTableViewCell";
    SCTableViewCell * cell = (SCTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        if (_cellNibNameArray && _cellNibNameArray.count > indexPath.section) {
            cell = [[[NSBundle mainBundle] loadNibNamed:_cellNibNameArray[indexPath. section] owner:self options:nil] lastObject];
        } else {
            cell = [[NSClassFromString(cellIndentifier) alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        }
    }
    
    if ([cell respondsToSelector:@selector(setData:indexPath:)]){
        
        [cell performSelector:@selector(setData:indexPath:) withObject:data withObject:indexPath];
        
    }else{
        
        [cell setData: data];
        
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString *identifier = _headerClassArray && _headerClassArray.count >  section ? NSStringFromClass(_headerClassArray[ section]) : nil;
    return identifier ? [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier] : nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    NSString *identifier = _footerClassArray && _footerClassArray.count >  section ? NSStringFromClass(_footerClassArray[ section]) : nil;
    return identifier ? [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier] : nil;
}

// implement UITableViewNXEmptyViewDataSource
- (BOOL) tableViewShouldBypassNXEmptyView:(UITableView *)tableView {
    // 当请求过一次数据之后才显示empty view
    return !_dataRequestedOnce;
}


//高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return _cellHeightArray && _cellHeightArray.count > indexPath. section ? [_cellHeightArray[indexPath. section] floatValue] : 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return _cellHeightArray && _cellHeightArray.count > indexPath. section ? [_cellHeightArray[indexPath. section] floatValue] : UITableViewAutomaticDimension;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return _headerHeightArray && _headerHeightArray.count >  section ? [_headerHeightArray[ section] floatValue] : 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return _footerHeightArray && _footerHeightArray.count >  section ? [_footerHeightArray[ section] floatValue] : 0.001;
}
//选中的时候调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

//IOS8 设置TableView Separatorinset 分割线从边框顶端开始(7  8  都可用)
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,_separatorLineMarginLeft,0,_separatorLineMarginRight)];
    }
#ifdef __IPHONE_8_0
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,_separatorLineMarginLeft,0,_separatorLineMarginRight)];
    }
#endif
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0,_separatorLineMarginLeft,0,_separatorLineMarginRight)];
    }
#ifdef __IPHONE_8_0
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0,_separatorLineMarginLeft,0,_separatorLineMarginRight)];
    }
#endif
}

@end
