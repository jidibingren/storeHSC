//
//  SCHttpTool+JJ56.m
//  JJ56
//
//  Created by SC on 16/6/5.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "SCHttpTool+ProjectEx.h"

@implementation SCHttpTool (ProjectEx)

+ (void)requestUserInfo{
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"access_token"] = [Utils getLoginToken];
    
}

+ (void)requestContactInfo:(void(^)(NSDictionary *json))callback{
    
    [SCHttpTool postWithURL:HSC_URL_CONTRACTS_LIST params:nil success:^(NSDictionary *json) {
        
        
        if (callback) {
            callback(json);
        }else{
            DCKeyValueObjectMapping *kvom = [DCKeyValueObjectMapping mapperForClass:[HSCContactModel class]];
            NSMutableArray<HSCContactModel*> *searchArray = [NSMutableArray new];
            
            NSMutableArray *allContacts = [NSMutableArray new];
            NSMutableArray *tempArray = [NSMutableArray new];
            
            if ([Utils isValidArray:json[@"teachers"]]) {
                
                tempArray = [kvom parseArray:json[@"teachers"]];
                
                for (HSCContactModel *model in tempArray) {
                    model.contactType = HSCContactTeacher;
                }
                
                [allContacts addObjectsFromArray:tempArray];
                
            }
            
            if ([Utils isValidArray:json[@"parents"]]) {
                
                tempArray = [kvom parseArray:json[@"parents"]];
                
                for (HSCContactModel *model in tempArray) {
                    model.contactType = HSCContactParent;
                }
                
                [allContacts addObjectsFromArray:tempArray];
                
                [SCUserInfo sharedInstance].parentsContacts = [[NSMutableArray alloc]initWithArray:tempArray];
                
            }
            
            if ([Utils isValidArray:json[@"classes"]]) {
                
                tempArray = [kvom parseArray:json[@"classes"]];
                
                for (HSCContactModel *model in tempArray) {
                    model.contactType = HSCContactClass;
                }
                
                [allContacts addObjectsFromArray:tempArray];
                
                [SCUserInfo sharedInstance].classesContacts = [[NSMutableArray alloc]initWithArray:tempArray];
                
            }
            
            if (allContacts.count <= 0) {
                return;
            }
            
            [HSCContactModel clearTable];
            
            [HSCContactModel saveObjects:allContacts];
            
        }
        
    } failure:nil];
}

+ (void) uploadImageWithUrl:(NSString *)url data:(NSData *)data success:(void (^)(id response))success withinView:(UIView *)view progressText:(NSString *)progressText{
    
    [self uploadImageWithUrl:url params:nil data:data fileName:@"avator" success:success withinView:view progressText:progressText];
}

+ (void)requestNewMessage{
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    NSNumber *time = [[SCCache sharedInstance] cachedObjectForKey:@"lastMessageCreateTim"];
    params[@"type"] = @1;
    time = time ? time : nil;
    params[@"createTim"] = [Utils isNonnull:time] ? time : @(0);
    
    
    [self postWithURL:HSC_URL_NOTICE_LIST params:params success:^(NSDictionary *json) {
        
        if ([SCUserInfo sharedInstance].unreadMessageCount == 0) {
            
            NSArray *datas = [HSCMessageModel findByCriteria:[NSString stringWithFormat:@"where isRead = 0"]];
            
            if (datas.count > 0) {
                
                [SCUserInfo sharedInstance].unreadMessage = [[NSMutableArray alloc]initWithArray:datas];
                
            }else{
                
                [SCUserInfo sharedInstance].unreadMessage = [NSMutableArray new];
                
            }
            
            [SCUserInfo sharedInstance].unreadMessageCount += [SCUserInfo sharedInstance].unreadMessage.count;
        }
        
        if ([Utils isValidArray:json[@"data"]]) {
            
            DCKeyValueObjectMapping *KVOMapping = [DCKeyValueObjectMapping mapperForClass:[HSCMessageModel class]];
            
            NSArray<HSCMessageModel*> *dataArray = [KVOMapping parseArray:json[@"data"]];
            NSMutableArray<HSCMessageModel *> *tempSysModels = [NSMutableArray new];
            NSMutableArray<HSCMessageModel *> *tempSNModels = [NSMutableArray new];
            NSMutableArray<HSCMessageModel *> *tempCNModels = [NSMutableArray new];
            NSMutableArray<HSCMessageModel *> *tempCDModels = [NSMutableArray new];
            NSMutableArray<HSCMessageModel *> *tempCWModels = [NSMutableArray new];
            
            [[SCCache sharedInstance] cacheObject:@(dataArray.firstObject.createTim) forKey:@"lastMessageCreateTim"];
            
            for (HSCMessageModel *message in dataArray) {
                if (!message.isRead) {
                    switch (message.type) {
                        case 0:
                            [tempSysModels addObject:message];
                            break;
                        case 1:
                            [tempSNModels addObject:message];
                            break;
                        case 2:
                            [tempCNModels addObject:message];
                            break;
                        case 3:
                            [tempCDModels addObject:message];
                            break;
                        case 4:
                            [tempCWModels addObject:message];
                            break;
                            
                        default:
                            break;
                    }
                }
            }
            
            [HSCMessageModel saveObjects:tempSysModels];
            
            
            if (tempSNModels.count > 0) {
                
                [SCUserInfo sharedInstance].unreadSNCount += tempSNModels.count;
                [tempSNModels addObjectsFromArray:[SCUserInfo sharedInstance].unreadSN];
                [SCUserInfo sharedInstance].unreadSN = [[NSMutableArray alloc]initWithArray:tempSNModels];
                
            }
            
            
            if (tempCNModels.count > 0) {
                
                [SCUserInfo sharedInstance].unreadCNCount += tempCNModels.count;
                [tempCNModels addObjectsFromArray:[SCUserInfo sharedInstance].unreadCN];
                [SCUserInfo sharedInstance].unreadCN = [[NSMutableArray alloc]initWithArray:tempCNModels];
                
            }
            
            if (tempCDModels.count > 0) {
                
                [SCUserInfo sharedInstance].unreadCDCount += tempCDModels.count;
                [tempCDModels addObjectsFromArray:[SCUserInfo sharedInstance].unreadCD];
                [SCUserInfo sharedInstance].unreadCD = [[NSMutableArray alloc]initWithArray:tempCDModels];
                
            }
            
            if (tempCWModels.count > 0) {
                
                [SCUserInfo sharedInstance].unreadCWCount += tempCWModels.count;
                [tempCWModels addObjectsFromArray:[SCUserInfo sharedInstance].unreadCW];
                [SCUserInfo sharedInstance].unreadCW = [[NSMutableArray alloc]initWithArray:tempCWModels];
                
            }
            
            if (tempSysModels.count > 0) {
                
                [SCUserInfo sharedInstance].unreadMessageCount += tempSysModels.count;
                [tempSysModels addObjectsFromArray:[SCUserInfo sharedInstance].unreadMessage];
                [SCUserInfo sharedInstance].unreadMessage = [[NSMutableArray alloc]initWithArray:tempSysModels];
                
            }else{
                
                [SCUserInfo sharedInstance].unreadMessageCount = [SCUserInfo sharedInstance].unreadMessageCount;
                
            }
            
        }else{
            [SCUserInfo sharedInstance].unreadMessageCount = [SCUserInfo sharedInstance].unreadMessageCount;
        }
        
    } failure:^(NSError *error) {
        
        if ([SCUserInfo sharedInstance].unreadMessage == nil) {
            
            NSArray *datas = [HSCMessageModel findByCriteria:[NSString stringWithFormat:@"where isRead = 0"]];
            
            if (datas.count > 0) {
                
                [SCUserInfo sharedInstance].unreadMessage = [[NSMutableArray alloc]initWithArray:datas];
                
            }else{
                
                [SCUserInfo sharedInstance].unreadMessage = [NSMutableArray new];
                
            }
            
            [SCUserInfo sharedInstance].unreadMessageCount += [SCUserInfo sharedInstance].unreadMessage.count;
        }

    }];
}

@end
