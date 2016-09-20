
#import "SCBroadcastViewCell.h"

@class SCPicture;

@class SCPictureBrowserCell;
@protocol SCPictureBrowserCellDelegate <NSObject>

- (void)didTapForMLPictureCell:(SCPictureBrowserCell*)pictureCell ofIndex:(NSUInteger)index;

@optional

- (UIView*)customOverlayViewOfMLPictureCell:(SCPictureBrowserCell*)pictureCell ofIndex:(NSUInteger)index;

- (CGRect)customOverlayViewFrameOfMLPictureCell:(SCPictureBrowserCell*)pictureCell ofIndex:(NSUInteger)index;

@end

@interface SCPictureBrowserCell : SCBroadcastViewCell

@property(nonatomic,strong) SCPicture *picture;
@property(nonatomic,weak) id<SCPictureBrowserCellDelegate> delegate;

@end
