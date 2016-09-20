/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

#import <Foundation/Foundation.h>
@class  M13Checkbox;

// 用来状态view的方便的方法,不成熟，不推荐使用
@interface SCUIFactory : NSObject

+ (M13Checkbox *)customCheckBoxWithFrame:(CGRect)frame title:(NSString *)str strokeColor:(UIColor *)color radius:(CGFloat)radius;

+(UIView*)createViewWithFrame:(CGRect)frame;
+(UILabel*)createLabelWithFrame:(CGRect)frame Font:(float)font Text:(NSString*)text;
+(UIButton*)createButtonWithFrame:(CGRect)frame target:(id)target SEL:(SEL)method title:(NSString*)title imageName:(NSString*)imageName bgImageName:(NSString*)bgImageName;
+(UIImageView*)createImageViewFrame:(CGRect)frame imageName:(NSString*)imageName;
+(UITextField*)createTextFieldFrame:(CGRect)frame Font:(float)font textColor:(UIColor*)color leftImageName:(NSString*)leftImageName rightImageName:(NSString*)rightImageName bgImageName:(NSString*)bgImageName placeHolder:(NSString*)placeHolder sucureTextEntry:(BOOL)isOpen;
+ (UIColor *) colorWithHexString: (NSString *)color;
#pragma mark 判断IOS7下导航高度
+(float)navBarHeight;

@end
