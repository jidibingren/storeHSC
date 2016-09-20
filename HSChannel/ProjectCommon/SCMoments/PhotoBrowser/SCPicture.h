
#import <Foundation/Foundation.h>

@interface SCPicture : NSObject

@property(nonatomic,assign) NSUInteger index;
@property(nonatomic,strong) NSURL *url;
@property (nonatomic,strong) UIImage *image;
@property(nonatomic,assign) BOOL isLoaded;

@end
