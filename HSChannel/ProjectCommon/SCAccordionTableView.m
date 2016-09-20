//
//  SCAccordionTableView.m
//  HSChannel
//
//  Created by SC on 16/8/26.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "SCAccordionTableView.h"

@implementation SCAccordionTableViewHeaderView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self setupSubviewsWithFrame:self.frame];
    }
    
    return self;
}

- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier{
    
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        [self setupSubviewsWithFrame:self.frame];
    }
    
    return self;
    
}

- (void)setupSubviewsWithFrame:(CGRect)frame{
    
}


- (void)setData:(id)data{
    
}

@end

@implementation SCAccordionTableView

@end
