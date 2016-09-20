//
//  SCHeadlineCell.m
//  ShiHua
//
//  Created by SC on 15/5/4.
//  Copyright (c) 2015年 shuchuang. All rights reserved.
//

#import "SCHeadlineCell.h"
#import "SCHeadlineCellData.h"


#define DEFINE_SCPostNotificationNameHeadline(name) [NSString stringWithFormat:@"%@%@", wself.viewController.navigationController.topViewController,name]

#define kSCPostNotificationNameHeadlineDetail DEFINE_SCPostNotificationNameHeadline(@"SCNotificationNameHeadlineDetail")

#define kSCPostNotificationNameHeadlineOther DEFINE_SCPostNotificationNameHeadline(@"SCNotificationNameHeadlineOther")

#define PLACEHOLDER_IMAGE [UIImage imageNamed:@"school_pic_top"]
#define BACKGROUND_IMAGE  [UIImage imageNamed:@"school_pic_top"]

#define PAGE_CONTROL_HEIGHT  20
#define PAGE_INDICATORTINT_COLOR [UIColor colorWithRed:255 green:255 blue:255 alpha:0.5]

@implementation SCHeadlineCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self setupSubviewsWithFrame:frame];
    }
    return self;
}

- (void)setupSubviewsWithFrame:(CGRect)frame{
    CGRect tempFrame = frame;
    tempFrame.origin = CGPointZero;
    DEFINE_WEAK(self);
    
    self.backgroundView = [[UIImageView alloc] initWithImage:BACKGROUND_IMAGE];
    _cycleScrollView = [[CycleScrollView alloc]initWithFrame:tempFrame animationDuration:6];
    [self.contentView addSubview:_cycleScrollView];
    tempFrame.origin.y    = frame.size.height - PAGE_CONTROL_HEIGHT;
    tempFrame.size.height = PAGE_CONTROL_HEIGHT;
    _pageControl = [[UIPageControl alloc] initWithFrame:tempFrame];
    _pageControl.userInteractionEnabled = NO;
    _pageControl.pageIndicatorTintColor = PAGE_INDICATORTINT_COLOR;
    [self.contentView addSubview:_pageControl];
    
    _otherLabel = [[UILabel alloc]init];
    [_otherLabel setFont:[Utils fontWithSize:SC_FONT_3]];
    _otherLabel.textColor = [SCColor getColor:SC_COLOR_TEXT_6];
    [_otherLabel setTextAlignment:NSTextAlignmentLeft];
    _otherLabel.layer.cornerRadius = 15;
    _otherLabel.layer.backgroundColor = [SCColor getColor:@"dd3e3e"].CGColor;
    _otherLabel.layer.masksToBounds = YES;
    
    [self.contentView addSubview:_otherLabel];
    [_otherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView).offset(-30);
        make.right.mas_equalTo(self.contentView).offset(15);
        make.width.mas_greaterThanOrEqualTo(60);
        make.height.mas_equalTo(30);
    }];
    _otherLabel.userInteractionEnabled = YES;
    
    [_otherLabel bk_whenTapped:^{
        NSString *url = self.cellData.otherDetail;
        if (![Utils isNilOrNSNull:url] && url.length > 0) {
            if (![url hasPrefix:@"http://"] && ![url hasPrefix:@"https://"] ) {
                url = [NSString stringWithFormat:@"%@%@", BASEURL, url];
            }
            [[NSNotificationCenter defaultCenter]postNotificationName:kSCPostNotificationNameHeadlineOther object:url];
            
            return ;
        }
    }];
    
    [_otherLabel setHidden:YES];

}


- (void)setData:(SCCollectionViewCellData *)data{
    SCHeadlineCellData *cellData = (SCHeadlineCellData *)data;
    _cellData = cellData;
    NSMutableArray * viewArray = [NSMutableArray arrayWithCapacity:1];
    _pageControl.numberOfPages = cellData.dataArray.count;
    
    NSUInteger count = [cellData.dataArray count];
    if (count <=0) {
        return;
    }
    NSUInteger tempCount = count >= 3 ? count : (count == 1 ? 3 : 4);
    for (int i = 0; i < tempCount; i++) {
        CGRect tempRect = self.frame;
        tempRect.origin = CGPointZero;
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:tempRect];
        imageView.userInteractionEnabled = YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:[[cellData.dataArray objectAtIndex:i%count] objectForKey:keyThumbnail]] placeholderImage:PLACEHOLDER_IMAGE];
        [viewArray addObject:imageView];
    }
    
    DEFINE_WEAK(self);
    self.cycleScrollView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex, BOOL isSelected){
        if (isSelected) {
            
            wself.pageControl.currentPage = pageIndex % wself.pageControl.numberOfPages;
            
        }
        return viewArray[pageIndex];
    };
    
    self.cycleScrollView.totalPagesCount = ^NSInteger(void){
        return viewArray.count;
    };
    
    self.cycleScrollView.TapActionBlock = ^(NSInteger pageIndex){
        pageIndex = pageIndex % cellData.dataArray.count;
        NSString* url = cellData.dataArray[pageIndex][keyDetailPage];
        NSDictionary* additionalInfo = cellData.dataArray[pageIndex][keyAdditionalInfo];
        if (![Utils isNilOrNSNull:additionalInfo]){
            [[NSNotificationCenter defaultCenter]postNotificationName:kSCPostNotificationNameHeadlineDetail object:additionalInfo];
        }else if (![Utils isNilOrNSNull:url] && url.length > 0) {
            if (![url hasPrefix:@"http://"] && ![url hasPrefix:@"https://"] ) {
                url = [NSString stringWithFormat:@"%@%@", BASEURL, url];
            }
            [[NSNotificationCenter defaultCenter]postNotificationName:kSCPostNotificationNameHeadlineDetail object:url];
            
            return ;
        }
    };
    
    self.otherLabel.text = [NSString stringWithFormat:@"  %@    ",cellData.otherTitle];
    
    [self.otherLabel setHidden:cellData.otherTitle == nil];
}

@end
