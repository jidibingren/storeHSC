

#import "UIImageView+SCMOMENT.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (SCMOMENT)

- (void)scm_getImageWithURL:(NSString *)url placeholder:(NSString *)placeholder
{
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:placeholder]];
    
//    [self sd_setImageWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:placeholder]];
}

@end
