
#import <CoreLocation/CoreLocation.h>

// 对CLLocationManager的简单包装，同时支持baidu的位置格式
typedef void(^SCLocationCallback)(NSError* e);
@interface SCLocationAdapter: NSObject

@property BOOL hasGotLocation;
@property (nonatomic) CLLocationCoordinate2D baiduLocation;
@property (nonatomic) CLLocationCoordinate2D location;
@property (nonatomic, strong) NSString *administrativeArea;

/**
 *  当前城市
 */
STD_PROP NSString *currentLocationCity;
/**
 *  当前省
 */
STD_PROP NSString *currentLocality;
/**
 *  区  区 县二选一
 */
STD_PROP NSString *currentSubLocality;
/**
 *  县 县 区二选一
 */
STD_PROP NSString *currentSubAdministrativeArea;

DECLARE_SINGLETON();

- (void) getLocationWithCallback: (SCLocationCallback)cb;
- (void) getLocationOnceWithCallback: (SCLocationCallback) cb ;
- (void) removeCallback: (SCLocationCallback) cb;

// 判断设备是否开启定位
- (BOOL)isUserOpeningLocation;
@end