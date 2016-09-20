//
//  SCCollectionViewController.m
//  ShiHua
//
//  Created by SC on 15/4/30.
//  Copyright (c) 2015年 shuchuang. All rights reserved.
//

#import "SCCollectionViewController.h"

#pragma mark - SCCollectionViewController

@interface SCCollectionViewController ()
@property(nonatomic, strong) UICollectionView* collectionView;
@end

@implementation SCCollectionViewController

- (void)setupSubviews{
    [super setupSubviews];
    
#if defined(SCDEBUG) && SCDEBUG == 1
    if (_collectionViewStyle == SCCollectionViewStyleGrouped){
        assert(_flowLayoutArray && _cellDataClassArray);
        [_cellDataClassArray enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop){
            assert([obj isSubclassOfClass:[SCCollectionViewCellData class]]);
        }];
        
        assert(_cellClassArray);
        [_cellClassArray enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop){
            assert([obj isSubclassOfClass:[SCCollectionViewCell class]]);
        }];
    }
    else {
        assert(_flowLayout && _cellDataClass && [_cellDataClass isSubclassOfClass:[SCCollectionViewCellData class]]);
        
        assert(_cellNibName || (_cellClass && [_cellClass isSubclassOfClass:[SCCollectionViewCell class]] ));
    }
    
    if (_HeaderViewClassDic) {
        [_HeaderViewClassDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
            assert([(NSString*)key hasSuffix:@"supplement"] && obj && [obj isSubclassOfClass:[SCCollectionSupplementView class]]);
        }];
    }
    
    if (_footerViewClassDic) {
        [_footerViewClassDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
            assert([(NSString*)key hasSuffix:@"supplement"] && obj && [obj isSubclassOfClass:[SCCollectionSupplementView class]]);
        }];
    }
    
    
    if (_specialCellClassDic) {
        [_specialCellClassDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
            assert([(NSString*)key hasSuffix:@"special"] && obj && [obj isSubclassOfClass:[SCCollectionViewCell class]]);
        }];
    }
    
    if (_specialCellDataClassDic) {
        [_specialCellDataClassDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
            assert([(NSString*)key hasSuffix:@"special"] && obj && [obj isSubclassOfClass:[SCCollectionViewCellData class]]);
        }];
    }
#endif
    [self.view addSubview:self.collectionHeaderView];
    [self.view addSubview:self.collectionView];
    if (_collectionViewStyle == SCCollectionViewStyleNetwork) {
#ifdef SC_TP_MJREFRESH
        self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
        self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
#endif
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGRect resetFrame = self.view.frame;
    resetFrame.origin.x = 0 ;
    resetFrame.origin.y = 0;
    if (self.collectionHeaderView) {
        CGRect headViewFrame = self.collectionHeaderView.frame;
        resetFrame.origin.y += headViewFrame.origin.y + headViewFrame.size.height;
    }
    self.collectionView.frame = resetFrame;
}

- (void)dataReceivedSuccessful:(NSDictionary *)dic newer:(BOOL)newer
{
    assert(_cellDataClass && [_cellDataClass isSubclassOfClass:[SCCollectionViewCellData class]]);
    if (newer) {
        [_dataArray removeAllObjects];
    }
    NSArray * array = [dic valueForKeyPath: _listPath];
    if (array.count == 0) {
        [[Utils getDefaultWindow] makeShortToastAtCenter:@"没有更多了"];
    }
    for (NSDictionary * item in array) {
        SCCollectionViewCellData* data = [[_cellDataClass alloc] init];
        [data updateWithDictionary:item];
        if ([Utils isNilOrNSNull:_dataArray]) {
            _dataArray = [[NSMutableArray alloc]initWithCapacity:[array count]];
        }
        [_dataArray addObject:data];
    }
    [_collectionView reloadData];
    [self endRefreshing: newer];
}

// loadData, newer: 请求更加新的数据
- (void)loadData:(BOOL)newer
{
    NSString* lastId = @"";
    if (!newer && _dataArray.count > 0) {
        lastId = ((SCCollectionViewCellData*)_dataArray.lastObject).id;
    }
    if (!_requestParams)
        _requestParams = [[NSMutableDictionary alloc]initWithCapacity:1];
    _requestParams[_lastIdKey ?: @"lastId"] = lastId;
    [self customizeParams: _requestParams newer:newer];
    DEFINE_WEAK(self);
#ifdef SC_TP_AFNETWORKING
    [SCHttpTool getWithURL:_url params:_requestParams success:^(id json) {
        [wself dataReceivedSuccessful:json newer: newer];
    } failure:^(NSError *error) {
        [wself.view makeShortToastAtCenter: [error localizedDescription]];
        [wself endRefreshing: newer];
    } ];
#endif
}

- (void) customizeParams: (NSMutableDictionary*)params newer:(BOOL)newer {
}

- (void) endRefreshing: (BOOL) newer {
#ifdef SC_TP_MJREFRESH
    if (newer) {
        [_collectionView.mj_header endRefreshing];
    } else {
        [_collectionView.mj_footer endRefreshing];
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

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _collectionViewStyle==SCCollectionViewStyleGrouped?[_groupDataArray count]:1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_collectionViewStyle == SCCollectionViewStyleGrouped) {
        return section < [_groupDataArray count]?[(NSArray *)_groupDataArray[section] arrayElementCount]:0;
    }
    return  section == 0 ? [_dataArray count]:0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString * cellIndentifier = nil;
    SCCollectionViewCellData * data = nil;
    NSString * specialKey = SPECIAL_ITEM_KEY(indexPath.section, indexPath.row);
    if (_specialCellClassDic[specialKey]) {
        data = _specialCellDataDic[specialKey];
        cellIndentifier = NSStringFromClass(_specialCellClassDic[specialKey]);
    }else if (_collectionViewStyle == SCCollectionViewStyleGrouped &&
              indexPath.section < [_groupDataArray count] &&
              indexPath.row < [(NSArray *)_groupDataArray[indexPath.section] arrayElementCount]) {
        data = _groupDataArray[indexPath.section][indexPath.row];
        cellIndentifier = NSStringFromClass(_cellClassArray[indexPath.section]);
    }else if (indexPath.row < [_dataArray count]){
        data = _dataArray[indexPath.row];
        cellIndentifier = NSStringFromClass(_cellClass);
    }else {
        cellIndentifier = NSStringFromClass([SCCollectionViewCell class]);
    }
    SCCollectionViewCell * cell = (SCCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:_cellNibName forIndexPath:indexPath];
    }
    [cell setData: data];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdentifier = nil;
    NSDictionary  *tempDic = nil;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        tempDic = _HeaderViewClassDic;
    }else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
        tempDic = _footerViewClassDic;
    }
    
    if (tempDic != nil && [tempDic valueForKey:SUPPLEMENT_MODEL_KEY((int)indexPath.section)]) {
        reuseIdentifier = NSStringFromClass(tempDic[SUPPLEMENT_MODEL_KEY((int)indexPath.section)]);
    }else{
        reuseIdentifier = NSStringFromClass([SCCollectionSupplementView class]);;
    }
    
    SCCollectionSupplementView *supplementView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    return supplementView;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    SCCollectionViewCell *cell = (SCCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell.highlightView setHidden:NO];
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    SCCollectionViewCell *cell = (SCCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell.highlightView setHidden:YES];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewFlowLayout *specialLayout = _specialItemSizeDic[SPECIAL_ITEM_KEY(indexPath.section, indexPath.row)];
    
    return specialLayout != nil ? specialLayout.itemSize : [self flowLayoutWith:indexPath.section].itemSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return [self flowLayoutWith:section].sectionInset;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return [self flowLayoutWith:section].minimumInteritemSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return [self flowLayoutWith:section].minimumLineSpacing;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return [self flowLayoutWith:section].headerReferenceSize;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return [self flowLayoutWith:section].footerReferenceSize;;
}

#pragma mark - Private Methods

- (UICollectionViewFlowLayout *)flowLayoutWith:(NSInteger)index{
    if (_collectionViewStyle == SCCollectionViewStyleGrouped) {
        return index < [_flowLayoutArray count] ? (UICollectionViewFlowLayout *)_flowLayoutArray[index] : nil;
    }
    return _flowLayout;
}

#pragma mark - Getters and Setters

- (UICollectionView *)collectionView{
    if ( _collectionView == nil) {
        CGRect frame = self.view.frame;
        frame.origin.x = 0;
        frame.origin.y = 0;
        _collectionView = [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:[[UICollectionViewFlowLayout alloc]init]];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        
        [_collectionView registerClass:[SCCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([SCCollectionViewCell class])];
        
        [_collectionView  registerClass:[SCCollectionSupplementView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([SCCollectionSupplementView class])];
        
        [_collectionView  registerClass:[SCCollectionSupplementView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([SCCollectionSupplementView class])];
        
        if (_cellNibName) {
            [_collectionView registerNib:[UINib nibWithNibName:_cellNibName bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:_cellNibName];
        }else if (_cellClass){
            [_collectionView registerClass:_cellClass forCellWithReuseIdentifier:NSStringFromClass(_cellClass)];
        }else{
            [_cellClassArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
                [_collectionView registerClass:obj forCellWithReuseIdentifier:NSStringFromClass(obj)];
            }];
        }
        
        
        [[_specialCellClassDic allValues] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            [_collectionView registerClass:obj forCellWithReuseIdentifier:NSStringFromClass(obj)];
        }];
        
        [[_HeaderViewClassDic allValues] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            [_collectionView registerClass:obj forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(obj)];
        }];
        
        [[_footerViewClassDic allValues] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            [_collectionView registerClass:obj forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass(obj)];
        }];
    }
    return _collectionView;
}

@end

#pragma mark - SCCollectionViewCell

@implementation SCCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - Getters And Setters

- (void)setHighlightView:(UIView *)highlightView{
    if (_highlightView) {
        [_highlightView removeFromSuperview];
    }
    _highlightView = highlightView;
    [_highlightView setHidden:YES];
    [self.contentView addSubview:_highlightView];
    [self.contentView sendSubviewToBack:_highlightView];
}

@end

#pragma mark - SCCollectionViewCellData

@interface SCCollectionViewCellData () {
#ifdef SC_TP_KEYVALUE_MAPPING
    DCKeyValueObjectMapping* _dicParser;
#endif
}
@end

@implementation SCCollectionViewCellData

- (void) updateWithDictionary: (NSDictionary*)dic
{
#ifdef SC_TP_KEYVALUE_MAPPING
    if (!_dicParser) {
        _dicParser = [DCKeyValueObjectMapping mapperForClass:self.class];
    }
    [_dicParser updateObject:self withDictionary:dic];
#endif
}
@end

#pragma mark - SCCollectionSupplementView

@implementation SCCollectionSupplementView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

@end