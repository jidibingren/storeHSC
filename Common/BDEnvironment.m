#import <sys/utsname.h>

#import "BDEnvironment.h"
//#import "DCKeyValueObjectMapping.h"

// NSUserDefaults keys
#define kBaseUrlKey @"kBaseUrlKey"
#define kBaseUrlJAKey @"kBaseUrlJAKey"
#define kCompanyKeyKey @"kCompanyKeyKey"
#define kCustomBillsMIDKey @"kCustomBillsMIDKey"
#define kCustomBillsTIDKey @"kCustomBillsTIDKey"
#define kBaseUrlsKey @"kBaseUrlsKey"
#define kBaseUrlJAsKey @"kBaseUrlJAsKey"
#define kCompanyKeysKey @"kCompanyKeysKey"
#define kCustomBillsMIDsKey @"kCustomBillsMIDsKey"
#define kCustomBillsTIDsKey @"kCustomBillsTIDsKey"

@interface BDEnvironment () {
    NSString* _customBaseUrl;
    NSString* _customBaseUrlJA;
    NSString* _customCompanyKey;
    NSUserDefaults* _userDefaults;
    NSString* _customBillsMID;
    NSString* _customBillsTID;
}
@end

@implementation BDEnvironment
 
+(instancetype)env {
    static BDEnvironment *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BDEnvironment alloc] init];
    });
    return instance;
}
 
-(instancetype)init {
    self = [super init];
    if (self != nil) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
#if SC_OFFLINE
        // 如果是线下,可以设置custom baseUrl/companyKey

        // 不在从环境变量中读取baseUrl/companyKey
        NSDictionary* originalEnv = [[NSProcessInfo processInfo] environment];
        NSMutableDictionary* env = [originalEnv mutableCopy];
        [env removeObjectForKey:@"baseUrl"];
        [env removeObjectForKey:@"companyKey"];
        
        DCKeyValueObjectMapping* parser = [DCKeyValueObjectMapping mapperForClass:self.class];
        [parser updateObject:self withDictionary:env];

//        _customBaseUrl = [_userDefaults stringForKey:kBaseUrlKey];
//        _customBaseUrlJA = [_userDefaults stringForKey:kBaseUrlJAKey];
//        _customCompanyKey = [_userDefaults stringForKey:kCompanyKeyKey];
//        _customBillsMID = [_userDefaults stringForKey:kCustomBillsMIDKey];
//        _customBillsTID = [_userDefaults stringForKey:kCustomBillsTIDKey];
        [self setupCustoms];

#endif
        
        struct utsname systemInfo;
        uname(&systemInfo);
        _deviceType = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
        _systemVersion = [UIDevice currentDevice].systemVersion;
    }
    return self;
}

- (void)setupCustoms{
#if SC_OFFLINE
    _customBaseUrl = [Utils keyChainStringForKey:kBaseUrlKey];
    _customBaseUrlJA = [Utils keyChainStringForKey:kBaseUrlJAKey];
    _customCompanyKey = [Utils keyChainStringForKey:kCompanyKeyKey];
    _customBillsMID = [Utils keyChainStringForKey:kCustomBillsMIDKey];
    _customBillsTID = [Utils keyChainStringForKey:kCustomBillsTIDKey];

    [Utils addObjectToKeyChainArrayByKey:kBaseUrlsKey objects:BASEURL_HTTPS,BASEURL_NO_HTTPS,BASEURL_TEST, nil];
    [Utils addObjectToKeyChainArrayByKey:kBaseUrlJAsKey objects:BASEURL2_HTTPS,BASEURL2_NO_HTTPS,BASEURL2_TEST, nil];
    [Utils addObjectToKeyChainArrayByKey:kCustomBillsMIDsKey objects:DEFAULT_MERORDER_ID,DEFAULT_MERORDER_ID_TEST, nil];
    [Utils addObjectToKeyChainArrayByKey:kCustomBillsTIDsKey objects:DEFAULT_TERMID,DEFAULT_TERMID_TEST,nil];
#endif
}

- (void)reset{
    [Utils removeKeyChainAllItems];
    [self setupCustoms];
}

- (void) serverCompanyKeyChanged {
#if SC_OFFLINE
    [SCHttpTool setLoggedOutStatus];
    [UIAlertView bk_showAlertViewWithTitle:@"你修改了服务器地址或者companyKey,需要重启之后才能生效." message:@"注意:重启后需要重新登陆.\n服务器地址和companyKey的修改会一直生效!" cancelButtonTitle:nil otherButtonTitles:@[@"关闭APP"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        exit(0);
    }];
#endif
}

- (void) setCompanyKey:(NSString *)companyKey {
#if SC_OFFLINE
    _customCompanyKey = companyKey;
    [Utils setKeyChainString:companyKey forKey:kCompanyKeyKey];
//    [self serverCompanyKeyChanged];
#endif
}

- (NSString*) companyKey {
    return [Utils isValidStr:_customCompanyKey] ? _customCompanyKey : DEFAULT_COMPANY_KEY;
}

- (void) setBaseUrl:(NSString *)baseUrl {
#if SC_OFFLINE
    _customBaseUrl = baseUrl;
    [Utils addObjectToKeyChainArrayByKey:kBaseUrlsKey objects:baseUrl, nil];
    [Utils setKeyChainString:baseUrl forKey:kBaseUrlKey];
//    [self serverCompanyKeyChanged];
#endif
}

- (NSString*) baseUrl {
#if SC_OFFLINE
    return [Utils isValidStr:_customBaseUrl] ? _customBaseUrl : BASEURL;
#else
    return BASEURL;
#endif
}

- (NSArray*) baseUrls {
    return [Utils keyChainArrayForKey:kBaseUrlsKey];
}

- (void) setBaseUrlJA:(NSString *)baseUrlJA {
#if SC_OFFLINE
    _customBaseUrlJA = baseUrlJA;
    [Utils addObjectToKeyChainArrayByKey:kBaseUrlJAsKey objects:baseUrlJA, nil];
    [Utils setKeyChainString:baseUrlJA forKey:kBaseUrlJAKey];
    
//    [UIAlertView bk_showAlertViewWithTitle:@"你修改了JA服务器地址,需要重启之后才能生效." message:@"注意:服务器地址和companyKey的修改会一直生效!" cancelButtonTitle:nil otherButtonTitles:@[@"关闭APP"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
//        exit(0);
//    }];
#endif
}

- (NSString*) baseUrlJA {
#if SC_OFFLINE
    return [Utils isValidStr:_customBaseUrlJA] ? _customBaseUrlJA : BASEURL2;
#else
    return BASEURL2;
#endif
}

- (NSArray*) baseUrlJAs {
    return [Utils keyChainArrayForKey:kBaseUrlJAsKey];
}

- (NSString*) replaceUrl: (NSString*)url {
    if ([Utils isValidStr:_customBaseUrl] && ([url containsString:BASEURL]|| [url containsString:BASEURL_HTTPS])) {
        // 这里指定的服务器必须是非线上的, https也变成http
        url = [[url stringByReplacingOccurrencesOfString:BASEURL withString:_customBaseUrl]
                    stringByReplacingOccurrencesOfString:BASEURL_HTTPS withString:_customBaseUrl];
    }
    else if ([Utils isValidStr:_customBaseUrlJA] && ([url containsString:BASEURL2]|| [url containsString:BASEURL2_HTTPS])) {
        // 这里指定的服务器必须是非线上的, https也变成http
        url = [[url stringByReplacingOccurrencesOfString:BASEURL2 withString:_customBaseUrlJA]
               stringByReplacingOccurrencesOfString:BASEURL2_HTTPS withString:_customBaseUrlJA];
    }
    return url;
}

- (BOOL) isOnlineServer {
    return [[self baseUrl] hasSuffix:ONLINE_SERVER];
}

- (NSString*) umengAppKey {
#if SC_OFFLINE && defined(UMENG_APP_KEY_OFFLINE)
    if (!([self isOnlineServer] && [self.companyKey isEqualToString:DEFAULT_COMPANY_KEY])) {
        return UMENG_APP_KEY_OFFLINE;
    }
#endif
    return UMENG_APP_KEY_ONLINE;
}

@end