//
//  HSCContactModel.h
//  HSChannel
//
//  Created by SC on 16/8/26.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "SCTableViewController.h"

typedef NS_ENUM(NSInteger, HSCContactType) {
    HSCContactTeacher = 0,
    HSCContactParent,
    HSCContactClass,
};


@interface HSCContactGroupModel : SCTableViewCellData

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) BOOL      isSpread;
@property (nonatomic, assign) NSInteger totalNum;

@end

@interface HSCContactModel : SCDBModel

@property (nonatomic, assign) HSCContactType  contactType;
@property (nonatomic, strong) NSString       *username;
@property (nonatomic, strong) NSString       *name;
@property (nonatomic, strong) NSString       *signPhoto;
@property (nonatomic, strong) NSString       *hxAccount;
@property (nonatomic, strong) NSString       *telphone;
@property (nonatomic, strong) NSString       *className;
@property (nonatomic, assign) long long       classId;
@property (nonatomic, assign) BOOL            isSelected;
@property (nonatomic, assign) SCConversationType  chatType;

@end

@interface HSCRecentContactModel : HSCContactModel

@end

