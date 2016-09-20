//
//  JYImageScrollBaseCell.h
//  StudentBusiness
//
//  Created by wangliang on 16/4/5.
//  Copyright © 2016年 com.jinyouapp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYImageScrollBaseCell : UICollectionViewCell
/**
 *  滚动图片
 */
@property (nonatomic, strong) UIImage *image;

/**
 *  图片链接URL
 */
@property (nonatomic, strong) NSURL *imagePath;

@end
