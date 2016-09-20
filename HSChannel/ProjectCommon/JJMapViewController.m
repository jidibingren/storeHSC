//
//  JJMapViewController.m
//  JJ56
//
//  Created by SC on 16/8/6.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "JJMapViewController.h"

#ifdef SC_TP_MAMAP
@interface JJMapViewController ()<MAMapViewDelegate>{
    __block MAMapView    *_mapView;
    CLLocationCoordinate2D _coordinate;
}


@end

@implementation JJMapViewController

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate{

    if (self = [super init]) {
        _coordinate = coordinate;
    }
    
    return self;
}

- (void)setupSubviews{
    
    [super setupSubviews];
    
    self.title = @"地图";
    
    [self setupMapView];
}

- (void)setupMapView{
    
    CGRect frame = self.view.frame;
    frame.origin = CGPointZero;
    if (iOS9_OR_LATER){
        frame.size.height = ScreenHeight;
    }else{
        frame.size.height = ScreenHeight - 64;
    }
    _mapView = [[MAMapView alloc]initWithFrame:frame];
    _mapView.mapType = MAMapTypeStandard;
    _mapView.delegate = self;
    _mapView.zoomLevel = 17.0;
    [self.view addSubview:_mapView];
    
    // 定位
    _mapView.showsUserLocation = NO;
    
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    
    _mapView.zoomEnabled = YES;
    
    [_mapView setCenterCoordinate:_coordinate animated:NO];
    
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    annotation.coordinate = _coordinate;
    
    [_mapView addAnnotation:annotation];

}

#pragma mark - MAMapViewDelegate

- (MAAnnotationView*)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        NSString *pointReuseIndentifier =  @"mapPointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.pinColor = MAPinAnnotationColorRed;
        
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    
}

@end
#else
@implementation JJMapViewController

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate{
    
    if (self = [super init]) {
        
    }
    
    return self;
}
@end
#endif
