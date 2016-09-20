//
//  SCUserInfo.h
//  FindAFitting
//
//  Created by SC on 16/5/8.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCChildInfo : SCTableViewCellData

@property (nonatomic, assign) long long      id;
@property (nonatomic, strong) NSString      *name;
@property (nonatomic, strong) NSString      *jmSchName;
@property (nonatomic, strong) NSString      *jmsClassName;
@property (nonatomic, strong) NSString      *schName;
@property (nonatomic, strong) NSString      *address;
@property (nonatomic, strong) NSString      *grade;
@property (nonatomic, strong) NSString      *tchUsername;
@property (nonatomic, strong) NSString      *tchName;

@end

@interface SCUserInfo : NSObject

DECLARE_SINGLETON()


@property (nonatomic, strong) NSNumber *autoRefresh;
@property (nonatomic, strong) NSNumber *audioEable;


@property (atomic, strong) NSString *name;
@property (atomic, strong) NSString *phone;
@property (nonatomic, assign) NSInteger curType;

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *telCode;
@property (nonatomic, strong) NSString *series;
@property (nonatomic, strong) NSString *deviceType;
@property (nonatomic, strong) NSString *deviceName;
@property (nonatomic, strong) NSString *opeVersion;
@property (nonatomic, strong) NSString *access_token;
@property (nonatomic, strong) NSString *hxAccount;
@property (nonatomic, strong) NSString *hxPassword;
@property (nonatomic, strong) NSString *socketServerIP;
@property (nonatomic, strong) NSString *socketPort;
@property (atomic        ) BOOL      isLogined;

@property (nonatomic, strong)SCAddress *curAddress;

@property (nonatomic, strong) SCAccountInfo *accountInfo;
@property (nonatomic, strong) NSArray<SCChildInfo*> *children;
@property (nonatomic, strong) SCChildInfo *selectedChildren;


@property (atomic   , assign) NSInteger unreadMessageCount;
@property (nonatomic, strong) NSMutableArray *unreadMessage;
@property (atomic   , assign) NSInteger unreadSNCount;
@property (nonatomic, strong) NSMutableArray *unreadSN;
@property (atomic   , assign) NSInteger unreadCNCount;
@property (nonatomic, strong) NSMutableArray *unreadCN;
@property (atomic   , assign) NSInteger unreadCDCount;
@property (nonatomic, strong) NSMutableArray *unreadCD;
@property (atomic   , assign) NSInteger unreadCWCount;
@property (nonatomic, strong) NSMutableArray *unreadCW;
@property (atomic   , assign) NSInteger unreadCLCount;
@property (nonatomic, strong) NSMutableArray *unreadCL;
@property (atomic   , assign) NSInteger unreadCACount;
@property (nonatomic, strong) NSMutableArray *unreadCA;


@property (nonatomic, strong) NSMutableArray *recentContacts;
@property (nonatomic, strong) NSMutableArray *classesContacts;
@property (nonatomic, strong) NSMutableArray *parentsContacts;

@end
