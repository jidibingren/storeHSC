//
//  JJNormalCellData.h
//  JJ56
//
//  Created by SC on 16/7/17.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "SCTableViewController.h"

@interface SCNormalCellData : SCTableViewCellData

@property (nonatomic, assign)BOOL     isMust;
@property (nonatomic, strong)NSString *leftIconName;
@property (nonatomic, strong)NSString *leftTitle;
@property (nonatomic, strong)NSString *middleText;
@property (nonatomic, assign)BOOL     middleTextEnabled;
@property (nonatomic, strong)NSString *placeholder;
@property (nonatomic, strong)NSString *rightImageName;
@property (nonatomic, strong)UIImage  *rightImageNameLocal;
@property (nonatomic, strong)NSString *rightIconName;
@property (nonatomic, strong)NSString *rightIconSelectedName;
@property (nonatomic, assign)BOOL     isImageSelect;
@property (nonatomic, strong)NSString *imageUploadUrl;
@property (nonatomic, strong)NSString *imageFileName;
@property (nonatomic, assign)BOOL     dontShowRightArrow;
@property (nonatomic, assign)NSInteger newsCount;

@end
