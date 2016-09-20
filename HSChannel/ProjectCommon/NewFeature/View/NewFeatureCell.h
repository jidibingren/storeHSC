//
//  NewFeatureCell.h
//  StudentBusiness
//
//  Created by wangliang on 16/4/5.
//  Copyright © 2016年 com.jinyouapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYImageScrollBaseCell.h"
@interface NewFeatureCell : JYImageScrollBaseCell
/**
 *  获取当前页码和最后一页的页码
 *
 *  @param currentIndex 当前页
 *  @param lastIndex    最后一页
 */
- (void)setCurrentPageIndex:(NSInteger)currentIndex lastPageIndex:(NSInteger)lastIndex;
@end
