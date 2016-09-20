//
//  SCPoiSearch.m
//  FindAFitting
//
//  Created by SC on 16/5/10.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "SCPoiSearch.h"

#ifdef SC_TP_BAIDUMAP
@interface SCPoiSearch : BMKPoiSearch
#elif defined SC_TP_MAMAP
@interface SCPoiSearch : AMapPOIAroundSearchRequest
#else
@interface SCPoiSearch : NSObject
#endif

@property (nonatomic, strong) SCPoiSearchBlock callback;

@property (nonatomic, strong) id additionalInfo;

@property (nonatomic, strong) id superObject;

@end

@implementation SCPoiSearch

@end

#ifdef SC_TP_BAIDUMAP
@interface SCPoiSearchUtil ()<BMKPoiSearchDelegate>
#elif defined SC_TP_MAMAP
@interface SCPoiSearchUtil ()<AMapSearchDelegate>
#else
@interface SCPoiSearchUtil ()
#endif

@property (nonatomic, strong)NSMutableArray<SCPoiSearch*>* searcherArray;

@end

@implementation SCPoiSearchUtil

IMPLEMENT_SINGLETON()

-(instancetype) init{
    
    if (self = [super init]) {
        
        self.searcherArray = [NSMutableArray new];
        
    }
    
    return self;
}

- (void)nearbySearchByKeyword:(NSString *)keyword location:(CLLocationCoordinate2D)location callback:(SCPoiSearchBlock)callback{
    
    [self nearbySearchByKeyword:keyword location:location additionalInfo:nil callback:callback];
    
}

- (void)nearbySearchByKeyword:(NSString *)keyword location:(CLLocationCoordinate2D) location additionalInfo:(id)additionalInfo callback:(SCPoiSearchBlock)callback{

    [self nearbySearchByKeyword:keyword location:location radius:2000 additionalInfo:additionalInfo callback:callback];

}

- (void)nearbySearchByKeyword:(NSString *)keyword location:(CLLocationCoordinate2D) location radius:(NSInteger)radius additionalInfo:(id)additionalInfo callback:(SCPoiSearchBlock)callback{
#ifdef SC_TP_BAIDUMAP
    //初始化检索对象
    SCPoiSearch *poisearch = [[SCPoiSearch alloc] init];
    
    poisearch.delegate = self;
    
    poisearch.callback = callback;
    
    poisearch.additionalInfo = additionalInfo;
    
    [self.searcherArray addObject:poisearch];
    
    //发起检索
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    option.pageIndex = 0;
    option.pageCapacity = 10;
    option.location = location;
    option.sortType = BMK_POI_SORT_BY_DISTANCE;
    option.keyword = keyword;
    option.radius = 2000;
    BOOL flag = [poisearch poiSearchNearBy:option];
    
    if(flag){
        NSLog(@"本地云检索发送成功");
    }else{
        NSLog(@"本地云检索发送失败");
        callback(NO, nil, additionalInfo);
    }
#elif defined SC_TP_MAMAP
    //初始化检索对象
    AMapSearchAPI *poisearch = [[AMapSearchAPI alloc] init];
    poisearch.delegate = self;
    
    //构造AMapPOIAroundSearchRequest对象，设置周边请求参数
    SCPoiSearch *request = [[SCPoiSearch alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:location.latitude longitude:location.longitude];
    request.radius = radius;
    request.keywords = keyword;
    // types属性表示限定搜索POI的类别，默认为：餐饮服务|商务住宅|生活服务
    // POI的类型共分为20种大类别，分别为：
    // 汽车服务|汽车销售|汽车维修|摩托车服务|餐饮服务|购物服务|生活服务|体育休闲服务|
    // 医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|
    // 交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施
    request.types = @"地名地址信息";
    request.sortrule = 0;
    request.requireExtension = YES;
    
    request.callback = callback;
    
    request.superObject = poisearch;
    
    request.additionalInfo = additionalInfo;
    
    [self.searcherArray addObject:request];
    
    //发起周边搜索
    [poisearch AMapPOIAroundSearch: request];
#endif
    
}

- (void)removeSearcherFromArray:(SCPoiSearch *)searcher{
    
    searcher.callback = nil;
    
    searcher.additionalInfo = nil;
    
    [self.searcherArray removeObject:searcher];
}
#ifdef SC_TP_BAIDUMAP
#pragma mark - BMKPoiSearchDelegate

- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        NSMutableArray *poiAddressInfoList = [NSMutableArray new];
        for (int i = 0; i < poiResultList.poiInfoList.count; i++)
        {
            BMKPoiInfo* poi = [poiResultList.poiInfoList objectAtIndex:i];
            SCAddress *address = [SCAddress new];
            address.address = poi.address;
            address.pt = poi.pt;
            address.name = poi.name;
            
            if ([Utils isValidStr:address.address] && [Utils isValidStr:address.name])
                [poiAddressInfoList addObject:address];
        }
        
        SCPoiSearch *poiSearher = (SCPoiSearch*)searcher;
        if (poiSearher.callback) {
            
            poiSearher.callback(YES, poiAddressInfoList, poiSearher.additionalInfo);
            
            [self removeSearcherFromArray:poiSearher];
        }
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
    } else {
        NSLog(@"抱歉，未找到结果");
    }
}
#elif defined SC_TP_MAMAP
#pragma mark - AMapSearchDelegate
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{
    
    SCPoiSearch *poiSearher = (SCPoiSearch*)request;
    if (poiSearher.callback) {
        
        poiSearher.callback(NO, [NSMutableArray new], poiSearher.additionalInfo);
        
        [self removeSearcherFromArray:poiSearher];
    }
    
}
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response{
    
    if(response.pois.count == 0)
    {
        SCPoiSearch *poiSearher = (SCPoiSearch*)request;
        if (poiSearher.callback) {
            
            poiSearher.callback(NO, [NSMutableArray new], poiSearher.additionalInfo);
            
            [self removeSearcherFromArray:poiSearher];
        }
        return;
    }
    
    //通过 AMapPOISearchResponse 对象处理搜索结果
    
    NSMutableArray *poiAddressInfoList = [NSMutableArray new];
    
    for (AMapPOI *poi in response.pois) {
//        BMKPoiInfo* poi = [poiResultList.poiInfoList objectAtIndex:i];
        SCAddress *address = [SCAddress new];
        address.address = poi.address;
        address.pt = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
        address.name = poi.name;
        
        if ([Utils isValidStr:address.address] && [Utils isValidStr:address.name])
            [poiAddressInfoList addObject:address];
    }
    
    SCPoiSearch *poiSearher = (SCPoiSearch*)request;
    if (poiSearher.callback) {
        
        poiSearher.callback(YES, poiAddressInfoList, poiSearher.additionalInfo);
        
        [self removeSearcherFromArray:poiSearher];
    }
}
#endif
@end
