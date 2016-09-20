//
//  SCSWTableViewCell.m
//  HSChannel
//
//  Created by SC on 16/8/26.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "SCSWTableViewCell.h"

@implementation SCSWTableViewCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self setupSubviewsWithFrame:self.frame];
    }
    
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
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

- (void)setData:(id)data indexPath:(NSIndexPath*)indexPath{
    
}

@end
