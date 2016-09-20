//
//  NSURL+NSURLEx.h
//  ShiHua
//
//  Created by Pingan Yi on 9/26/14.
//  Copyright (c) 2014 shuchuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (NSURLEx)
// 给一个URL后面添加新的query参数，比如"a=1"
- (NSURL *)URLByAppendingQueryString:(NSString *)queryString;
@end
