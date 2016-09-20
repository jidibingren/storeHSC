

#import "SCBroadcastViewCell.h"

@implementation SCBroadcastViewCell

- (instancetype)initWithReuseIdentifier:(NSString*)reuseIdentifier
{
    self = [self init];
    if (self) {
        _reuseIdentifier = reuseIdentifier;
        self.exclusiveTouch = YES;
    }
    return self;
}

- (void)prepareForReuse
{
    
}

@end
