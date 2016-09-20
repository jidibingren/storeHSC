//
//  SCUserInfo.m
//  FindAFitting
//
//  Created by SC on 16/5/8.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "SCUserInfo.h"


#define JJ_AUTO_REFRESH_KEY  @"JJ_AUTO_REFRESH_KEY"
#define JJ_AUDIO_ENABLE_KEY  @"JJ_AUDIO_ENABLE_KEY"
#define JJ_CARGO_MODE_KEY    @"JJ_GARGO_MODE_KEY"

#define JJ_ORIGIN_ADDRESS_ARRAY_KEY  @"JJ_ORIGIN_ADDRESS_ARRAY_KEY"
#define JJ_DEST_ADDRESS_ARRAY_KEY    @"JJ_DEST_ADDRESS_ARRAY_KEY"


@implementation SCUserInfo

IMPLEMENT_SINGLETON()

-(instancetype) init{
    
    if (self = [super init]) {
        
        SCCache *cache = [SCCache sharedInstance];
        self.curType = [[SCCache sharedInstance] cachedObjectForKey:@"SCRootControllerType"] ? [[[SCCache sharedInstance] cachedObjectForKey:@"SCRootControllerType"] integerValue] : 0;
        
        _autoRefresh = [cache cachedObjectForKey:JJ_AUTO_REFRESH_KEY];
        
        if (!_autoRefresh) {
            self.autoRefresh = [NSNumber numberWithBool:YES];
        }
        
        _audioEable = [cache cachedObjectForKey:JJ_AUDIO_ENABLE_KEY];
        
        if (!_audioEable) {
            self.audioEable = [NSNumber numberWithBool:YES];
        }
        
        _unreadMessage = [NSMutableArray new];
        _unreadSN = [NSMutableArray new];
        _unreadCN = [NSMutableArray new];
        _unreadCD = [NSMutableArray new];
        _unreadCW = [NSMutableArray new];
        
        [[SCLocationAdapter sharedInstance] getLocationOnceWithCallback:^(NSError *e) {
            ;
        }];
        
        DEFINE_WEAK(self);
        
        [HSCRecentContactModel findAllAsync:^(NSArray *models) {
            
            if (models.count > 0) {
                
                wself.recentContacts = [[NSMutableArray alloc]initWithArray:models];
                
            }
        }];
        
        [HSCContactModel findByCriteriaAsync:@"where contactType = 1" callback:^(NSArray *models) {
            
            if (models.count > 0) {
                
                wself.parentsContacts = [[NSMutableArray alloc]initWithArray:models];
                
            }
        }];
        
        [HSCContactModel findByCriteriaAsync:@"where contactType = 2" callback:^(NSArray *models) {
            
            if (models.count > 0) {
                
                wself.classesContacts = [[NSMutableArray alloc]initWithArray:models];
                
            }
            
        }];
    }
    
    return self;
}

-(void)setAutoRefresh:(NSNumber *)autoRefresh{
    
    _autoRefresh = autoRefresh;
    
    [[SCCache sharedInstance] cacheObject:autoRefresh forKey:JJ_AUTO_REFRESH_KEY];
    
}

-(void)setAudioEable:(NSNumber *)audioEable{
    
    _audioEable = audioEable;
    
    [[SCCache sharedInstance] cacheObject:audioEable forKey:JJ_AUDIO_ENABLE_KEY];
    
}

@end


@implementation SCChildInfo

@end
