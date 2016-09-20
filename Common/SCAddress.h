//
//  SCAddress.h
//  FindAFitting
//
//  Created by SC on 16/5/8.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "SCTableViewController.h"

@interface SCAddress : SCTableViewCellData

@property (nonatomic        ) NSInteger id;
@property (nonatomic, strong) NSString *buyer;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *lng;
@property (nonatomic, strong) NSString *lat;
@property (nonatomic, strong) NSString *telephone;
@property (nonatomic        ) BOOL isDefault;
@property (nonatomic        ) BOOL isHome;
@property (nonatomic        ) BOOL isFirst;
@property (nonatomic        ) CLLocationCoordinate2D pt;
@property (nonatomic, strong) NSString *name;

@end
