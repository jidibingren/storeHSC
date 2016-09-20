//
//  HSCSpeciallyPhotoContainerView.m
//  HSChannel
//
//  Created by SC on 16/9/3.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "HSCSpeciallyPhotoContainerView.h"


@interface HSCSpeciallyPictureCell : SCCollectionViewCell
@property (nonatomic, strong)UIImageView *iconView;
@end

@implementation HSCSpeciallyPictureCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self setupSubviewsWithFrame:frame];
    }
    return self;
}

- (void)setupSubviewsWithFrame:(CGRect)frame{
    CGRect tempFrame = frame;
    tempFrame.origin = CGPointZero;
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    UIImageView * backgroundImageView = [[UIImageView alloc]initWithFrame:tempFrame];
    backgroundImageView.contentMode = UIViewContentModeScaleToFill;
    [self setBackgroundView:backgroundImageView];
    
    _iconView = [[UIImageView alloc]init];
    _iconView.contentMode = UIViewContentModeScaleAspectFill;
    _iconView.layer.masksToBounds = YES;
    [self.contentView addSubview:_iconView];
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
}

- (void)ressetFrame:(CGRect)frame{
    
    CGRect tempFrame = self.frame;
    
    
    
}

@end

@interface HSCSpeciallyPhotoContainerView ()<UICollectionViewDataSource,SCCollectionViewDelegateFlowLayout>


@end

@implementation HSCSpeciallyPhotoContainerView

- (instancetype)initWithFrame:(CGRect)frame {
    
    SCCollectionViewFlowLayout *layout = [[SCCollectionViewFlowLayout alloc]init];
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 5;
        CGSize itemSize;
        
        itemSize.width = (frame.size.width-layout.minimumInteritemSpacing)/2;
        itemSize.height = (frame.size.height-layout.minimumLineSpacing)/2;
        layout.itemSize = itemSize;
        layout.delegate = self;
        self.contentSize = frame.size;
        [self registerClass:[HSCSpeciallyPictureCell class] forCellWithReuseIdentifier:NSStringFromClass([HSCSpeciallyPictureCell class])];
        self.dataSource = self;
        self.delegate = self;
        self.scrollsToTop = NO;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - UICollectionViewDataSource


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return MIN(self.urls.count, 4);
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SCCollectionViewFlowLayout *layout = self.collectionViewLayout;
    NSString *identifier = NSStringFromClass([HSCSpeciallyPictureCell class]);
    HSCSpeciallyPictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    [cell.iconView sc_setImageWithURL:self.urls[indexPath.row] placeHolderImage:nil];
    cell.frame = [layout layoutAttributesForItemAtIndexPath:indexPath].frame;
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout offsetForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger count = self.urls.count;
    
    CGFloat offset = 0;
    
    SCCollectionViewFlowLayout *layout = self.collectionViewLayout;
    
    switch (count) {
        case 1:
            
            
            
            break;
        case 2:
            
            break;
            
        case 3:
        {
            switch (indexPath.row) {
                case 2:
                    offset = layout.itemSize.width + layout.minimumInteritemSpacing;
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        case 4:
        {
            switch (indexPath.row) {
                case 3:
//                    offset = layout.itemSize.width + layout.minimumInteritemSpacing;
                    break;
                    
                default:
                    break;
            }
        }
            
            break;
            
            
        default:
            break;
    }
    
    return  offset;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    //    return indexPath.row == 0 ? CGSizeMake(ScreenWidth*(300/750.0), ScreenWidth*(328/750.0)) : CGSizeMake(ScreenWidth*(222/750.0), ScreenWidth*(162/750.0));
    NSInteger count = self.urls.count;
    SCCollectionViewFlowLayout *layout = self.collectionViewLayout;
    
    CGSize size = layout.itemSize;
    
    switch (count) {
        case 1:
            
            size = self.frame.size;
            
            break;
        case 2:
            
            size.height = self.frame.size.height;
            break;
            
        case 3:
        {
            switch (indexPath.row) {
                case 0:
                    size.height = self.frame.size.height;
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        case 4:
            
            break;

            
        default:
            break;
    }
    
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SCPictureBrowser *mvc = [[SCPictureBrowser alloc] init];
    [mvc showWithPictureURLs: self.urlsBig.count > 0 ? self.urlsBig : self.urls atIndex:indexPath.row];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)setUrls:(NSArray *)urls{
    
    _urls = urls;
    
    [self reloadData];
    
}

#pragma mark - Methods to Override

@end
