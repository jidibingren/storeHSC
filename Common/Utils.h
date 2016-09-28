
@interface Utils : NSObject

// 方便的创建一个NSError
+ (NSError*) makeError: (NSString*)localizedDescription;

//判断手机号
+ (BOOL)isValiadateMobile:(NSString *)mobile;

// 显示一个AlertView
+ (void) alert :(NSString*)msg;

// 只获取一个alertView,不显示
+ (UIAlertView*) alertView :(NSString*)msg;

+ (void) alert:(NSString *)msg delegate:(id)delegate;

//+ (CXAlertView*) alertView :(NSString*)title image:(NSString*)imageName;

// 检查 textField, 如果trim之后为空, 显示一个内容为msg的toast 
+ (BOOL) checkEmpty: (UITextField*)view withMsg: (NSString*)msg;

// return YES if object is nil or [NSNull null] 
+ (BOOL) isNilOrNSNull: (id)object;

+ (BOOL) isNonnull:(id)object;

+ (BOOL) isValidStr:(NSString *)str;

+ (BOOL) isValidData:(NSData *)data;

+ (BOOL) isValidArray:(NSArray *)array;

+ (BOOL) isValidDictionary:(NSDictionary *)dict;

// 显示当前显示的最外层viewController，（慎用，实验性的)
+ (UIViewController *)topViewController;

// 显示一个全局的UIWindow(也是一个UIView)
+ (UIWindow*) getDefaultWindow;

// 在当前ViewController中间显示一个Toast
+ (void) makeShortToastAtCenter: (NSString*)toast;

// 显示一个在Documents中完整path, 用法: [Utils pathInDocuments:@"config.plist"]
+ (NSString*) pathInDocuments: (NSString*)subpath;
+ (NSString*) pathInCaches: (NSString*)subpath;
// 显示一个在bundle resource中的完整path, 用法: [Utils resourcePathInBundle:@"config.plist"]
+ (NSString*) resourcePathInBundle:(NSString *)subpath;
// 显示一个用bundle resource中的完整path生成的URL的absoluteString, 用法: [Utils fileURLAbsoluteString:@"config.plist"]
+ (NSString*) fileURLAbsoluteString:(NSString*)subpath;
// 让iClound不备份某个目录
+ (NSError*) dontBackup:(NSString*)path;

// 把某个文件从bundle中copy到caches目录中
+ (BOOL) deployResourceFromBundleToCachesIfNeeded: (NSString*)subpath;

// return CFBundleShortVersionString
+ (NSString*) getCurrentVersionShort;
// return CFBundleVersion
+ (NSString*) getCurrentVersionFull;
// return the first preferred language
+ (NSString*) getCurrentAppLanguage;

// 比较两个版本号
+ (int) compareVersion:(NSString*)version1 withVersion:(NSString*)version2;

// 当前用户的登陆信息，存在NSUserDefaults中
+ (BOOL) isLogined;
+ (void) setLogined: (BOOL)logined;
// 最近一次登陆的用户名
+ (void) rememberUsername:(NSString*) text;
+ (NSString*) getRememberedUsername;

// 在右上角显示一个测试按钮，只有_DEBUG或者SCTEST定义了才会显示
+ (void) showTestButtonOnNavBar:(UIViewController*)viewController;

// 设置系统默认的User-Agent字段，http请求时用到
+ (void) setupUserAgent;

// 异步的执行某段代码，delay可以是０（也是异步的）
+ (NSTimer *) asyncRunDelayed:(NSTimeInterval)delay block: (void (^)())block;

// 让iClound不备份某些已知的第三库生成的文件
+ (void) dontBackupGeneratedFiles;

// 检测用户是否容许推送
+ (BOOL) pushNotificationEnabled;

// 创建一个1*1的纯色的UIImage
+ (UIImage*) createImageWithColor: (UIColor*) color;

// 创建一个指定大小的二维码图片
+ (UIImage *)createQRcodeWithString: (NSString *)string size:(CGSize)size;

// 把一个图片转换成CGImage based UIImage,如果需要的话
+ (UIImage*) convertToCGBasedImageIfNeeded:(UIImage*)image;

+ (NSString*) groupText:(NSString*)text seperator:(NSString*)seperator groupLength:(int)groupLength;
+ (void)showLoginView;
+ (NSString *)formatStr:(NSString *)str replacement:(NSString *)replacement range:(NSRange)range;
/**
 *  格式化银行卡，默认显示后4位
 *
 *  @param bankNum     银行卡卡号
 *  @param replacement 替换的符号
 *
 *  @return 替换完的卡号
 */
+ (NSString *)formatBankCardNum:(NSString *)bankNum replacement:(NSString *)replacement;

+ (void) takePictureFrom:(id)viewController fileName:(NSString *)fileName attributes:(NSDictionary *)attributes callback:(void (^)())callback;

+ (NSString *)getLoginToken;

+ (void)setLoginToken:(NSString *)token;

+ (NSString *)encodeURLParameter:(NSString *)str;

// methods for KeyChain
+ (NSString *)keyChainStringForKey:(NSString *)key;

+ (void)setKeyChainString:(NSString *)string forKey:(NSString *)key;

+ (NSData *)keyChainDataForKey:(NSString *)key;

+ (void)setKeyChainData:(NSData *)data forKey:(NSString *)key;

+ (NSArray *)keyChainArrayForKey:(NSString *)key;

+ (void)setKeyChainArray:(NSArray *)array forKey:(NSString *)key;

+ (void)addObjectToKeyChainArrayByKey:(NSString*)key objects:(id)firstObj, ... NS_REQUIRES_NIL_TERMINATION;

+ (NSDictionary *)keyChainDictionaryForKey:(NSString *)key;

+ (void)setKeyChainDictionary:(NSDictionary *)dict forKey:(NSString *)key;

+ (void)removeKeyChainItemForKey:(NSString *)key;

+ (void)removeKeyChainAllItems;

+ (UIFont *)fontWithSize:(CGFloat)size;

+ (UIFont *)boldFontWithSize:(CGFloat)size;

+ (CGSize)sizeForString:(NSString *)string font:(UIFont *)font constrainedToSize:(CGSize)constrainedSize lineBreakMode:(NSLineBreakMode)lineBreakMode;

+ (void)makeCall:(NSString *)phone;

+ (NSString *)getCustomDateFromSeconds:(long long)seconds;

+ (NSString *)getDateToDayFromSeconds:(long long)seconds;

+ (NSString *)getCustomDateToDayFromSeconds:(long long)seconds;

+ (NSString *)getDateToHoureMinutesFromSeconds:(long long)seconds;

+ (NSString *)getCustomDateFromString:(NSString *)dateStr;

+ (NSString *)getDateToDayFromString:(NSString *)dateStr;

+ (NSDate*) dateFromString:(NSString*)str;

+ (long long) timeIntervalSinceReferenceDateFromString:(NSString*)str;

+ (long long) timeIntervalSince1970FromString:(NSString*)str;

+ (long long) timeIntervalSinceNowFromString:(NSString*)str;

//获取设备UUID
+(NSString *) getUUID;

+ (void)makeCallWithPhones:(NSArray*)phones;

+ (UIImage *)scaleImage:(UIImage *)image toSize:(float)size;

@end

// 触摸背景，关闭键盘
#define TOUCHES_BEGAN_HIDE_KEYBOARD_AUTOMATICALLY   \
    - (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event \
    { \
        [self.view endEditing:YES]; \
    }

// 输入时按回车键，关闭键盘
#define TEXT_RETURN_HIDE_KEYBOARD_AUTOMATICALLY \
    -(BOOL)textFieldShouldReturn:(UITextField *)textField { \
        [textField resignFirstResponder]; \
        return YES;  \
    }

#define SELF_CLASS_NAME() NSStringFromClass([self class])

//// 申明一个静态方法sharedInstance，同时屏蔽init方法，使这个类成为单例
//#define DECLARE_SINGLETON() +(instancetype)sharedInstance; \
//    -(instancetype) init __attribute__((unavailable("init not available")));
//
//// 实现单例所需要的方法: sharedInstance
//#define IMPLEMENT_SINGLETON()                         \
//    +(instancetype)sharedInstance {                                    \
//        static id instance = nil;                   \
//        static dispatch_once_t onceToken;                   \
//        dispatch_once(&onceToken, ^{                        \
//            instance = [[self alloc] init];            \
//        });                                                 \
//        return instance;                                    \
//    }

// 申明一个静态方法sharedInstance，同时屏蔽init方法，使这个类成为单例
#define DECLARE_SINGLETON() DECLARE_SINGLETON_WITH_NAME(sharedInstance)

#define DECLARE_SINGLETON_WITH_NAME(signleName) +(instancetype)signleName; \
    -(instancetype) init __attribute__((unavailable("init not available")));

// 实现单例所需要的方法: sharedInstance
#define IMPLEMENT_SINGLETON() IMPLEMENT_SINGLETON_WITH_NAME(sharedInstance)

#define IMPLEMENT_SINGLETON_WITH_NAME(signleName)           \
    +(instancetype)signleName {                             \
        static id instance = nil;                           \
        static dispatch_once_t onceToken;                   \
        dispatch_once(&onceToken, ^{                        \
            instance = [[self alloc] init];                 \
        });                                                 \
        return instance;                                    \
    }

// 定义一个常量字符串，static,　名字和值相同
#define DEFINE_CONST_STRING(name) static NSString* const name = @ #name;

// 定义一个加上'w'前缀的weak变量，比如 DEFINE_WEAK(self)会生成 wself
#define DEFINE_WEAK(variable) __weak typeof(variable) w##variable = variable;

// standard property
#define STD_PROP @property(nonatomic, strong) 

// 给一个系统的类添加成员，通过[NSObject setAssociatedObject]方式实现,参见NSObject+SCUtils.h文件
#define IMPLEMENT_ASSOCIATED_FIELD(Type, fieldName) \
    static char fieldName##Key; \
    - (Type)fieldName { \
    return [self associatedObjectForKey:&fieldName##Key]; \
    } \
    - (void) set_##fieldName:(Type)fieldName { \
    [self setAssociatedObject:fieldName forKey:&fieldName##Key]; \
    }

#define DECLARE_ASSOCIATED_FIELD(Type, fieldName) \
    @property(nonatomic, strong, setter=set_##fieldName:) Type fieldName;

#define DECLARE_ASSOCIATED_FIELD_NOSTRONG(Type, fieldName) \
    @property(nonatomic, setter=set_##fieldName:) Type fieldName;

// 加到某个函数后面，表明这个函数是abstract的，子类应该实现它，比如 void test() ABSTRACT_METHOD
#define ABSTRACT_METHOD {\
     [self doesNotRecognizeSelector:_cmd]; \
     __builtin_unreachable(); \
    }

//获取设备的物理高度
#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)

//获取设备的物理宽度
#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)

#define LongWidthRatio (ScreenHeight/ScreenWidth)

#define iOS7_OR_LATER ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)
#define iOS8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define iOS9_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
// 兼容旧代码
#define iOS7 iOS7_OR_LATER

// 求x/y, 但是向上取整，比如 ROUND_UP(4, 3) == 2, but 4/3 == 1
#define ROUND_UP(x, y) ((x + y - 1)/y)

typedef void (^Block)(void);

#define UMENG_APP_KEY ([[BDEnvironment env] umengAppKey])