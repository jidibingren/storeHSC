//
//  SCCache.m
//  JJ56
//
//  Created by SC on 16/5/23.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "SCCache.h"

@interface SCCache ()

@property (nonatomic, strong)YYCache *baseCache;
@property (nonatomic, strong)YYCache *cargoCache;
@property (nonatomic, strong)YYCache *globalVarCache;
@property (nonatomic, strong)YYCache *zoneListCache;
@property (nonatomic, strong)YYCache *dictListCache;
@property (nonatomic, strong)YYMemoryCache *cargoMemoryCache;
@property (nonatomic, strong)YYCache *carsCache;
@property (nonatomic, strong)YYMemoryCache *carsMemoryCache;

@end

@implementation SCCache

IMPLEMENT_SINGLETON()

- (instancetype)init{
    
    if (self = [super init]){
        
        self.baseCache     = [YYCache cacheWithName:@"JJBaseCache"];
        
        self.cargoCache     = [YYCache cacheWithName:@"JJAllGoodsCache"];
        
        self.globalVarCache = [YYCache cacheWithName:@"JJGlobalVarCache"];
        
        self.zoneListCache  = [YYCache cacheWithName:@"JJZoneListCache"];
        
        self.dictListCache  = [YYCache cacheWithName:@"JJDictListCache"];
        
        self.cargoMemoryCache = [[YYMemoryCache alloc]init];
        
        self.cargoMemoryCache.name = @"JJCargoMemoryCache";
        
        self.carsCache     = [YYCache cacheWithName:@"JJCarsCache"];
        
        self.carsMemoryCache = [[YYMemoryCache alloc]init];
        
        self.carsMemoryCache.name = @"JJCarsMemoryCache";
        
    }
    
    return self;
}

// base cache

- (void)cacheObject:(id)object forKey:(NSString *)key{
    
    [self.baseCache setObject:object forKey:key];
    
}

- (id) cachedObjectForKey:(NSString *)key{
    
    return [self.baseCache objectForKey:key];
    
}

// zone list info

- (void)cacheZoneListInfo:(NSDictionary *)dict{
    
    [self.zoneListCache setObject:dict[@"cityDocVersion"] forKey:@"cityDocVersion"];
    
    [self.zoneListCache setObject:dict[@"data"] forKey:@"zoneList"];
    
}

- (long)zoneListVersion{
    
    NSNumber *tempDict = (NSNumber*)[self.zoneListCache objectForKey:@"cityDocVersion"];
    
    return tempDict.longValue;
    
}

- (NSArray*)zoneList{
    
    NSArray *tempDict = (NSArray*)[self.zoneListCache objectForKey:@"zoneList"];
    
    return [Utils isValidArray:tempDict] ? tempDict : [NSArray new];
    
}

// global var info
- (void)cacheGlobalVar:(NSDictionary *)dict{
    
    [self.globalVarCache setObject:dict forKey:@"globalVarCache"];
    
}


- (long)globalVarUseCode{
    
    NSDictionary *tempDict = (NSDictionary*)[self.globalVarCache objectForKey:@"globalVarCache"];
    
    return [Utils isValidDictionary:tempDict] ? [(NSNumber*)[tempDict objectForKey:@"useCode"] longValue] : -1;
    
}

- (long)globalVarZoneListVersion{
    
    
    NSDictionary *tempDict = (NSDictionary*)[self.globalVarCache objectForKey:@"globalVarCache"];
    
    return [Utils isValidDictionary:tempDict] ? [(NSNumber*)[tempDict objectForKey:@"cityDocVersion"] longValue] : -1;
    
}

- (long)globalVarCargoTypeListVersion{
    
    
    return [self globalVarVersionByType:@"CAEGOTYPE"];
    
}

- (long)globalVarCarTypeListVersion{
    
    
    return [self globalVarVersionByType:@"CARTYPE"];
    
}

- (long)globalVarCarLenListVersion{
    
    
    return [self globalVarVersionByType:@"CARLEN"];
    
}

- (NSArray*)globalVars{
    
    
    NSDictionary *tempDict = (NSDictionary*)[self.globalVarCache objectForKey:@"globalVarCache"];
    
    return [Utils isValidDictionary:tempDict] ? (NSArray*)[tempDict objectForKey:@"dictVersion"] : [NSArray new];
    
}

- (NSDictionary *)globalVarByType:(NSString *)type{
    
    NSDictionary *tempInfo = [NSDictionary new];
    
    for (NSDictionary *globalVarInfo in [self globalVars]) {
        
        //        if ([globalVarInfo[@"dictType"] isEqualToString:type]) {
        
        if ([globalVarInfo.allKeys[0] isEqualToString:type]) {
            
            tempInfo = globalVarInfo;
            
            break;
            
        }
    }
    
    return tempInfo;
    
}

- (long)globalVarVersionByType:(NSString*)type{
    
    NSDictionary *tempInfo = [self globalVarByType:type];
    
    //    return [Utils isValidDictionary:tempInfo] ? [(NSNumber *)(tempInfo[@"version"]) longValue] : -1;
    
    return [Utils isValidDictionary:tempInfo] ? [(NSNumber *)(tempInfo.allValues[0]) longValue] : -1;
    
}

// dict list info


- (void)cacheCarTypeDictList:(NSDictionary *)dict{
    
    [self cacheDictList:dict type:@"CARTYPE"];
}

- (void)cacheCarLenDictList:(NSDictionary *)dict{
    
    [self cacheDictList:dict type:@"CARLEN"];
}


- (void)cacheCargoTypeDictList:(NSDictionary *)dict{
    
    [self cacheDictList:dict type:@"CAEGOTYPE"];
}

- (void)cacheCarUnitTypeDictList:(NSDictionary *)dict{
    
    [self cacheDictList:dict type:@"CARUnit"];
}

- (long)carTypeDictListVersion{
    
    return [self dictListVersionByType:@"CARTYPE"];
}

- (long)carLenDictListVersion{
    
    return [self dictListVersionByType:@"CARLEN"];
}


- (long)cargoTypeDictListVersion{
    
    return [self dictListVersionByType:@"CAEGOTYPE"];
}

- (long)carUnitTypeDictListVersion{
    
    return [self dictListVersionByType:@"CARUnit"];
}

- (void)cacheDictList:(NSDictionary*)dict type:(NSString*)type{
    
    [self.dictListCache setObject:dict forKey:type];
    
}


- (long)dictListVersionByType:(NSString*)type{
    
    NSDictionary *tempDict = (NSDictionary*)[self.dictListCache objectForKey:type];
    
    return [Utils isValidDictionary:tempDict] ? [(NSNumber*)[tempDict objectForKey:@"version"] longValue] : -1;
    
}

- (NSArray*)carTypeDictList{
    
    return [self dictListByType:@"CARTYPE"];
    
}

- (NSArray*)carLenDictList{
    
    return [self dictListByType:@"CARLEN"];
    
}


- (NSArray*)cargoTypeDictList{
    
    
    return [self dictListByType:@"CAEGOTYPE"];
    
}

- (NSArray*)carUnitTypeDictList{
    
    
    return [self dictListByType:@"CARUnit"];
    
}

- (NSArray*)dictListByType:(NSString *)type{
    
    NSDictionary *tempDict = (NSDictionary*)[self.dictListCache objectForKey:type];
    
    return [Utils isValidDictionary:tempDict] ? [tempDict objectForKey:@"data"] : [NSArray new];
    
}


// cargo list

- (void)cacheCargoInfo:(NSDictionary *)dict{
    
    //    [self.cargoCache setObject:dict forKey:[NSString stringWithFormat:@"%ld", [(NSNumber *)dict[@"id"] longValue]]];
    
    [self.cargoCache setObject:dict forKey:dict[@"id"]];
    
}

- (NSDictionary *)cargoInfoForId:(NSString*)cargoId{
    
    NSDictionary *tempDict = (NSDictionary*)[self.cargoCache objectForKey:cargoId];
    
    return [Utils isValidDictionary:tempDict] ? tempDict : [NSDictionary new];
    
}

- (BOOL)containsCargoInfoForId:(NSString*)cargoId{
    
    return [self.cargoCache containsObjectForKey:cargoId];
    
}

// showed cargo list

- (void)cacheShowedCargoInfo:(NSDictionary *)dict{
    
    //    [self.cargoCache setObject:dict forKey:[NSString stringWithFormat:@"%ld", [(NSNumber *)dict[@"id"] longValue]]];
    
    [self.cargoMemoryCache setObject:dict forKey:dict[@"id"]];
    
}

- (NSDictionary *)showedCargoInfoForId:(NSString*)cargoId{
    
    NSDictionary *tempDict = (NSDictionary*)[self.cargoMemoryCache objectForKey:cargoId];
    
    return [Utils isValidDictionary:tempDict] ? tempDict : [NSDictionary new];
    
}

- (BOOL)containsShowedCargoInfoForId:(NSString*)cargoId{
    
    return [self.cargoMemoryCache containsObjectForKey:cargoId];
    
}

- (void)removeAllShowedCargoInfo{
    
    [self.cargoMemoryCache removeAllObjects];
    
}

// cars list

- (void)cacheCarInfo:(NSDictionary *)dict{
    
    //    [self.cargoCache setObject:dict forKey:[NSString stringWithFormat:@"%ld", [(NSNumber *)dict[@"id"] longValue]]];
    
    [self.carsCache setObject:dict forKey:dict[@"id"]];
    
}

- (NSDictionary *)carInfoForId:(NSString*)carId{
    
    NSDictionary *tempDict = (NSDictionary*)[self.carsCache objectForKey:carId];
    
    return [Utils isValidDictionary:tempDict] ? tempDict : [NSDictionary new];
    
}

- (BOOL)containsCarInfoForId:(NSString*)carId{
    
    return [self.carsCache containsObjectForKey:carId];
    
}

// showed cars list

- (void)cacheShowedCarInfo:(NSDictionary *)dict{
    
    //    [self.cargoCache setObject:dict forKey:[NSString stringWithFormat:@"%ld", [(NSNumber *)dict[@"id"] longValue]]];
    
    [self.carsMemoryCache setObject:dict forKey:dict[@"id"]];
    
}

- (NSDictionary *)showedCarInfoForId:(NSString*)carId{
    
    NSDictionary *tempDict = (NSDictionary*)[self.carsMemoryCache objectForKey:carId];
    
    return [Utils isValidDictionary:tempDict] ? tempDict : [NSDictionary new];
    
}

- (BOOL)containsShowedCarInfoForId:(NSString*)carId{
    
    return [self.carsMemoryCache containsObjectForKey:carId];
    
}

- (void)removeAllShowedCarInfo{
    
    [self.carsMemoryCache removeAllObjects];
    
}

@end
