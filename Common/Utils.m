
#import "Utils.h"
#ifdef SC_TP_TOAST
#import "UIView+Toast.h"
#endif
#import "NSStringEx.h"
//#import "SCTestViewController.h"
#import <CoreImage/CoreImage.h>
#ifdef SC_TP_BLOCKSKIT
#import <BlocksKit+UIKit.h>
#endif

//zzy add
//#import "JAMineController.h"

@implementation Utils : NSObject
// 判断通知中心是否开启
+ (BOOL) pushNotificationEnabled {
    UIApplication *application = [UIApplication sharedApplication];
    BOOL enabled = NO;
    // Try to use the newer isRegisteredForRemoteNotifications otherwise use the enabledRemoteNotificationTypes.
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)]) {
        enabled = [application isRegisteredForRemoteNotifications];
    }
    else {
        UIRemoteNotificationType types = [application enabledRemoteNotificationTypes];
        enabled = types != UIRemoteNotificationTypeNone;
    }
    return enabled;
}

#pragma mark-正则表达式验证手机号
+ (BOOL)isValiadateMobile:(NSString *)mobile
{
    NSString * MOBILE = @"^1\\d{10}$";// 正则表达式
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    BOOL res1 = [regextestmobile evaluateWithObject:mobile];
    if (res1 ) {
        return YES;
    } else {
        return NO;
    }
}

//UIColor 转UIImage
+ (UIImage*) createImageWithColor: (UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (UIImage *)createQRcodeWithString: (NSString *)string size:(CGSize)size
{
    // Setup the QR filter with our string
  CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
  [filter setDefaults];

  NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
  [filter setValue:data forKey:@"inputMessage"];
  CIImage *image = [filter valueForKey:@"outputImage"];

  // Calculate the size of the generated image and the scale for the desired image size
  CGRect extent = CGRectIntegral(image.extent);
  CGFloat scale = MIN(size.width / CGRectGetWidth(extent), size.height / CGRectGetHeight(extent));

  // Since CoreImage nicely interpolates, we need to create a bitmap image that we'll draw into
  // a bitmap context at the desired size;
  size_t width = CGRectGetWidth(extent) * scale;
  size_t height = CGRectGetHeight(extent) * scale;
  CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
  CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);

#if TARGET_OS_IPHONE
  CIContext *context = [CIContext contextWithOptions:nil];
#else
  CIContext *context = [CIContext contextWithCGContext:bitmapRef options:nil];
#endif

  CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];

  CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
  CGContextScaleCTM(bitmapRef, scale, scale);
  CGContextDrawImage(bitmapRef, extent, bitmapImage);

  // Create an image with the contents of our bitmap
  CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);

  // Cleanup
  CGContextRelease(bitmapRef);
  CGImageRelease(bitmapImage);
  return [UIImage imageWithCGImage:scaledImage];
}

+ (UIImage*) convertToCGBasedImageIfNeeded:(UIImage*)image {
    if (image.CGImage)
        return image;
    CGSize size = image.size;
    UIGraphicsBeginImageContext(size);
    CGRect rect;
    rect.origin = CGPointZero;
    rect.size   = size;
    [image drawInRect:rect];
    UIImage * convertedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return convertedImage;
}

+ (NSError*) makeError:(NSString *)localizedDescription {
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    [details setValue:localizedDescription forKey:NSLocalizedDescriptionKey];
    // populate the error object with the details
    return [NSError errorWithDomain:@"world" code:200 userInfo:details];
}

+ (void) alert:(NSString *)msg {
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:msg message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"确认", nil) otherButtonTitles:nil];
    [alter show];
}

+ (UIAlertView*) alertView :(NSString*)msg {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:msg message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"确认", nil) otherButtonTitles:nil];
    return alert;
}

+ (void) alert:(NSString *)msg delegate:(id)delegate {
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:msg message:nil delegate:delegate cancelButtonTitle:NSLocalizedString(@"确认", nil) otherButtonTitles:nil];
    [alter show];
}

//+ (CXAlertView*) alertView :(NSString*)title image:(NSString*)imageName {
//    UIImage *image = [UIImage imageNamed:imageName];
//    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
//    imageView.image = image;
//    CXAlertView *alert = [[CXAlertView alloc] initWithTitle:title contentView:imageView cancelButtonTitle:nil];
//    alert.showBackgroundView = YES;
//    alert.alertViewAlpha = 1.0;
//    alert.titleFont = [UIFont systemFontOfSize:SC_FONT_1];
//    alert.customButtonColor = [SCColor getColor:SC_COLOR_1];
//    alert.customButtonFont  = [UIFont systemFontOfSize:SC_FONT_1];
//    return alert;
//}

+ (BOOL) checkEmpty: (UITextField*)view withMsg: (NSString*)msg {
    if ([[view.text trim] isEmpty]) {
        [self isNilOrNSNull:msg] ? :[view makeShortToastAtCenter:msg];
        return NO;
    }
    return YES;
}

+ (BOOL) isNilOrNSNull:(id)object {
    return object == nil || [object isKindOfClass:[NSNull class]];
}

+ (BOOL) isNonnull:(id)object{
    return !(object == nil || object == NULL || object == [NSNull null] || [[NSString stringWithFormat:@"%@",object] isEqualToString:@"null"]);
}

+ (BOOL) isValidStr:(NSString *)str{
    return [self isNonnull:str] && ([str isKindOfClass:[NSString class]] || [str isKindOfClass:[NSMutableString class]]) && str.length > 0;
}

+ (BOOL) isValidData:(NSData *)data{
    return [self isNonnull:data] && ([data isKindOfClass:[NSData class]] || [data isKindOfClass:[NSMutableData class]]) && data.length > 0;
}

+ (BOOL) isValidArray:(NSArray *)array{
    return [self isNonnull:array] && ([array isKindOfClass:[NSArray class]] || [array isKindOfClass:[NSMutableArray class]]) && array.count > 0;
}

+ (BOOL) isValidDictionary:(NSDictionary *)dict{
    return [self isNonnull:dict] && ([dict isKindOfClass:[NSDictionary class]] || [dict isKindOfClass:[NSMutableDictionary class]]) && dict.count > 0;
}

+ (UIViewController *)topViewController{
    
    UIWindow *window = [self getDefaultWindow];
    if ([window isKindOfClass:[UIWindow class]] && [window.rootViewController isKindOfClass:[SCRootViewController class]]) {
        
        UINavigationController *navigationController = (UINavigationController *)((SCRootViewController*)window.rootViewController).selectedViewController;
        return [[navigationController viewControllers] lastObject];
    }else if ([window isKindOfClass:[UIWindow class]]){
        return [self topViewController:window.rootViewController];
    }
    
    return nil;
}

+ (UIViewController *)topViewController:(UIViewController *)rootViewController
{
    if (rootViewController.presentedViewController == nil) {
        return rootViewController;
    }
    
    if ([rootViewController.presentedViewController isMemberOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        return [self topViewController:lastViewController];
    }
    
    UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
    return [self topViewController:presentedViewController];
}

+ (UIWindow*) getDefaultWindow {
    
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if ([window isKindOfClass:[UIWindow class]] && [window.rootViewController isKindOfClass:[SCRootViewController class]]) {
            return window;
        }
    }
    
    return nil;
}

+ (void) makeShortToastAtCenter: (NSString*)toast {
    [[self topViewController].view makeShortToastAtCenter:toast];
}

+ (NSString*)pathInDocuments:(NSString *)subpath {
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [documentsPath stringByAppendingPathComponent:subpath];
}

+ (NSString*) pathInCaches: (NSString*)subpath {
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [cachesPath stringByAppendingPathComponent:subpath];
}

+ (NSError*) dontBackup:(NSString*)path {
    NSError* error = nil;
    NSURL * fileURL;
    fileURL = [ NSURL fileURLWithPath: path];
    [ fileURL setResourceValue: [ NSNumber numberWithBool: YES ] forKey: NSURLIsExcludedFromBackupKey error: &error ];
    if (error) {
      NSLog(@"Error in dontBackup %@, e = %@", path, error);
    }
    return error;
}

+ (NSString*)resourcePathInBundle:(NSString*)subpath {
    return [[NSBundle mainBundle] pathForResource:[subpath stringByDeletingPathExtension] ofType:subpath.pathExtension];
}

+ (NSString*)fileURLAbsoluteString:(NSString*)subpath {
    return [NSURL fileURLWithPath:[Utils resourcePathInBundle:subpath]].absoluteString;
}

+ (NSDate*) getFileLastModifiedTime:(NSString*)path {
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    NSDate *date = [attributes fileModificationDate];
    return date;
}

+ (BOOL) deployResourceFromBundleToCachesIfNeeded: (NSString*)subpath {
    NSFileManager * defaultManage = [NSFileManager defaultManager];
    NSError* error = nil;
    NSString* bundlePath = [Utils resourcePathInBundle:subpath];
    NSString* cachesPath = [Utils pathInCaches:subpath];
    if ([defaultManage fileExistsAtPath:cachesPath] && [[Utils getFileLastModifiedTime:cachesPath] isEqualToDate:[Utils getFileLastModifiedTime:bundlePath]]) {
        return YES;
    }
    [defaultManage removeItemAtPath:cachesPath error:nil];
    [defaultManage copyItemAtPath:bundlePath toPath:cachesPath error:&error];
    assert(!error);
    return error == nil;
}

+ (NSString*) getCurrentVersionShort {
    NSDictionary *localDic =[[NSBundle mainBundle] infoDictionary];
    NSString *localVersion =[localDic objectForKey:@"CFBundleShortVersionString"];
    return localVersion;
}

+ (NSString*) getCurrentVersionFull {
    NSDictionary *localDic =[[NSBundle mainBundle] infoDictionary];
    NSString *localVersion =[localDic objectForKey:@"CFBundleVersion"];
    return localVersion;
}

+ (NSString*) getCurrentAppLanguage {
    return [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0];
}

NSString* const LOGINED_KEY = @"logined";

+ (BOOL) isLogined {
    NSUserDefaults * userDefaultes = [NSUserDefaults standardUserDefaults];
    return [userDefaultes boolForKey:LOGINED_KEY];
}

+ (void) setLogined: (BOOL)logined {
    NSUserDefaults * userDefaultes = [NSUserDefaults standardUserDefaults];
    [userDefaultes setBool:logined forKey:LOGINED_KEY];
    if (!logined) {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:SC_KEY_CAN_VERIFY_CARD];
        [[NSUserDefaults standardUserDefaults]setValue:@"00" forKey:SC_KEY_USERID];
    }
}

+ (void) rememberUsername:(NSString*) text {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:text forKey:@"userPhoneNumber"];
}

+ (NSString*) getRememberedUsername {
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"userPhoneNumber"];
}

+ (void) showTestButtonOnNavBar:(UIViewController*)viewController {
#if defined(_DEBUG) || defined(SCTEST)
    {
        UIBarButtonItem * leftButtonItem = [[UIBarButtonItem alloc ]init];
        DEFINE_WEAK(viewController);
        [leftButtonItem bk_initWithTitle:@"测试" style:UIBarButtonItemStylePlain handler:^(id sender) {
            [wviewController.navigationController pushViewController:[[SCTestViewController alloc]init] animated:YES];
            
//            [wviewController.navigationController pushViewController:[JAMineController new] animated:YES];
        }];
        viewController.navigationItem.leftBarButtonItem= leftButtonItem;
    }
#endif
}

+ (void)enterTestPage {
//    [[Utils topViewController].navigationController pushViewController:[[SCTestViewController alloc] init] animated:YES];
}

+ (void) setupUserAgent {
    // Add scApp-xxx to default UserAgent
    NSString* appID = [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleExecutableKey];
    appID = [appID lowercaseString];
    NSString* userAgent = [NSString stringWithFormat:@"Mozilla/5.0 (iPhone; U; CPU iPhone OS 3_1_2 like Mac OS X; en-us) AppleWebKit/528.18 (KtHTML, like Gecko) Mobile/7D11 FindAFitting-ios/%@ lang/%@ devId/idfv_%@ UMSCashierPlugin/2.4.5 devType/%@ systemVersion/%@",
         [Utils getCurrentVersionShort], [[Utils getCurrentAppLanguage] substringToIndex:2], [[UIDevice currentDevice].identifierForVendor UUIDString], [BDEnvironment env].deviceType, [BDEnvironment env].systemVersion];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:userAgent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
}

+ (NSTimer *) asyncRunDelayed:(NSTimeInterval)delay block: (void (^)())block {
#ifdef SC_TP_BLOCKSKIT
    return [NSTimer bk_scheduledTimerWithTimeInterval:delay block:^(NSTimer* timer) {
        block();
    }repeats:NO];
#else
    return nil;
#endif
}

+ (void) dontBackupGeneratedFiles {
  [Utils dontBackup:[Utils pathInDocuments:@"baiduplist"]];
  [Utils dontBackup:[Utils pathInDocuments:@"cfg"]];
  [Utils dontBackup:[Utils pathInDocuments:@".UMSocialData.plist"]];
}

+ (int) compareVersion:(NSString*)version1 withVersion:(NSString*)version2 {
    return [version1 compare:version2 options:NSNumericSearch];
}

+ (NSString*) groupText:(NSString*)text seperator:(NSString*)seperator groupLength:(int)groupLength {
    NSMutableString* s = [NSMutableString new];
    BOOL first = YES;
    text = [text stringByReplacingOccurrencesOfString:seperator withString:@""];
    for (int i = 0; i < text.length; i++) {
        if (!first && i % groupLength == 0) {
            [s appendString:seperator];
        }
        [s appendFormat:@"%c", [text characterAtIndex:i]];
        if (first) {
            first = NO;
        }
    }
    return s;
}
+ (void) showLoginView {
 
}

+ (NSString *)formatStr:(NSString *)str replacement:(NSString *)replacement range:(NSRange)range{
    if (str.length < range.location+range.length) {
        return str;
    }
    NSMutableString *tempStr = [NSMutableString stringWithString:str];
    NSString * replaceStr = @"";
    
    for (NSUInteger i = range.location; i < range.location+range.length; i++) {
        replaceStr = [replaceStr stringByAppendingString:replacement];
    }
    [tempStr replaceCharactersInRange:range withString:replaceStr];
    return [NSString stringWithString:tempStr];
}

+ (NSString *)formatBankCardNum:(NSString *)bankNum replacement:(NSString *)replacement {
    NSString * str = [bankNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString * replaceStr = @"";
    if (str.length < 4) {
        return bankNum;
    }
    for (int i = 0; i < str.length - 4; i++) {
        replaceStr = [replaceStr stringByAppendingString:replacement];
    }
    return [NSString stringWithFormat:@"%@%@", replaceStr, [str substringWithRange:NSMakeRange(str.length - 4, 4)]];
}

+ (NSString *)getLoginToken{
    return [[NSUserDefaults standardUserDefaults]stringForKey:SC_SERVER_USER_TOKEN];
//    return @"123";
}

+ (void)setLoginToken:(NSString *)token{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:[Utils isNilOrNSNull:token] ? @"":token forKey:SC_SERVER_USER_TOKEN];
    [userDefaults synchronize];
}

+ (NSString *)encodeURLParameter:(NSString *)str {
    if ([self isNilOrNSNull:str] || (![str isKindOfClass:[NSString class]] && ![str isKindOfClass:[NSMutableString class]])){
        return @"";
    }
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (CFStringRef) str,
                                                                                 NULL,
                                                                                 (CFStringRef) @"!*'();:@&=+$,/?%#[]",
                                                                                 kCFStringEncodingUTF8));
    
}

+ (NSString *)keyChainStringForKey:(NSString *)key{
    NSString *str = nil;
#ifdef SC_TP_UICKEYCHAINSTORE
    str = [UICKeyChainStore stringForKey:key];
#endif
    return [self isValidStr:str] ? str : @"";
}

+ (void)setKeyChainString:(NSString *)string forKey:(NSString *)key{
#ifdef SC_TP_UICKEYCHAINSTORE
    [self isValidStr:key] && [self isValidStr:string] ? [UICKeyChainStore setString:string forKey:key] : NO;
#endif
}

+ (NSData *)keyChainDataForKey:(NSString *)key{
    
    NSData *data = nil;
#ifdef SC_TP_UICKEYCHAINSTORE
    data = [UICKeyChainStore dataForKey:key];
#endif
    return [self isValidData:data] ? data : [NSData data];
}

+ (void)setKeyChainData:(NSData *)data forKey:(NSString *)key{
#ifdef SC_TP_UICKEYCHAINSTORE
    [self isValidData:data] && [self isValidStr:key] ? [UICKeyChainStore setData:data forKey:key] : NO;
#endif
}

+ (NSArray *)keyChainArrayForKey:(NSString *)key{
    NSArray * array = [NSKeyedUnarchiver unarchiveObjectWithData:[self keyChainDataForKey:key]];
    return [self isValidArray:array] ? array : [[NSArray alloc]init];
}

+ (void)setKeyChainArray:(NSArray *)array forKey:(NSString *)key{
    [self isValidArray:array] && [self isValidStr:key] ? [self setKeyChainData:[NSKeyedArchiver archivedDataWithRootObject:array] forKey:key] : NO;
}

+ (void)addObjectToKeyChainArrayByKey:(NSString*)key objects:(id)firstObj, ... NS_REQUIRES_NIL_TERMINATION{
    va_list params;
    va_start(params,firstObj);
    id arg;
    if ([Utils isNonnull:firstObj]) {
        NSMutableArray *array = [[NSMutableArray alloc]initWithArray:[self keyChainArrayForKey:key]];

        if ([array indexOfObject:firstObj] == NSNotFound){
            [array addObject:firstObj];
        }
        
        while( (arg = va_arg(params,id)) )
        {
            if ([self isNonnull:arg] && [array indexOfObject:arg] == NSNotFound){
                [array addObject:arg];
            }
        }

        va_end(params);
        [Utils setKeyChainArray:array forKey:key];
    }
}

+ (NSDictionary *)keyChainDictionaryForKey:(NSString *)key{
    NSDictionary * dict = [NSKeyedUnarchiver unarchiveObjectWithData:[self keyChainDataForKey:key]];
    return [self isValidDictionary:dict] ? dict : [[NSDictionary alloc]init];
}

+ (void)setKeyChainDictionary:(NSDictionary *)dict forKey:(NSString *)key{
    [self isValidDictionary:dict] && [self isValidStr:key] ? [self setKeyChainData:[NSKeyedArchiver archivedDataWithRootObject:dict] forKey:key] : NO;
}

+ (void)removeKeyChainItemForKey:(NSString *)key{
#ifdef SC_TP_UICKEYCHAINSTORE
    [self isValidStr:key] ? [UICKeyChainStore removeItemForKey:key] : NO;
#endif
}

+ (void)removeKeyChainAllItems{
#ifdef SC_TP_UICKEYCHAINSTORE
    [UICKeyChainStore removeAllItems];
#endif
}

+ (UIFont *)fontWithSize:(CGFloat)size{
    return [UIFont fontWithName:@"Arial" size:size];
}

+ (UIFont *)boldFontWithSize:(CGFloat)size{
    return [UIFont boldSystemFontOfSize:size];
}

+ (CGSize)sizeForString:(NSString *)string font:(UIFont *)font constrainedToSize:(CGSize)constrainedSize lineBreakMode:(NSLineBreakMode)lineBreakMode {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = lineBreakMode;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    CGRect boundingRect = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    return CGSizeMake(ceilf(boundingRect.size.width), ceilf(boundingRect.size.height));
}

+ (void)makeCall:(NSString *)phone{
    
    if  ([self isValidStr:phone]){
        NSString *phoneNumber = [[NSString alloc] initWithFormat:@"telprompt://%@",phone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    }
}

+ (NSString *)getCustomDateFromSeconds:(long long)seconds{
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:seconds];
    NSTimeInterval interval = -[date timeIntervalSinceDate:[NSDate date]];
    NSString *tempStr = [dateFormatter stringFromDate:date];
    
    if (interval < 60) {
        tempStr = @"刚刚";
    }else if (interval < 3600) {
        tempStr = [NSString stringWithFormat:@"%lu分钟之前",(long)interval/60];
    }else if (interval < 3600*24) {
        tempStr = [tempStr substringWithRange:NSMakeRange(tempStr.length-8, 5)];
    }else if (interval < 3600*24*2) {
        tempStr = [NSString stringWithFormat:@"昨天%@",[tempStr substringWithRange:NSMakeRange(tempStr.length-8, 5)]];
    }else if (interval < 3600*24*3) {
        tempStr = [NSString stringWithFormat:@"前天%@",[tempStr substringWithRange:NSMakeRange(tempStr.length-8, 5)]];
    }else if (interval < 3600*24*365){
        tempStr = [tempStr substringWithRange:NSMakeRange(tempStr.length-14, 11)];
    }else {
        tempStr = [tempStr substringToIndex:10];
    }
    
    return tempStr;
}

+ (NSString *)getCustomDateToDayFromSeconds:(long long)seconds{
    
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSDate *referenceDate = [dateFormatter dateFromString:[[dateFormatter stringFromDate:[NSDate date]] substringToIndex:10]];
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:seconds];
    NSTimeInterval interval = -[date timeIntervalSinceDate:referenceDate];
    NSString *tempStr = nil;
    
    if (interval == 0) {
        tempStr = @"今天";
    }else if (interval == 3600*24) {
        tempStr = @"昨天";
    }else if (interval == 3600*24*2) {
        tempStr = @"前天";
    }else {
        tempStr = [dateFormatter stringFromDate:date];
    }
    
    return tempStr;
}

+ (NSString *)getDateToDayFromSeconds:(long long)seconds{
    
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:seconds];
    
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)getDateToHoureMinutesFromSeconds:(long long)seconds{
    
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:seconds];
    
    return [[dateFormatter stringFromDate:date] substringWithRange:NSMakeRange(11, 5)];
}

+ (NSString *)getCustomDateFromString:(NSString *)dateStr{
    
    NSString *tempStr = dateStr;
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [dateFormatter dateFromString:dateStr];
    NSTimeInterval interval = -[date timeIntervalSinceDate:[NSDate date]];
    
    if (interval < 60) {
        tempStr = @"刚刚";
    }else if (interval < 3600) {
        tempStr = [NSString stringWithFormat:@"%lu分钟之前",(long)interval/60];
    }else if (interval < 3600*24) {
        tempStr = [tempStr substringWithRange:NSMakeRange(tempStr.length-8, 5)];
    }else if (interval < 3600*24*2) {
        tempStr = [NSString stringWithFormat:@"昨天%@",[tempStr substringWithRange:NSMakeRange(tempStr.length-8, 5)]];
    }else if (interval < 3600*24*3) {
        tempStr = [NSString stringWithFormat:@"前天%@",[tempStr substringWithRange:NSMakeRange(tempStr.length-8, 5)]];
    }else if (interval < 3600*24*365){
        tempStr = [tempStr substringWithRange:NSMakeRange(tempStr.length-14, 11)];
    }else {
        tempStr = [tempStr substringToIndex:10];
    }
    
    return tempStr;
}

+ (NSString *)getDateToDayFromString:(NSString *)dateStr{
    
    NSString *tempStr = dateStr;
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSDate *referenceDate = [dateFormatter dateFromString:[[dateFormatter stringFromDate:[NSDate date]] substringToIndex:10]];
    NSDate *date = [dateFormatter dateFromString:[dateStr substringToIndex:10]];
    NSTimeInterval interval = -[date timeIntervalSinceDate:referenceDate];
    
    if (interval == 0) {
        tempStr = @"今天";
    }else if (interval == 3600*24) {
        tempStr = @"昨天";
    }else if (interval == 3600*24*2) {
        tempStr = @"前天";
    }else {
        tempStr = [tempStr substringToIndex:10];
    }
    
    return tempStr;
}

+ (NSDate*) dateFromString:(NSString*)str{
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [dateFormatter dateFromString:str];
    
    return date;
}

+ (long long) timeIntervalSinceReferenceDateFromString:(NSString*)str{
    NSDate *date = [self dateFromString:str];
    
    return date.timeIntervalSinceReferenceDate;
}

+ (long long) timeIntervalSince1970FromString:(NSString*)str{
    NSDate *date = [self dateFromString:str];
    
    return date.timeIntervalSince1970InMilliSecond;
}

+ (long long) timeIntervalSinceNowFromString:(NSString*)str{
    NSDate *date = [self dateFromString:str];
    
    return date.timeIntervalSinceNow;
}

//获取设备UUID
+(NSString *) getUUID{
    
    CFUUIDRef puuid = CFUUIDCreate( nil );
    
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    
    //CFRelease(puuid);
    
    //CFRelease(uuidString);
    
    return result;
    
}

+ (void)makeCallWithPhones:(NSArray*)phones{
    
    if (iOS8_OR_LATER) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        for (NSString *phone in phones) {
            
            if (![self isValidStr:phone]) {
                continue;
            }
            
            [alertController addAction:[UIAlertAction actionWithTitle:phone style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSString *phoneNumber = [[NSString alloc] initWithFormat:@"telprompt://%@",phone];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
            }]];
        }
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        
        [[self topViewController].navigationController presentViewController:alertController animated:YES completion:nil];
        
    }else{
        
        UIActionSheet *actionSheet = [UIActionSheet bk_actionSheetWithTitle:nil];
        
        for (NSString *phone in phones) {
            
            if (![self isValidStr:phone]) {
                continue;
            }
            
            [actionSheet bk_addButtonWithTitle:phone handler:^{
                NSString *phoneNumber = [[NSString alloc] initWithFormat:@"telprompt://%@",phone];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
            }];
        }
        
        [actionSheet bk_setCancelButtonWithTitle:@"取消" handler:nil];
        
        [actionSheet showInView:[self topViewController].view];
    }
    
}

+ (UIImage *)scaleImage:(UIImage *)image toSize:(float)size{
    
    CGFloat scale = size/image.size.width;
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scale, image.size.height * scale));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scale, image.size.height * scale)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
    
}

@end
