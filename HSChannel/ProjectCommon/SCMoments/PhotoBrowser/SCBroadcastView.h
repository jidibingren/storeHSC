

#import <UIKit/UIKit.h>
#import "SCBroadcastViewCell.h"

@class SCBroadcastView;

@protocol SCBroadcastViewDataSource <NSObject>

@required

- (NSUInteger)cellCountOfBroadcastView:(SCBroadcastView *)broadcastView;
- (SCBroadcastViewCell *)broadcastView:(SCBroadcastView *)broadcastView cellAtPageIndex:(NSUInteger)pageIndex;

@end

@protocol SCBroadcastViewDelegate <NSObject>

@optional
- (void)didScrollToPageIndex:(NSUInteger)pageIndex ofBroadcastView:(SCBroadcastView *)broadcastView;
- (void)preOperateInBackgroundAtPageIndex:(NSUInteger)pageIndex ofBroadcastView:(SCBroadcastView *)broadcastView;
@end

@interface SCBroadcastView : UIView
@property (nonatomic,assign) NSUInteger padding;

@property (nonatomic,weak) id<SCBroadcastViewDataSource> dataSource;
@property (nonatomic,weak) id<SCBroadcastViewDelegate> delegate;
@property(nonatomic,assign) BOOL isAutoRoll;
@property (nonatomic,assign,readonly) NSUInteger currentPageIndex;

- (void)reloadData;
- (void)scrollToPageIndex:(NSUInteger)pageIndex animated:(BOOL)animated;

- (id)dequeueReusableCellWithIdentifier:(NSString*)identifier;

@end
