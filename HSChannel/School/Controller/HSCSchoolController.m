//
//  HSCSchoolController.m
//  HSChannel
//
//  Created by SC on 16/8/22.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "HSCSchoolController.h"
#define SC_SCHOOLINFO_ITEM_HEIGHT   200
#define SC_PRIMARY_ITEM_HEIGHT      110
#define SC_SECTION_HEAD_FOOT_HEIGHT    0

//用户信息
#define SC_SCHOOLINFO_FUNCTION_SECTION   0
#define SC_PF_SCHOOLINFO                 0
#define SC_DEFINE_SCHOOLINFO_FUNCTION(function)\
SC_DEFINE_ITEM_SELECTOR(SC_SCHOOLINFO_FUNCTION_SECTION,function)

//主功能相关
//主功能列表所在section
#define SC_PRIMARY_FUNCTION_SECTION    1
//各主功能所在row
#define SC_PF_SCHOOL_DETAIL           0
#define SC_PF_SCHOOL_NOTICE           1
#define SC_PF_SCHOOL_NEWS             2
#define SC_PF_TEACHERS_LIST           3
#define SC_PF_RECIPES_LIST            4
#define SC_PF_TRANSCARD_LIST          5

#define SC_DEFINE_PRIMARY_FUNCTION(function)\
SC_DEFINE_ITEM_SELECTOR(SC_PRIMARY_FUNCTION_SECTION,function)


@interface HSCSchoolController (){
    __block SCUserInfo* userInfo;
}

@property (nonatomic, strong)HSCSchoolInfoModel *schoolInfo;

@end

@implementation HSCSchoolController

- (void)customizeWhenInit {
    [super customizeWhenInit];
    self.scHasBottomBar = YES;
    self.title = NSLocalizedString(@"学校", nil);
    userInfo = [SCUserInfo sharedInstance];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupCollectionViewData];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleNotification:) name:kSCNotificationNameHeadlineDetail object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleNotification:) name:kSCNotificationNameHeadlineOther object:nil];
    
    [self.observer observe:[SCUserInfo sharedInstance] keyPath:@"unreadSNCount" blockForNew:^(HSCSchoolController * _Nullable observer, id  _Nonnull object, NSNumber *  _Nonnull change) {
        SCPrimaryFunctionCellData *data = [observer getCollectionCellDataWith:1 row:1];
        data.newsCount = change.integerValue;
        [observer reloadCollectionCell:1 row:1];
    }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestSchoolInfo];
    [self.collectionView reloadData];
}

- (void)setupSubviews{
    [super setupSubviews];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self setupCustomNavigtionBar];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    return;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    return;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SEL itemSelector = GET_ITEM_SELECTOR_FROM_INDEXPATH(indexPath);
    if ([self respondsToSelector:itemSelector]) {
        [self performSelector:itemSelector withObject:collectionView withObject:indexPath];
    }
    return;
}

#pragma mark - custom methods

- (void)setupCustomNavigtionBar{
    
    DEFINE_WEAK(self);
    
}

- (void)requestSchoolInfo{
    DEFINE_WEAK(self);
    [SCHttpTool postWithURL:HSC_URL_SCHOOL_INFO_GET params:@{@"schoolId":@0} success:^(NSDictionary *json) {
        
        if ([Utils isValidDictionary:json[@"info"]]) {
            
            wself.schoolInfo = [[HSCSchoolInfoModel alloc]initWithDictionary:json[@"info"]];
            [wself refreshData];

        }
        
    } failure:nil];
}

- (void)refreshData{
    
    [self refreshSchoolInfoSection];
    
    [self refreshFunctionSection];
}

- (void)refreshSchoolInfoSection{
    
    SCHeadlineCellData *data = [self getCollectionCellDataWith:SC_SCHOOLINFO_FUNCTION_SECTION row:0];
    
    data.dataArray = self.schoolInfo.leaflets;
    
    data.otherTitle = @"学校主页";
    
    data.otherDetail = self.schoolInfo.webPages;
    
    [self reloadCollectionCell:SC_SCHOOLINFO_FUNCTION_SECTION row:0];
    
}

- (void)refreshFunctionSection{
    NSArray *data = [self getCollectionSectionDataWith:SC_PRIMARY_FUNCTION_SECTION];
//    if (userInfo.accountInfo.userType != 1 && data.count == 6) {
//        ((SCPrimaryFunctionCellData*)data[5]).imageName = nil;
//        ((SCPrimaryFunctionCellData*)data[5]).functionName = nil;
//    }else if (data.count == 6){
        ((SCPrimaryFunctionCellData*)data[5]).imageName = KSCImageSchoolControllerTransCard;
        ((SCPrimaryFunctionCellData*)data[5]).functionName = NSLocalizedString(@"接送卡绑定", nil);
//    }
    
    [self reloadCollectionCell:SC_PRIMARY_FUNCTION_SECTION row:5];
}

- (NSArray *)getCollectionSectionDataWith:(NSInteger)section{
    
    if (section >= [self.groupDataArray count]){
        return nil;
    }
    return self.groupDataArray[section];
}


- (SCCollectionViewCellData *)getCollectionCellDataWith:(NSInteger)section row:(NSInteger)row{
    
    if (section >= [self.groupDataArray count] || row >= [(NSArray*)self.groupDataArray[section] count]){
        return nil;
    }
    return self.groupDataArray[section][row];
}

- (void)reloadCollectionCell:(NSInteger)section row:(NSInteger)row{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    if ([Utils isNilOrNSNull:indexPath]) {
        return;
    }
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

- (void)setupCollectionViewData{
    self.collectionViewStyle = SCCollectionViewStyleGrouped;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(ScreenWidth, SC_SCHOOLINFO_ITEM_HEIGHT);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing      = 0;
    flowLayout.headerReferenceSize     = CGSizeMake(ScreenWidth, SC_SECTION_HEAD_FOOT_HEIGHT);
    
    UICollectionViewFlowLayout *flowLayout1 = [[UICollectionViewFlowLayout alloc]init];
    flowLayout1.itemSize = CGSizeMake(ScreenWidth/3, SC_PRIMARY_ITEM_HEIGHT);
    flowLayout1.minimumInteritemSpacing = 0;
    flowLayout1.minimumLineSpacing      = 0;
    flowLayout1.footerReferenceSize     = CGSizeMake(ScreenWidth, SC_SECTION_HEAD_FOOT_HEIGHT);
    
    DEFINE_WEAK(self);
    self.scNextTimeDidAppearCallback = ^{
        UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, wself.collectionView.contentSize.height)];
        backgroundView.backgroundColor = [UIColor whiteColor];
        [wself.collectionView addSubview:backgroundView];
        [wself.collectionView sendSubviewToBack:backgroundView];
        UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, SC_SECTION_HEAD_FOOT_HEIGHT)];
        footView.backgroundColor = [SCColor getColor:@"f7f5fa"];
        [backgroundView addSubview:footView];
        
        footView = [[UIView alloc]initWithFrame:CGRectMake(0, SC_SCHOOLINFO_ITEM_HEIGHT+SC_SECTION_HEAD_FOOT_HEIGHT, ScreenWidth, SC_SECTION_HEAD_FOOT_HEIGHT)];
        footView.backgroundColor = [SCColor getColor:@"f7f5fa"];
        [backgroundView addSubview:footView];
        
        footView = [[UIView alloc]initWithFrame:CGRectMake(0, SC_SCHOOLINFO_ITEM_HEIGHT+SC_SECTION_HEAD_FOOT_HEIGHT*2+SC_PRIMARY_ITEM_HEIGHT*2, ScreenWidth, ScreenHeight-(SC_SCHOOLINFO_ITEM_HEIGHT+SC_SECTION_HEAD_FOOT_HEIGHT*2+SC_PRIMARY_ITEM_HEIGHT*2))];
        footView.backgroundColor = [SCColor getColor:@"f7f5fa"];
        [backgroundView addSubview:footView];
        
        CGFloat tempHeight = SC_SECTION_HEAD_FOOT_HEIGHT;
        UIView *separatorLine = [[UIView alloc]initWithFrame:CGRectMake(0, tempHeight, ScreenWidth, 0.5)];
        separatorLine.backgroundColor = [SCColor getColor:SC_COLOR_SEPARATOR_LINE];
        [wself.collectionView addSubview:separatorLine];
        
        tempHeight += SC_SCHOOLINFO_ITEM_HEIGHT;
        
        separatorLine = [[UIView alloc]initWithFrame:CGRectMake(0, tempHeight, ScreenWidth, 0.5)];
        separatorLine.backgroundColor = [SCColor getColor:SC_COLOR_SEPARATOR_LINE];
        [wself.collectionView addSubview:separatorLine];
        
        tempHeight += SC_SECTION_HEAD_FOOT_HEIGHT;
        separatorLine = [[UIView alloc]initWithFrame:CGRectMake(0, tempHeight, ScreenWidth, 0.5)];
        separatorLine.backgroundColor = [SCColor getColor:SC_COLOR_SEPARATOR_LINE];
        [wself.collectionView addSubview:separatorLine];
        
        tempHeight += SC_PRIMARY_ITEM_HEIGHT;
        separatorLine = [[UIView alloc]initWithFrame:CGRectMake(0, tempHeight, ScreenWidth, 0.5)];
        separatorLine.backgroundColor = [SCColor getColor:SC_COLOR_SEPARATOR_LINE];
        [wself.collectionView addSubview:separatorLine];
        
        tempHeight += SC_PRIMARY_ITEM_HEIGHT;
        separatorLine = [[UIView alloc]initWithFrame:CGRectMake(0, tempHeight, ScreenWidth, 0.5)];
        separatorLine.backgroundColor = [SCColor getColor:SC_COLOR_SEPARATOR_LINE];
        [wself.collectionView addSubview:separatorLine];
        
        tempHeight -= SC_PRIMARY_ITEM_HEIGHT*2;
        separatorLine = [[UIView alloc]initWithFrame:CGRectMake(flowLayout1.itemSize.width, tempHeight, 0.5, flowLayout1.itemSize.height*2)];
        separatorLine.backgroundColor = [SCColor getColor:SC_COLOR_SEPARATOR_LINE];
        [wself.collectionView addSubview:separatorLine];
        
        separatorLine = [[UIView alloc]initWithFrame:CGRectMake(flowLayout1.itemSize.width*2, tempHeight, 0.5, flowLayout1.itemSize.height*2)];
        separatorLine.backgroundColor = [SCColor getColor:SC_COLOR_SEPARATOR_LINE];
        [wself.collectionView addSubview:separatorLine];
        
        tempHeight -= (SC_SECTION_HEAD_FOOT_HEIGHT);
    };
    
    self.flowLayoutArray    = @[flowLayout,
                                flowLayout1];
    self.cellClassArray     = @[[SCHeadlineCell class],
                                [SCPrimaryFunctionCell class]];
    self.cellDataClassArray = @[[SCHeadlineCellData class],
                                [SCPrimaryFunctionCellData class]];
    
    DCKeyValueObjectMapping *dicParser = [DCKeyValueObjectMapping mapperForClass:[SCHeadlineCellData class]];
    NSArray *userInfoDataArray = @[
                                   @{@"dataArray":@[]
                                     },
                                   ];
    NSArray *section0DataArray = [dicParser parseArray:userInfoDataArray];
    
    
    dicParser = [DCKeyValueObjectMapping mapperForClass:[SCPrimaryFunctionCellData class]];
    
    NSArray *functionDataArray = @[
                                   @{@"imageName":KSCImageSchoolControllerSummary,          @"functionName":NSLocalizedString(@"学校简介", nil)},
                                   @{@"imageName":KSCImageSchoolControllerNotice,          @"functionName":NSLocalizedString(@"学校通知", nil)},
                                   @{@"imageName":KSCImageSchoolControllerNews,         @"functionName":NSLocalizedString(@"校园新闻", nil)},
                                   @{@"imageName":KSCImageSchoolControllerTeacher,          @"functionName":NSLocalizedString(@"教师风采", nil)},
                                   @{@"imageName":KSCImageSchoolControllerCookBook,          @"functionName":NSLocalizedString(@"本周食谱", nil)},
                                   @{@"imageName":@"",                 @"functionName":NSLocalizedString(@"", nil)}
                                   ];
    NSArray *section1DataArray = [dicParser parseArray:functionDataArray];
    self.groupDataArray = (NSMutableArray*)@[section0DataArray,section1DataArray];
}

#pragma mark - CollectionView Item Selectors

SC_DEFINE_SCHOOLINFO_FUNCTION(SC_PF_SCHOOLINFO){
    
}

SC_DEFINE_PRIMARY_FUNCTION(SC_PF_SCHOOL_DETAIL){
    [SCWebViewController pushFromController:self url:HSC_URL_SCHOOL_PROFILE title:NSLocalizedString(@"学校简介", nil)];
}

SC_DEFINE_PRIMARY_FUNCTION(SC_PF_SCHOOL_NOTICE){
    
    SCPrimaryFunctionCellData *data = [self getCollectionCellDataWith:indexPath.section row:indexPath.row];
    
    if (data.newsCount > 0) {
        data.newsCount = 0;
        [self reloadCollectionCell:indexPath.section row:indexPath.row];
    }
    
    [self.navigationController pushViewController:[[HSCSNListController alloc]initWithAutoLoad:YES] animated:YES];
    
}

SC_DEFINE_PRIMARY_FUNCTION(SC_PF_SCHOOL_NEWS){
    
    [SCWebViewController pushFromController:self url:HSC_URL_SCHOOL_NEWS title:NSLocalizedString(@"校园新闻", nil)];
}

SC_DEFINE_PRIMARY_FUNCTION(SC_PF_TEACHERS_LIST){
    
    [SCWebViewController pushFromController:self url:HSC_URL_SCHOOL_TEACHERS_LIST title:NSLocalizedString(@"教师风采", nil)];
}

SC_DEFINE_PRIMARY_FUNCTION(SC_PF_RECIPES_LIST){
    
    [SCWebViewController pushFromController:self url:HSC_URL_SCHOOL_RECIPES_LIST title:NSLocalizedString(@"本周食谱", nil)];
}

SC_DEFINE_PRIMARY_FUNCTION(SC_PF_TRANSCARD_LIST){
    
    [self.navigationController pushViewController:[HSCSTransCardController new] animated:YES];
    
}

#pragma mark Notifications

- (void)handleNotification:(NSNotification*)noti{
    
    [SCWebViewController pushFromController:self url:noti.object title:nil];
}

@end
