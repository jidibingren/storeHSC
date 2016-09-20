/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

#import "SCUIFactory.h"
#ifdef SC_TP_M13CHECKBOX
#import "M13Checkbox.h"
#endif

@implementation SCUIFactory
#ifdef SC_TP_M13CHECKBOX
+ (M13Checkbox *)customCheckBoxWithFrame:(CGRect)frame title:(NSString *)str strokeColor:(UIColor *)color radius:(CGFloat)radius
{
    M13Checkbox *checkbox = [[M13Checkbox alloc] initWithTitle:str];
    checkbox.checkAlignment = M13CheckboxAlignmentLeft;
    checkbox.frame = CGRectMake(frame.origin.x, frame.origin.y, checkbox.frame.size.width, checkbox.frame.size.height);
    checkbox.checkHeight = frame.size.height;
    checkbox.titleLabel.textColor = [SCUIFactory colorWithHexString:COLOR_GRAY_FONT];
    checkbox.titleLabel.font = [UIFont systemFontOfSize:frame.size.height];
    checkbox.radius = radius;
    checkbox.strokeWidth = 0.5;
    checkbox.strokeColor = color;
    return checkbox;
}
#endif

+(UIView*)createViewWithFrame:(CGRect)frame
{
    UIView*view=[[UIView alloc]initWithFrame:frame];
    return view;
}

+(UILabel*)createLabelWithFrame:(CGRect)frame Font:(float)font Text:(NSString*)text
{
    UILabel*label=[[UILabel alloc]initWithFrame:frame];
    label.font=[UIFont systemFontOfSize:font];
    //设置折行方式 NSLineBreakByWordWrapping是按照单词折行
    label.lineBreakMode=NSLineBreakByWordWrapping;
    label.numberOfLines=0;
    label.textAlignment=NSTextAlignmentLeft;
    label.backgroundColor=[UIColor clearColor];
    label.text=text;
    //label.adjustsFontSizeToFitWidth=YES;
    return label;
}

+(UIButton*)createButtonWithFrame:(CGRect)frame target:(id)target SEL:(SEL)method title:(NSString*)title imageName:(NSString*)imageName bgImageName:(NSString*)bgImageName
{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:bgImageName] forState:UIControlStateNormal];
    button.frame=frame;
    
    [button addTarget:target action:method forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+(UIImageView*)createImageViewFrame:(CGRect)frame imageName:(NSString*)imageName{
    UIImageView*imageView=[[UIImageView alloc]initWithFrame:frame];
    imageView.image=[UIImage imageNamed:imageName];
    imageView.userInteractionEnabled=YES;
    return imageView;
}

+(UITextField*)createTextFieldFrame:(CGRect)frame Font:(float)font textColor:(UIColor*)color leftImageName:(NSString*)leftImageName rightImageName:(NSString*)rightImageName bgImageName:(NSString*)bgImageName
{
    UITextField*textField=[[UITextField alloc]initWithFrame:frame];
    textField.font=[UIFont systemFontOfSize:font];
    textField.textColor=color;
    UIImage*image=[UIImage imageNamed:leftImageName];
    UIImageView*letfImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    textField.leftView=letfImageView;
    
    textField.leftViewMode=UITextFieldViewModeAlways;
    UIImage*rightImage=[UIImage imageNamed:rightImageName];
    UIImageView*rightImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, rightImage.size.width, rightImage.size.height)];
    textField.rightView=rightImageView;
    
    textField.rightViewMode=UITextFieldViewModeAlways;
    textField.clearButtonMode=YES;
    return textField;

}

+(UITextField*)createTextFieldFrame:(CGRect)frame Font:(float)font textColor:(UIColor*)color leftImageName:(NSString*)leftImageName rightImageName:(NSString*)rightImageName bgImageName:(NSString*)bgImageName placeHolder:(NSString*)placeHolder sucureTextEntry:(BOOL)isOpen
{
   UITextField*textField= [SCUIFactory createTextFieldFrame:frame Font:font textColor:color leftImageName:leftImageName rightImageName:rightImageName bgImageName:bgImageName];
    textField.placeholder=placeHolder;
    textField.secureTextEntry=isOpen;
    return textField;
}

+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

+ (float)navBarHeight
{
    if (iOS7) {
        return 64;
    }else{
        return 44;
    } 
}

@end
