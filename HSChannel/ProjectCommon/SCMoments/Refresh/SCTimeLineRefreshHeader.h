
#import <UIKit/UIKit.h>
#import "SCBaseRefreshView.h"

@interface SCTimeLineRefreshHeader : SCBaseRefreshView

+ (instancetype)refreshHeaderWithCenter:(CGPoint)center;

@property (nonatomic, copy) void(^refreshingBlock)();

@end
