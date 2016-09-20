//
//  NewFeatureController.m
//  StudentBusiness
//
//  Created by wangliang on 16/4/5.
//  Copyright © 2016年 com.jinyouapp. All rights reserved.
//

#import "NewFeatureController.h"
#import "NewFeatureCell.h"

@interface NewFeatureController()
    @property(nonatomic,strong)UICollectionViewFlowLayout *flowLayout;

@end
@implementation NewFeatureController
static NSString * const reuseIdentifier = @"Cell";

#pragma mark - 初始化
- (instancetype)init {
    
    return [super initWithCollectionViewLayout:self.flowLayout];
}

- (UICollectionViewFlowLayout *)flowLayout {
    
    if (_flowLayout == nil) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        // 设置cell的尺寸
        flowLayout.itemSize = [UIScreen mainScreen].bounds.size;
        CGSize sert=[UIScreen mainScreen].bounds.size;
        //flowLayout.itemSize.height=ScreenHeight;
        // 清空行距
        flowLayout.minimumLineSpacing = 0;
        // 设置滚动方向
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _flowLayout = flowLayout;
    }
    
    return _flowLayout;
}

#pragma mark - 加载视图
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO; 
    self.navigationController.navigationBarHidden=YES;
    // 注册cell
    [self.collectionView registerClass:[NewFeatureCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // 以下的属性都是继承自UIScrollView
    self.collectionView.pagingEnabled = YES;                        // 按页翻转
    self.collectionView.bounces = NO;                               // 拉到底无反弹效果
    self.collectionView.showsHorizontalScrollIndicator = NO;        //不显示滚动条
}

#pragma mark <UICollectionViewDataSource>
// 有几组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

// 每组有几个
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 3;
}
// 设置每个cell的内容，cell长什么样
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    /* 1. 首先从缓冲池里取cell
     * 2. 检查当前是否注册了cell，如果注册了cell，就会帮你创建cell
     * 3. 如果发现没有注册，就会报错
     */
    NewFeatureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // 拼接图片
    NSString *imageName = [NSString stringWithFormat:@"%li", indexPath.row + 1];
    cell.image = [UIImage imageNamed:imageName];
    
    // 设置当前页码和最后一页码
    [cell setCurrentPageIndex:indexPath.row lastPageIndex:2];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>
@end
