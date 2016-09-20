
#import <Foundation/Foundation.h>

@interface NSString (SCMOMENT)

+ (NSString *)scm_utf8String:(NSString *)str;

+ (NSString *)scm_transformedValue:(long long)value;

- (BOOL)scm_isChinese;

- (BOOL)scm_isURL;

/**
 *  返回字符串所占用的尺寸
 *
 *  @param font    字体
 *  @param maxSize 最大尺寸
 */
- (CGSize)scm_sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW;
- (CGSize)scm_sizeWithFont:(UIFont *)font;

+ (NSString *)scm_timeWithDate:(NSDate *)date;


- (NSString *)scm_pinyin;
- (NSString *)scm_pinyinInitial;


/**
 *  正则判断手机号码
 */
- (BOOL)scm_isMobileNum;
@end
