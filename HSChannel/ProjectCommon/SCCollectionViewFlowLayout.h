//
//  SCCollectionViewFlowLayout.h
//  FindAFitting
//
//  Created by SC on 16/5/6.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import <UIKit/UIKit.h>


//layout
@class SCCollectionViewFlowLayout;
@protocol SCCollectionViewDelegateFlowLayout <UICollectionViewDelegateFlowLayout>

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout offsetForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface SCCollectionViewFlowLayout : UICollectionViewFlowLayout

@property (weak, nonatomic) id<SCCollectionViewDelegateFlowLayout> delegate;

@end
