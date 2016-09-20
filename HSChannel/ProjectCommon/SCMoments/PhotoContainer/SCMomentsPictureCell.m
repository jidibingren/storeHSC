
#import "SCMomentsPictureCell.h"

@interface SCMomentsPictureCell()

@end

@implementation SCMomentsPictureCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self addSubview:imageView];
        self.imageView = imageView;
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setImageURL:(NSString *)imageURL
{
    _imageURL = imageURL;
    
    [self.imageView scm_getImageWithURL:imageURL placeholder:imageURL];
}
@end
