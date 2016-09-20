
// 包装了一些环境变量，从NSProcessInfo中拿到的环境，只在模拟上有值，值要在scheme中设置
@interface BDEnvironment : NSObject

@property (nonatomic, strong, readonly) NSString *loginUser;
@property (nonatomic, strong, readonly) NSString *loginPassword;
@property (nonatomic, strong) NSString *baseUrl;
@property (nonatomic, strong) NSString *baseUrlJA;
@property (nonatomic, strong) NSString *companyKey;
@property (nonatomic, readonly) BOOL skipLogin;
@property (nonatomic, strong, readonly) NSString *deviceType;
@property (nonatomic, strong, readonly) NSString *systemVersion;
@property (nonatomic, strong) NSString *billsMID;
@property (nonatomic, strong) NSString *billsTID;
 
/**
 * Singleton instance for accessing environment-specific values
 */
+(instancetype)env;

- (NSString*) replaceUrl: (NSString*)url;

- (NSString*) umengAppKey;

- (NSArray*) baseUrls;

- (NSArray*) baseUrlJAs;

- (NSArray*) billsMIDs;

- (NSArray*) billsTIDs;

- (void)reset;
@end
