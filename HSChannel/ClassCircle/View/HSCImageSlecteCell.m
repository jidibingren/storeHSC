//
//  HSCImageSlecteCell.m
//  HSChannel
//
//  Created by SC on 16/9/3.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "HSCImageSlecteCell.h"

@protocol HSCImageItemCellDelegate <NSObject>

- (void)didClickDeleteButtonAtIndexPath:(NSIndexPath*)indexPath;

@end

@interface HSCImageItemCell : SCCollectionViewCell

@property (nonatomic, weak  )id <HSCImageItemCellDelegate>  delegate;
@property (nonatomic, strong)UILabel     *titleLabel;
@property (nonatomic, strong)UIImageView *iconView;
@property (nonatomic, strong)UIButton    *deleteBtn;
@property (nonatomic, strong)NSIndexPath *indexPath;

@end

@implementation HSCImageItemCell

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
    
    
    CGFloat offset = 10;
    _iconView = [[UIImageView alloc]init];
    _iconView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_iconView];
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(offset);
        make.left.mas_equalTo(self.contentView).offset(offset);
        make.right.mas_equalTo(self.contentView).offset(-offset);
        make.bottom.mas_equalTo(self.contentView).offset(-offset);
    }];
    
    _deleteBtn = [[UIButton alloc]init];
    [_deleteBtn setBackgroundImage:[UIImage sc_imageNamed:KSCImageImageSelectCellDeleteButtonNormal] forState:UIControlStateNormal];
    [self.contentView addSubview:_deleteBtn];
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_iconView.mas_right);
        make.centerY.mas_equalTo(_iconView.mas_top);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
    [_deleteBtn bk_whenTapped:^{
        [self.delegate didClickDeleteButtonAtIndexPath:self.indexPath];
    }];
    
}

@end

@interface HSCImageSlecteCell()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,HSCImageItemCellDelegate>


@end

@implementation HSCImageSlecteCell


- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self setupSubviewsWithFrame:frame];
    }
    return self;
}

- (void)setupSubviewsWithFrame:(CGRect)frame{
    
    _iconArray = [NSMutableArray new];
    
    CGRect tempFrame = frame;
    tempFrame.origin = CGPointZero;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake(ScreenWidth/4, ScreenWidth/4);
    
    _collectionView = [[UICollectionView alloc]initWithFrame:tempFrame collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView).offset(30);
        make.bottom.mas_equalTo(self.contentView).offset(-30);
    }];
    
    [_collectionView registerClass:[HSCImageItemCell class] forCellWithReuseIdentifier:NSStringFromClass([HSCImageItemCell class])];
    
    UIImageView * backgroundImageView = [[UIImageView alloc]initWithFrame:tempFrame];
    backgroundImageView.contentMode = UIViewContentModeScaleToFill;
    backgroundImageView.image = [UIImage sc_imageNamed:KSCImageImageSelectCellBackground];
    //    self.backgroundView = backgroundImageView;
    [_collectionView setBackgroundView:backgroundImageView];
    
    self.contentView.backgroundColor = [SCColor getColor:SC_COLOR_4];
}

- (void)setIcons:(NSMutableArray *)icons atIndexPath:(NSIndexPath *)indexPath{

    _iconArray = icons;
    
    if (!_iconArray) {
        _iconArray = [NSMutableArray new];
    }
    
    _indexPath = indexPath;
    
    NSInteger number =  _iconArray.count + 1;
    
    [_collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo((number/4+(number%4 > 0 ? 1 : 0)) *(ScreenWidth/4));
    }];
    
    [_collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  _iconArray.count + 1;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HSCImageItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HSCImageItemCell class]) forIndexPath:indexPath];
    
    
    if (indexPath.row == 0) {
        
        cell.iconView.image  = [UIImage sc_imageNamed:KSCImageImageSelectCellIconView];
        [cell.deleteBtn setHidden:YES];
        cell.indexPath = indexPath;
        cell.delegate = self;
    }else{
        
        cell.iconView.image  = _iconArray[indexPath.row-1];
        [cell.deleteBtn setHidden:NO];
        cell.indexPath = indexPath;
        cell.delegate = self;
        
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 && _iconArray.count < 6) {
        DEFINE_WEAK(self);
        [SCImageSelector showIn:self.viewController callback:^(UIImage* image) {
            
            if (image) {
                
                [wself selectImageCallback:image indexPath:indexPath];
                
            }
        } cropAspectRatio:1];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)selectImageCallback:(UIImage*) image indexPath:(NSIndexPath*)indexPath{
    if (!image)
        return;
    
    [_iconArray addObject:image];
    
    [self.delegate iconChanged:_iconArray indexPath:_indexPath];
    
}

#pragma mark - HSCImageItemCellDelegate

-(void)didClickDeleteButtonAtIndexPath:(NSIndexPath *)indexPath{
    
    [_iconArray removeObjectAtIndex:indexPath.row-1];
    
    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    
    [self.delegate iconChanged:_iconArray indexPath:_indexPath];
    
}

@end

