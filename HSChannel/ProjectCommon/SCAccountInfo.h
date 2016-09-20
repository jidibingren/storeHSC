//
//  SCAccountInfo.h
//  JJ56
//
//  Created by SC on 16/6/5.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "SCTableViewController.h"


@interface SCAccountInfo : SCTableViewCellData

@property (nonatomic, strong) NSString      *username;
@property (nonatomic, strong) NSString      *name;
@property (nonatomic, strong) NSString      *hxAccount;
@property (nonatomic, strong) NSString      *hxPasswd;
@property (nonatomic, strong) NSString      *signPhoto;
@property (nonatomic, assign) NSInteger      userType;
@property (nonatomic, strong) NSString      *telphone;
@property (nonatomic, strong) NSString      *phone2;


@end
