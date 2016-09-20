
#pragma mark - 常量定义
/// 每列图片数量
#define kPicViewColCount 3
/// 图片间距
#define kPicViewItemMargin 5
/// 控件间距
#define kStatusCellMargin 10

NSString *const kSCMomentsStatusPictureCellId = @"kSCMomentsStatusPictureCellId";

#import "SCPhotoContainerView.h"
#import "SCMomentsPictureCell.h"
#import "SCPictureBrowser.h"

@interface SCPhotoContainerView()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIViewControllerTransitioningDelegate>

@end

@implementation SCPhotoContainerView

- (void)setUrls:(NSArray *)urls
{
    _urls = urls;
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo([self calcViewSize]);
    }];
    [self reloadData];
}

/// 计算视图大小
- (CGSize)calcViewSize {
    
    NSInteger count = _urls.count;
    if (count == 0) {
        return CGSizeZero;
    }
//    CGFloat itemWH = (([UIScreen mainScreen].bounds.size.width - 70) - (kPicViewColCount - 1) * (kPicViewItemMargin + kStatusCellMargin)) / kPicViewColCount;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
//    layout.itemSize = CGSizeMake(itemWH, itemWH);
    CGFloat itemWH = layout.itemSize.width;
    NSInteger col = count == 4 ? 2 : (count >= kPicViewColCount ? kPicViewColCount : count);
    NSInteger row = (count - 1) / kPicViewColCount + 1;
    CGFloat width = ceil(col * itemWH + (col - 1) * kPicViewItemMargin);
    CGFloat height = ceil(row * itemWH + (row - 1) * kPicViewItemMargin);
    return CGSizeMake(width, height);
}

- (instancetype)init {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    if (self = [super initWithFrame:CGRectZero collectionViewLayout:layout]) {
        layout.minimumInteritemSpacing = kPicViewItemMargin;
        layout.minimumLineSpacing = kPicViewItemMargin;
        [self registerClass:[SCMomentsPictureCell class] forCellWithReuseIdentifier:kSCMomentsStatusPictureCellId];
        self.dataSource = self;
        self.delegate = self;
        self.scrollsToTop = NO;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.urls.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SCMomentsPictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSCMomentsStatusPictureCellId forIndexPath:indexPath];
    cell.imageURL = self.urls[indexPath.item];
    cell.imageView.tag = indexPath.row;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SCMomentsPictureCell *cell = (SCMomentsPictureCell *)[collectionView cellForItemAtIndexPath:indexPath];
    SCPictureBrowser *mvc = [[SCPictureBrowser alloc] init];
    [mvc showWithPictureURLs: self.urlsBig.count > 0 ? self.urlsBig : self.urls atIndex:cell.imageView.tag];
}


@end
