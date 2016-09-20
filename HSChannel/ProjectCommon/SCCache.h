//
//  SCCache.h
//  JJ56
//
//  Created by SC on 16/5/23.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCCache : NSObject

DECLARE_SINGLETON()

- (void)cacheObject:(id)object forKey:(NSString *)key;

- (id) cachedObjectForKey:(NSString *)key;


- (void)cacheZoneListInfo:(NSDictionary *)dict;

- (long)zoneListVersion;

- (NSArray*)zoneList;



- (void)cacheGlobalVar:(NSDictionary *)dict;

- (long)globalVarUseCode;

- (long)globalVarZoneListVersion;

- (NSArray*)globalVars;

- (NSDictionary *)globalVarByType:(NSString *)type;

- (long)globalVarCarLenListVersion;

- (long)globalVarCarTypeListVersion;

- (long)globalVarCargoTypeListVersion;

- (long)globalVarVersionByType:(NSString*)type;




- (void)cacheCarTypeDictList:(NSDictionary *)dict;

- (void)cacheCarLenDictList:(NSDictionary *)dict;

- (void)cacheCargoTypeDictList:(NSDictionary *)dict;

- (void)cacheCarUnitTypeDictList:(NSDictionary *)dict;

- (long)carTypeDictListVersion;

- (long)carLenDictListVersion;

- (long)cargoTypeDictListVersion;

- (long)carUnitTypeDictListVersion;

- (void)cacheDictList:(NSDictionary*)dict type:(NSString*)type;

- (long)dictListVersionByType:(NSString*)type;

- (NSArray*)dictListByType:(NSString *)type;

- (NSArray*)carTypeDictList;

- (NSArray*)carLenDictList;

- (NSArray*)cargoTypeDictList;

- (NSArray*)carUnitTypeDictList;



- (void)cacheCargoInfo:(NSDictionary *)dict;

- (NSDictionary *)cargoInfoForId:(NSString*)cargoId;

- (BOOL)containsCargoInfoForId:(NSString*)cargoId;

- (void)cacheShowedCargoInfo:(NSDictionary *)dict;

- (NSDictionary *)showedCargoInfoForId:(NSString*)cargoId;

- (BOOL)containsShowedCargoInfoForId:(NSString*)cargoId;

- (void)removeAllShowedCargoInfo;

- (void)cacheCarInfo:(NSDictionary *)dict;

- (NSDictionary *)carInfoForId:(NSString*)carId;

- (BOOL)containsCarInfoForId:(NSString*)carId;

- (void)cacheShowedCarInfo:(NSDictionary *)dict;

- (NSDictionary *)showedCarInfoForId:(NSString*)carId;

- (BOOL)containsShowedCarInfoForId:(NSString*)carId;

- (void)removeAllShowedCarInfo;

@end
