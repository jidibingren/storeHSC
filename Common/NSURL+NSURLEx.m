//
//  NSURL+NSURLEx.m
//  ShiHua
//
//  Created by Pingan Yi on 9/26/14.
//  Copyright (c) 2014 shuchuang. All rights reserved.
//

#import "NSURL+NSURLEx.h"

@implementation NSURL (NSURLEx)
- (NSURL *)URLByAppendingQueryString:(NSString *)queryString {
    if (![queryString length]) {
        return self;
    }
    
    NSString *URLString = [[NSString alloc] initWithFormat:@"%@%@%@", [self absoluteString],
                           [self query] ? @"&" : @"?", queryString];
    NSURL *theURL = [NSURL URLWithString:URLString];
    return theURL;
}
@end
