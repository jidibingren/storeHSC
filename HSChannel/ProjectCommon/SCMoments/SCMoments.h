//
//  SCMoments.h
//  testMoments
//
//  Created by SC on 16/8/31.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#ifndef SCMoments_h
#define SCMoments_h


// 1.颜色
#define KColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define KRGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

// 2.随机色
//#define KRandomColor KColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

// 3.是否为iOS7
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)

//获取设备的物理高度
#define SCMScreenHeight ([UIScreen mainScreen].bounds.size.height)

//获取设备的物理宽度
#define SCMScreenWidth ([UIScreen mainScreen].bounds.size.width)

//#ifdef __OBJC__

//#import <AFNetworking.h>
//#import <UIKit+AFNetworking.h>
#import <Masonry.h>
//#import <ReactiveCocoa.h>
#import <MJRefresh.h>
#import <TZImagePickerController.h>
#import <TZPhotoPickerController.h>
#import <UIButton+WebCache.h>
#import <UIImageView+WebCache.h>
#import <MLLabel.h>
#import <MLLinkLabel.h>

#import "SCMomentsModel.h"
#import "SCMomentsViewModel.h"
#import "SCMomentsListViewModel.h"
#import "SCMomentCategory.h"
#import "SCMomentsCell.h"
#import "SCOperationMenu.h"
#import "SCMomentsOriginalView.h"
#import "SCMomentsCellCommentBgView.h"
#import "SCPhotoContainerView.h"
#import "SCPictureBrowser.h"
#import "SCMomentsViewController.h"

//#endif

#endif /* SCMoments_h */
