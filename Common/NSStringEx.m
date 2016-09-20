
@implementation NSString(Utils)

- (BOOL) isEmpty {
    return [self length] == 0;
}

- (NSString*) trim {
    NSString *trimmedText = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return trimmedText;
}

- (BOOL) contains: (NSString*)substr options:(NSStringCompareOptions)options {
    return [self rangeOfString:substr options:options].length > 0;
}

- (char) charValue {
    return (char) [self intValue];
}

- (BOOL) matchRegex: (NSString*)regex {
    NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    return [regexTest evaluateWithObject:self];
}

- (NSArray*) findAllWithRegex:(NSString*)regex {
    NSMutableArray* results = [NSMutableArray new];
    NSRegularExpression* reg = [NSRegularExpression regularExpressionWithPattern:regex options:0 error:nil];
    NSArray* regResults = [reg matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    for (NSTextCheckingResult* r in regResults) {
        NSMutableArray* groups = [NSMutableArray new];
        [results addObject:groups];
        for (int i = 0; i < r.numberOfRanges; i++) {
            NSString* s = [self substringWithRange:[r rangeAtIndex:i]];
            [groups addObject:s];
        }
    }
    return results;
}

- (NSArray*) findFirstRegex:(NSString*)regex {
    NSArray* results = [self findAllWithRegex:regex];
    if (results.count > 0) {
        return results[0];
    }
    return nil;
}

- (NSString*) replaceRegex:(NSString*)regex with:(NSString*)replacement {
    NSRegularExpression* reg = [NSRegularExpression regularExpressionWithPattern:regex options:0 error:nil];
    return [reg stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, self.length) withTemplate:replacement];
}

- (BOOL) isPhoneNumber {
    return [self matchRegex:@"^1[0-9]{10}$"];
}

- (BOOL) isValidatePassword {
    return [self matchRegex:@"^[A-Za-z0-9]{6,20}$"];
}

- (BOOL) isValidateUserName{
    return [self matchRegex:@"^[\u4e00-\u9fa50-9A-Za-z]{2,10}$"];
}

- (BOOL) isIdentityCardNumber{
    return [self matchRegex:@"^(\\d{14}|\\d{17})(\\d|[xX])$"];
}

- (BOOL) isSixteenICNumber {
    return [self matchRegex:@"^\\d{16,}$"];
}

- (BOOL) isNumber {
    return [self matchRegex:@"^[0-9]+([.][0-9]+){0,1}$"];
}

- (NSArray*) findAllSubstring: (NSString*)substring options:(NSStringCompareOptions)options {
    NSMutableArray* resuls = [[NSMutableArray alloc]init];
    NSRange range = [self rangeOfString:substring];
    while(range.location != NSNotFound)
    {
        [resuls addObject:[NSValue valueWithRange:range]];
        range = [self rangeOfString:substring options:options range:NSMakeRange(range.location + 1, [self length] - range.location - 1)];
    }
    return resuls;
}

- (NSString*) moneyFormatString{
    NSString *seperator = @",";
    int groupLength = 3;
    NSMutableString* s = [NSMutableString new];
    NSString *text = [self stringByReplacingOccurrencesOfString:seperator withString:@""];

    if (text == nil || [text isEqual:[NSNull null]] || text.length <= 0) {
        s = [NSMutableString stringWithFormat:@"0.00"];
    }else if (text.length <= 2) {
        s = [NSMutableString stringWithFormat:@"0.%02ld",(long)text.integerValue];
    }else {
        text = [text stringByReplacingOccurrencesOfString:seperator withString:@""];
        [s appendString:[NSMutableString stringWithFormat:@".%@",[text substringFromIndex:text.length-2]]];
        for (NSInteger i = text.length-3; i >= 0; i--) {
            [s insertString:[NSMutableString stringWithFormat:@"%c", [text characterAtIndex:i]] atIndex:0];
            if (i != 0 && (text.length-3-i) % groupLength == 2) {
                [s insertString:seperator atIndex:0];
            }
        }
    }
    return s;
}

- (BOOL)isVINCode{
    
    NSString* regext =@"^[A-HJ-NPR-Z_a-hj-npr-z_0-9]{17}$";
    NSPredicate *vinCodePre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regext];
    return [vinCodePre evaluateWithObject:self];
}

- (NSString *)encodeURLParameterString {
    if (self.length <=0){
        return self;
    }
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (CFStringRef) self,
                                                                                 NULL,
                                                                                 (CFStringRef) @"!*'();:@&=+$,/?%#[]",
                                                                                 kCFStringEncodingUTF8));
    
}

- (nullable id)valueForUndefinedKey:(NSString *)key{
    return nil;
}

+ (NSString*) fromInt: (int)intValue {
    return [NSString stringWithFormat:@"%d", intValue];
}

+ (NSString*) fromFloat: (float)floatValue {
    return [NSString stringWithFormat:@"%f", floatValue];
}

+ (NSString*) positiveNumberOrEmpty: (int)intValue {
    return intValue > 0 ? [self fromInt: intValue] : @"";
}

+ (CGRect)stringFrame:(NSString *)str font:(CGFloat)font size:(CGSize)size;
{
    NSDictionary * strDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:font], NSFontAttributeName, nil];
    CGRect strRect = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:strDic context:nil];
    return strRect;
}
@end