

#import <UIKit/UIKit.h>

@class SCPictureBrowser;
@class SCPictureBrowserCell;
@class SCBroadcastView;
@protocol SCPictureBrowserDelegate <NSObject>

@optional
- (void)didScrollToIndex:(NSUInteger)index ofMLPictureBrowser:(SCPictureBrowser*)pictureBrowser;
- (void)didDisappearOfMLPictureBrowser:(SCPictureBrowser*)pictureBrowser;

@optional
- (UIView*)customOverlayViewOfMLPictureBrowser:(SCPictureBrowser*)pictureBrowser;
- (CGRect)customOverlayViewFrameOfMLPictureBrowser:(SCPictureBrowser*)pictureBrowser;

@optional
- (UIView*)customOverlayViewOfMLPictureCell:(SCPictureBrowserCell*)pictureCell ofIndex:(NSUInteger)index;
- (CGRect)customOverlayViewFrameOfMLPictureCell:(SCPictureBrowserCell*)pictureCell ofIndex:(NSUInteger)index;
@end

@interface SCPictureBrowser : UIViewController

@property(nonatomic,readonly,getter = mainView) SCBroadcastView *broadcastView;

@property(nonatomic,weak) id<SCPictureBrowserDelegate> delegate;
@property(nonatomic,strong) NSArray *pictures;
@property(nonatomic,assign,readonly) NSUInteger currentIndex;

- (void)showWithPictureURLs:(NSArray*)pictureURLs atIndex:(NSUInteger)index;

- (void)scrollToIndex:(NSUInteger)index animated:(BOOL)animated;
@end
