
#import <UIKit/UIKit.h>

@interface SCBroadcastViewCell : UIView

@property (nonatomic, readonly, copy) NSString *reuseIdentifier;

- (void)prepareForReuse;

- (instancetype)initWithReuseIdentifier:(NSString*)reuseIdentifier;

@end
