//
//  GeoService.m
//  TicketLand
//
//  Created by Дима Давыдов on 28.05.2021.
//

#import <UIKit/UIKit.h>
#import "GeoService.h"
#import <MapKit/MapKit.h>

@interface GeoService () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, nullable) CLLocation *lastLocation;
@property (nonatomic, strong) CLPlacemark *currentLocationPlacemark;
@end

@implementation GeoService
+ (instancetype)sharedInstance {
    static GeoService *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[GeoService alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        // запросить доступ на карту
        [self configure];
    }
    return self;
}

- (void)configure {
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    [_locationManager requestAlwaysAuthorization];
}

- (void)locationManagerDidChangeAuthorization:(CLLocationManager *)manager  {
    if (manager.authorizationStatus == kCLAuthorizationStatusAuthorizedAlways || manager.authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [_locationManager startUpdatingLocation];
    } else if (manager.authorizationStatus != kCLAuthorizationStatusNotDetermined) {
        NSLog(@"StatusNotDetermined");
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = [locations firstObject];
    if (location) {
        _lastLocation = location;
        NSLog(@"%@", location);
        
        [self cityFromLocation:location];
        [_locationManager stopUpdatingLocation];
    }
}

- (void)cityFromLocation:(CLLocation *)location {
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placemark = [placemarks firstObject];
        [[NSNotificationCenter defaultCenter] postNotificationName:kGeoServiceDidUpdatedCity object:placemark];
    }];
}

@end
