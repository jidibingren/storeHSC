
@interface NSString(Utils)
- (BOOL) isEmpty;
- (NSString*) trim;
- (BOOL) contains: (NSString*)substr options:(NSStringCompareOptions)options;

// copy methods from NSNumber, then we can call these both for NSString and NSNumber
- (char) charValue;

// 正则表达式相关的
- (BOOL) matchRegex: (NSString*)regex;
// 返回第一个匹配的组, 没有找到返回nil
- (NSArray*) findFirstRegex:(NSString*)regex;
// 返回一个数组，数组每一项是一个NSArray（一个匹配组),没有找到返回空数组
- (NSArray*) findAllWithRegex:(NSString*)regex;
// 正则表达式替换
- (NSString*) replaceRegex:(NSString*)regex with:(NSString*)replacement;

- (BOOL) isPhoneNumber;
- (BOOL) isValidatePassword;
- (BOOL) isValidateUserName;
- (BOOL) isSixteenICNumber;
- (BOOL) isNumber;
// 身份证
- (BOOL) isIdentityCardNumber;

// 找出此字符串中所有的substring的range, rangeOfString的中的options
// 返回 NSArray, 每一项是一个包含NSRange的NSValue
- (NSArray*) findAllSubstring: (NSString*)substring options:(NSStringCompareOptions)options;
- (NSString*) moneyFormatString;
- (BOOL)isVINCode;

- (NSString *)encodeURLParameterString;

- (nullable id)valueForUndefinedKey:(NSString *_Nonnull)key;

+ (NSString*) fromInt: (int)intValue;
+ (NSString*) fromFloat: (float)floatValue;

// 如果intValue是正数，返回相应的字符串，否则返回空
+ (NSString*) positiveNumberOrEmpty: (int)intValue;

// 以下方法待重构，别用
//计算文字的宽度或高度 size的width为0计算高度 size的height为0计算宽度
+ (CGRect)stringFrame:(NSString *)str font:(CGFloat)font size:(CGSize)size;
@end