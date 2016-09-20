
@interface SCLocationAdapter () <CLLocationManagerDelegate> {
    CLLocationManager* _clLocationManager;
    NSMutableArray* _callbacks;
}
@property (nonatomic, strong) CLLocation* clLocation;
@end

@implementation SCLocationAdapter

IMPLEMENT_SINGLETON()

- (instancetype) init {
    self = [super init];
    _baiduLocation = DEFAULT_LOCATION;
    NSUserDefaults *usersDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *arr = [usersDefaults objectForKey:@"lastBaiduLocation"];
    if (arr) {
        _baiduLocation = CLLocationCoordinate2DMake([arr[0] floatValue], [arr[1] floatValue]);
    }
    _callbacks = [[NSMutableArray alloc]init];
    return self;
}

- (void) getLocationWithCallback: (SCLocationCallback)cb {
    
    if ([self isUserOpeningLocation]) {
        [_callbacks addObject:cb];
    }else {
        if (self.hasGotLocation == YES){
            cb(nil);
        }
    }
    
    if (!_clLocationManager) {
        _clLocationManager = [[CLLocationManager alloc]init];
        // 移动一千米才需要更新位置
        _clLocationManager.distanceFilter = 0.0;
        _clLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _clLocationManager.pausesLocationUpdatesAutomatically = YES;
        _clLocationManager.delegate = self;
        
        if (iOS8_OR_LATER) {
            [_clLocationManager requestAlwaysAuthorization];
        }

        [_clLocationManager startUpdatingLocation];
    }
}

- (void) getLocationOnceWithCallback: (SCLocationCallback) cb {
    __weak SCLocationAdapter* wself = self;
    __block SCLocationCallback cbWrapper;
    __block __weak SCLocationCallback weakCbWrapper;

    weakCbWrapper = cbWrapper = ^(NSError* error) {
        void (^callbackSelf)(NSError* error) = weakCbWrapper; // 先引用callback本身，防止被释放然后cb无效了
        [wself removeCallback:weakCbWrapper];
        cb(error);
        callbackSelf = nil;
    };
    self.administrativeArea ? cb(nil) : [self getLocationWithCallback:cbWrapper];
}

- (void) removeCallback: (SCLocationCallback) cb {
    [_callbacks removeObject:cb];
}

// CLLocationManagerDelegate implementation
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if (!locations || [locations count] <= 0) {
        NSAssert(0, @"No location got in didUpdateLocations");
        return;
    }
    self.hasGotLocation = YES;
    self.clLocation = locations.lastObject;
    self.location = self.clLocation.coordinate;
#ifdef SC_TP_BAIDUMAP
    NSDictionary* c = BMKConvertBaiduCoorFrom(self.clLocation.coordinate, BMK_COORDTYPE_GPS);
    self.baiduLocation = BMKCoorDictionaryDecode(c);
#elif defined SC_TP_MAMAP
    self.baiduLocation = MACoordinateConvert(self.clLocation.coordinate, MACoordinateTypeGPS);
#else
    self.baiduLocation = self.location;
#endif
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@[@(self.baiduLocation.latitude), @(self.baiduLocation.longitude)] forKey: @"lastBaiduLocation"];

    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation: _clLocation completionHandler:^(NSArray *array, NSError *error) {
        if (array.count > 0) {
            CLPlacemark *placemark = [array objectAtIndex:0];
            if (placemark)
            {
                self.administrativeArea = placemark.administrativeArea;
                NSString *city = placemark.administrativeArea;//省
                NSDictionary *dict= placemark.addressDictionary;
                city=[dict valueForKey:@"City"];//市
                NSLog(@"city -> %@",city);
                NSString *currentLocation=[NSString stringWithFormat:@"%@,%@",[placemark.administrativeArea stringByReplacingOccurrencesOfString:@"省" withString:@""],[city stringByReplacingOccurrencesOfString:@"市" withString:@""]];
                JYAccount *account=[JYAccountTool account];
                if (account==nil) {
                    account=[JYAccount new];
                }
                account.currentLocation=currentLocation;
                [JYAccountTool saveAccount:account];
                self.currentLocality = placemark.locality;
                self.currentLocationCity = city;
                self.currentSubLocality = placemark.subLocality;
                self.currentSubAdministrativeArea = placemark.subAdministrativeArea;
            }
        }
        for (SCLocationCallback cb in _callbacks.mutableCopy) {
            cb(nil);
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
}

- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error
{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        return;
    }
    for (SCLocationCallback cb in _callbacks.mutableCopy) {
        cb(error);
    }
}

- (BOOL)isUserOpeningLocation
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (![CLLocationManager locationServicesEnabled] || kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status || kCLAuthorizationStatusNotDetermined == status) {
        return NO;
    } else {
        return YES;
    }
}

- (void)dealloc{
    
    [_clLocationManager stopUpdatingLocation];
    [_callbacks removeAllObjects];
    _clLocationManager = nil;
    
}

@end