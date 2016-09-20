//
//  HSCImageSlecteCell.h
//  HSChannel
//
//  Created by SC on 16/9/3.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "SCTableViewController.h"

@protocol HSCImageSlecteCellDelegate <NSObject>

- (void)iconChanged:(NSMutableArray *)icons indexPath:(NSIndexPath*)indexPath;

@end

@interface HSCImageSlecteCell : SCTableViewCell

@property (nonatomic, weak  )id <HSCImageSlecteCellDelegate> delegate;

@property (nonatomic, strong)UICollectionView *collectionView;

@property (nonatomic, strong)NSMutableArray<UIImage*>* iconArray;

@property (nonatomic, strong)NSIndexPath* indexPath;

- (void)setIcons:(NSMutableArray *)icons atIndexPath:(NSIndexPath *)indexPath;

@end
