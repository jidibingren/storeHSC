//
//  SCSWTableViewCell.h
//  HSChannel
//
//  Created by SC on 16/8/26.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import <SWTableViewCell/SWTableViewCell.h>

@interface SCSWTableViewCell : SWTableViewCell

@property (nonatomic, strong)id cellData;

@property (nonatomic, strong)NSIndexPath *indexPath;

- (void)setData:(id)data;

- (void)setData:(id)data indexPath:(NSIndexPath*)indexPath;

@end
