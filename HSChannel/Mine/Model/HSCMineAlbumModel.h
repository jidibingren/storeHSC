//
//  HSCMineAlbumModel.h
//  HSChannel
//
//  Created by SC on 16/9/3.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "SCTableViewController.h"

@interface HSCMineAlbumModel : SCTableViewCellData

@property (nonatomic, strong)NSString *id;
@property (nonatomic, assign)long long createTim;
@property (nonatomic, strong)NSString *content;
@property (nonatomic, strong)NSArray *images;

@end
