//
//  JYImageScrollBaseCell.m
//  StudentBusiness
//
//  Created by wangliang on 16/4/5.
//  Copyright © 2016年 com.jinyouapp. All rights reserved.
//

#import "JYImageScrollBaseCell.h"
#import "UIImageView+WebCache.h"
@interface JYImageScrollBaseCell()
// 显示的图片
@property (nonatomic, weak) UIImageView *imageView;

@end
@implementation JYImageScrollBaseCell
#pragma mark - 懒加载
- (UIImageView *)imageView
{
    if (_imageView == nil) {
        UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        CGRect res=self.contentView.bounds;
        _imageView = tempImageView;
        // 注意：一定要加载到contentView上，如果加载到view上则有可能被遮住
        [self.contentView addSubview:tempImageView];
        
    }
    
    return _imageView;
}

#pragma mark -重写set方法
- (void)setImage:(UIImage *)image {
    
    _image = image;
    
    self.imageView.image = image;
}

- (void)setImagePath:(NSURL *)imagePath {
    
    _imagePath = imagePath;
    [_imageView setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage sc_imageNamed: KSCImageJYImageScrollBaseCellImageView]];
}

@end
