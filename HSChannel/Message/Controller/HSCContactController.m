//
//  HSCContactController.m
//  HSChannel
//
//  Created by SC on 16/8/24.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "HSCContactController.h"

@interface HSCContactController ()<JKSearchBarDelegate,GDIIndexBarDelegate>

@property (nonatomic, strong) JKSearchBar *searchBar;
@property (nonatomic, strong) UITableView      *searchTableView;
@property (nonatomic, strong) UIButton         *inputAccessoryButton;
@property (nonatomic, strong) NSMutableArray<HSCContactModel*> *searchTableViewDataArray;
@property (nonatomic, strong) NSMutableArray<HSCContactModel*> *searchTableViewDataArrayAll;
@property (nonatomic, strong) GDIIndexBar *indexBar;
@property (nonatomic, strong) NSMutableArray<NSDictionary*> *indexBarDataArray;
@property (nonatomic, strong) NSMutableDictionary *selectedContacts;

@end

@implementation HSCContactController

- (instancetype)initWithType:(HSCContactSelectType)type callback:(void(^)(NSArray *contacts))callback{
    
    if (self = [super init]) {
        
        self.type = type;
        
        self.callback = callback;
        
    }
    
    return self ;
}

- (void)customizeWhenInit {
    
    self.scHasBottomBar = YES;
    
}

- (void)viewDidLoad{
    
    
    self.title = @"通讯录";
    
    self.tableView = [[SCAccordionTableView alloc] initWithFrame:self.contentFrame style:UITableViewStylePlain];
    
    self.tableView.allowMultipleSectionsOpen = YES;
    
    self.separatorLineMarginLeft = 40;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.disableFooterRefresh = YES;
    
    self.disableHeaderRefresh = YES;
    
    self.dontAutoLoad = YES;
    
    self.customFrame = CGRectMake(0, 65, ScreenWidth, ScreenHeight-65-64-(self.scHasBottomBar ? 49 : 0));
    
    self.cellClassArray = @[[HSCContactCell class],[HSCContactCell class],[HSCContactCell class]];
    
    self.cellDataClassArray = @[[HSCContactModel class],[HSCContactModel class],[HSCContactModel class]];
    
    self.headerClassArray = @[[HSCContactHeaderView class],[HSCContactHeaderView class],[HSCContactHeaderView class]];
    
    self.headersInfo = [NSMutableArray new];
    
    self.selectedContacts = [NSMutableDictionary new];
    
    [super viewDidLoad];
    
}

- (void)setupSubviews{
    
    [super setupSubviews];
    
    [self setupNavigationbar];
    
    [self setupSearchbar];
    
    [self setupSearchTableView];
    
    [self requestContactInfo];
    
}

- (void)setupNavigationbar{
    
    if (_type == HSCContactSelectDefault) {
        return;
    }
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[SCColor getColor:@"ffffff"] forState:UIControlStateNormal];
    [rightBtn bk_whenTapped:^{
        
        [self.navigationController popViewControllerAnimated:YES];
        
        if (self.callback) {
            self.callback([self.selectedContacts allValues]);
        }
        
    }];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    self.navigationItem.rightBarButtonItem = rightItem;

    
}

- (void)setupSearchbar{
    
    UIView *searchBarBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 65)];
    
    _searchBar = [[JKSearchBar alloc] initWithFrame:CGRectMake(10, 5, ScreenWidth-20, 55)];
    
    _searchBar.placeholder = @"搜索";
    
    _searchBar.backgroundColor = [SCColor getColor:@"f4f4f4"];
    
//    _searchBar.cancelButtonDisabled = YES;
    
    _searchBar.tfCornerRadius = (55-14)/2;
    
    _searchBar.tfBorderColor = [UIColor clearColor];
    
    _searchBar.cbTitleColor = [SCColor getColor:SC_COLOR_3];
    
    _searchBar.delegate = self;
    
    [searchBarBackgroundView addSubview:_searchBar];
    
    searchBarBackgroundView.backgroundColor = _searchBar.backgroundColor;
    
    [self.view addSubview:searchBarBackgroundView];
    
}

- (void)setupSearchTableView{
    
    _searchTableViewDataArray = [NSMutableArray new];
    
    _searchTableView = [[UITableView alloc]initWithFrame:self.customFrame style:UITableViewStylePlain];
    
    _searchTableView.backgroundColor = [UIColor clearColor];
    
    _searchTableView.delegate = self;
    
    _searchTableView.dataSource = self;
    
    _searchTableView.backgroundView = [UIView new];
    
    _searchTableView.backgroundView.backgroundColor = [SCColor getColor:@"ffffff"];
    
    _searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_searchTableView];
    
    [_searchTableView setHidden:YES];
    
    [_searchTableView registerClass:[HSCContactCell class] forCellReuseIdentifier:@"HSCContactCell"];
    
    _inputAccessoryButton = [[UIButton alloc]initWithFrame:_searchTableView.frame];
    
    _inputAccessoryButton.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    
    //    _inputAccessoryButton.alpha = 0.5;
    
    DEFINE_WEAK(self);
    
    [_inputAccessoryButton bk_whenTapped:^{
        
        [_inputAccessoryButton setHidden:YES];
        
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
        
    }];
    
    [self.view addSubview:_inputAccessoryButton];
    
    [_inputAccessoryButton setHidden:YES];
    
    [self setupIndexBar];
}

- (void)setupIndexBar{
    
    if (_indexBar) {
        
        [_indexBar reload];
        return;
        
    }
    
    _indexBar = [[GDIIndexBar alloc]initWithTableView:_searchTableView];
    
    _indexBar.delegate = self;
    _indexBar.textColor = [SCColor getColor:SC_COLOR_3];
//    _indexBar.verticalAlignment = GDIIndexBarAlignmentTop;
    //    _indexBar.textShadowColor = [UIColor colorWithWhite:0.f alpha:.5f];
    //    _indexBar.textShadowOffset = UIOffsetMake(1, 1);
    _indexBar.barBackgroundColor = _searchBar.backgroundColor;
    //    _indexBar.textSpacing = 5.f;
    _indexBar.textFont = [Utils fontWithSize:SC_FONT_3];
    [self.view addSubview:_indexBar];
    
    [_indexBar setHidden:YES];
}

#pragma mark - JKSearchBarDelegate

- (void)searchBarCancelButtonClicked:(JKSearchBar *)searchBar{
    
    [_inputAccessoryButton setHidden:YES];
    
    [_searchTableView setHidden:YES];
    
    [_indexBar setHidden:YES];
    
    _searchTableView.backgroundColor = [UIColor clearColor];
    
    [_searchTableViewDataArray removeAllObjects];
    
    [_searchTableViewDataArray addObjectsFromArray:_searchTableViewDataArrayAll];
    
}

-(BOOL)searchBarShouldBeginEditing:(JKSearchBar *)searchBar{
    
    [_searchTableView setHidden:NO];
    
    [_inputAccessoryButton setHidden:NO];
    
    [_indexBar setHidden:NO];
    
    [_searchTableView reloadData];
    
    return YES;
    
}

- (void)searchBarTextDidBeginEditing:(JKSearchBar *)searchBar{
//    [_searchBar resignFirstResponder];
}

- (void)searchBar:(JKSearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if (![_searchTableView.backgroundColor isEqual:[UIColor whiteColor]]) {
        
        _searchTableView.backgroundColor = [UIColor whiteColor];
        
    }
    
    DEFINE_WEAK(self);
    
    [_searchTableViewDataArrayAll searchPinYinAsyncWithKeyPath:@"name" searchString:_searchBar.text callback:^(NSArray *results) {
        
        [wself.searchTableViewDataArray removeAllObjects];
        
        [wself.searchTableViewDataArray addObjectsFromArray:results];
        
        
        dispatch_main_async_safe(^{
            [wself.searchTableView reloadData];
        });
        

    }];
}

#pragma mark - GDIIndexBarDelegate

- (NSUInteger)numberOfIndexesForIndexBar:(GDIIndexBar *)indexBar
{
    return self.indexBarDataArray.count;
}

- (NSString *)stringForIndex:(NSUInteger)index
{
    return [self.indexBarDataArray[index] objectForKey:@"name"];
}

- (void)indexBar:(GDIIndexBar *)indexBar didSelectIndex:(NSUInteger)index
{
    [self.searchTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[[self.indexBarDataArray[index] objectForKey:@"index"] integerValue] inSection:0]
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:NO];
}

#pragma mark - <UITableViewDataSource> / <UITableViewDelegate> -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (tableView == _searchTableView) {
        return 1;
    }
    
    return [super numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == _searchTableView) {
        return _searchTableViewDataArray.count;
    }
    
    return [super tableView:tableView numberOfRowsInSection:section];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (tableView == _searchTableView) {
        return 0.001;
    }
    
    return 45;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _searchTableView) {
        
        HSCContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSCContactCell"];
        
        [cell setData:_searchTableViewDataArray[indexPath.row] indexPath:indexPath];
        
        return cell;
    }
    
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (tableView == _searchTableView) {
        return [UIView new];
    }
    
    HSCContactHeaderView *headerView = [super tableView:tableView viewForHeaderInSection:section];
    
    [headerView setData:self.headersInfo[section]];
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    UIView *footerView = [super tableView:tableView viewForFooterInSection:section];
    
    if (!footerView) {
        footerView = [UIView new];
    }
    
    footerView.backgroundColor = [SCColor getColor:@"ffffff"];
    
    return footerView;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HSCContactCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    switch (_type) {
        case HSCContactSelectDefault:
            
            [self.parentViewController.navigationController pushViewController:[[SCMessageViewController alloc]initWithConversationChatter:cell.cellData.hxAccount conversationName:cell.cellData.name conversationType:cell.cellData.chatType] animated:YES];
            break;
            
        case HSCContactSelectSingle:
            
            if (self.callback) {
                self.callback(@[cell.cellData]);
            }
            [self.navigationController popViewControllerAnimated:YES];
            
            break;
            
        case HSCContactSelectMulti:
            
            cell.cellData.isSelected = !cell.cellData.isSelected;
            
            self.selectedContacts[cell.cellData.hxAccount] = cell.cellData.isSelected ? cell.cellData : nil;
            
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
            
        default:
            break;
    }
    
    
}

#pragma mark - <FZAccordionTableViewDelegate> -

- (void)tableView:(FZAccordionTableView *)tableView willOpenSection:(NSInteger)section withHeader:(UITableViewHeaderFooterView *)header {
    
}

- (void)tableView:(FZAccordionTableView *)tableView didOpenSection:(NSInteger)section withHeader:(SCAccordionTableViewHeaderView *)header {
    
    self.headersInfo[section].isSpread = YES;
    
    [header setData:self.headersInfo[section]];
    
}

- (void)tableView:(FZAccordionTableView *)tableView willCloseSection:(NSInteger)section withHeader:(UITableViewHeaderFooterView *)header {
    
}

- (void)tableView:(FZAccordionTableView *)tableView didCloseSection:(NSInteger)section withHeader:(SCAccordionTableViewHeaderView *)header {
    
    self.headersInfo[section].isSpread = NO;
    
    [header setData:self.headersInfo[section]];
    
}

#pragma mark - private methods

- (void)requestContactInfo{
    
    
    DEFINE_WEAK(self);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        [wself resetContactInfo:[HSCContactModel findByCriteria:[NSString stringWithFormat:@"where contactType = 0"]] parents:[HSCContactModel findByCriteria:[NSString stringWithFormat:@"where contactType = 1"]] classes:[HSCContactModel findByCriteria:[NSString stringWithFormat:@"where contactType = 2"]] isFromJson:NO];
    });
    
    [SCHttpTool requestContactInfo:^(NSDictionary *json) {
        
        [wself resetContactInfo:json[@"teachers"] parents:json[@"parents"] classes:json[@"classes"] isFromJson:YES];
        
    }];
    
}

- (void)resetContactInfo:(NSArray *)teachers parents:(NSArray *)parents classes:(NSArray *)classes isFromJson:(BOOL)isFromJson{
    
    NSMutableArray<HSCContactModel*> *searchArray = [NSMutableArray new];
    
    DCKeyValueObjectMapping *kvom = [DCKeyValueObjectMapping mapperForClass:[HSCContactModel class]];
    
    NSMutableArray *allContacts = [NSMutableArray new];
    NSMutableArray *allGroups = [NSMutableArray new];
    
    if ([Utils isValidArray:teachers]) {
        
        
        HSCContactGroupModel *groupInfo = [HSCContactGroupModel new];
        
        groupInfo.name = @"教师";
        
        if (isFromJson) {
            NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:[kvom parseArray:teachers]];
            
            for (HSCContactModel *model in tempArray) {
                model.contactType = HSCContactTeacher;
            }
            
            [allContacts addObject:tempArray];
            
            [searchArray addObjectsFromArray:tempArray];
            
            groupInfo.totalNum = tempArray.count;
            
        }else{
            
            [allContacts addObject:teachers];
            
            [searchArray addObjectsFromArray:teachers];
            
            groupInfo.totalNum = teachers.count;

        }
        
        
        [allGroups addObject:groupInfo];
        
        
    }
    
    if ([Utils isValidArray:parents]) {
        
        HSCContactGroupModel *groupInfo = [HSCContactGroupModel new];
        
        groupInfo.name = @"家长";
        
        if (isFromJson) {
            NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:[kvom parseArray:parents]];
            
            for (HSCContactModel *model in tempArray) {
                model.contactType = HSCContactParent;
            }
            
            [allContacts addObject:tempArray];
            
            [searchArray addObjectsFromArray:tempArray];
            
            groupInfo.totalNum = tempArray.count;
            
        }else{
            
            [allContacts addObject:parents];
            
            [searchArray addObjectsFromArray:parents];
            
            groupInfo.totalNum = parents.count;
            
        }
        
        [allGroups addObject:groupInfo];
        
    }
    
    if (self.type != HSCContactSelectMulti && [Utils isValidArray:classes]) {
        
        HSCContactGroupModel *groupInfo = [HSCContactGroupModel new];
        
        groupInfo.name = @"班级";
        
        if (isFromJson) {
            NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:[kvom parseArray:classes]];
            
            for (HSCContactModel *model in tempArray) {
                model.contactType = HSCContactClass;
            }
            
            [allContacts addObject:tempArray];
            
            [searchArray addObjectsFromArray:tempArray];
            
            groupInfo.totalNum = tempArray.count;
            
        }else{
            
            [allContacts addObject:classes];
            
            [searchArray addObjectsFromArray:classes];
            
            groupInfo.totalNum = classes.count;
            
        }
        
        [allGroups addObject:groupInfo];
        
    }
    
    if (searchArray.count <= 0) {
        return;
    }
    
    self.dataArray = allContacts;
    
    self.headersInfo = allGroups;
    
    [self.tableView reloadData];
    

    
    [HSCContactModel clearTable];
    
    [HSCContactModel saveObjects:searchArray];
    
    [searchArray sortUsingComparator:^NSComparisonResult(HSCContactModel *  _Nonnull obj1, HSCContactModel *  _Nonnull obj2) {
        return [obj1.name.toPinyin compare:obj2.name.toPinyin];
    }];
    
    self.searchTableViewDataArrayAll = searchArray;
    
    self.searchTableViewDataArray = [[NSMutableArray alloc]initWithArray:self.searchTableViewDataArrayAll];
    
    NSString *lastPreffix = nil;
    NSMutableArray *indexBarData = [NSMutableArray new];
    for (NSInteger index = 0, count = searchArray.count; index < count; index++) {
        
        if (![Utils isValidStr:searchArray[index].name]) {
            continue;
        }
        
        NSString *preffix = [searchArray[index].name.toPinyin substringWithRange:NSMakeRange(0, 1)];
        
        if (!lastPreffix || ![preffix isEqualToString:lastPreffix]) {
            
            lastPreffix = preffix;
            
            [indexBarData addObject:@{@"index":@(index),
                                      @"name":preffix}];
            
        }
    }
    
    self.indexBarDataArray = indexBarData;
    
    [self setupIndexBar];
    
}

@end
