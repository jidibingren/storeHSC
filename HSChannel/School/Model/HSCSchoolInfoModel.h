//
//  HSCSchoolInfoModel.h
//  HSChannel
//
//  Created by SC on 16/8/30.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "SCTableViewController.h"

@interface HSCSchoolInfoModel : SCTableViewCellData

@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSArray  *images;
@property (nonatomic, strong)NSString *schoolDescs;
@property (nonatomic, strong)NSString *address;
@property (nonatomic, strong)NSString *webPages;
@property (nonatomic, strong)NSString *contacts;
@property (nonatomic, strong)NSString *contactsNum;
@property (nonatomic, strong)NSArray  *leaflets;

@end
