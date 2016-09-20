//
//  SCHeadlineCell.h
//  ShiHua
//
//  Created by SC on 15/5/4.
//  Copyright (c) 2015年 shuchuang. All rights reserved.
//

#import "SCCollectionViewController.h"
#import "CycleScrollView.h"

//DEFINE_CONST_STRING(kSCNotificationNameHeadlineDetail);
//#define kSCNotificationNameHeadlineDetail [NSString stringWithFormat:@"%@",self]
#define DEFINE_SCNotificationNameHeadline(name) [NSString stringWithFormat:@"%@%@",self,name]

#define kSCNotificationNameHeadlineDetail DEFINE_SCNotificationNameHeadline(@"SCNotificationNameHeadlineDetail")

#define kSCNotificationNameHeadlineOther DEFINE_SCNotificationNameHeadline(@"SCNotificationNameHeadlineOther")

#define keyThumbnail  @"imageUrl"
#define keyDetailPage @"imageHref"
#define keyAdditionalInfo @"additionalInfo"

@interface SCHeadlineCell : SCCollectionViewCell

STD_PROP CycleScrollView *cycleScrollView;
STD_PROP UIPageControl *pageControl;
STD_PROP UILabel *otherLabel;

STD_PROP SCHeadlineCellData *cellData;

@end
