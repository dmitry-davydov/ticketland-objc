//
//  MapViewController.m
//  TicketLand
//
//  Created by Дима Давыдов on 28.05.2021.
//

#import "MapViewController.h"
#import "GeoService.h"
#import <MapKit/MapKit.h>
#import "DataManager.h"
#import "PointAnnotation.h"
#import "DatabaseService.h"

#define mapViewAnnotationReuseIdentifier @"mapViewReuseIdenitfier"

@interface MapViewController () <MKMapViewDelegate>
@property (nonnull, strong) MKMapView *mapView;
@property (nonatomic, strong) NSArray<Price *> *prices;
@property CLLocationCoordinate2D selectedCoordinates;

@end

@implementation MapViewController {
    BOOL isFavorites;
}

- (instancetype)initWithFavorites {
    self = [super init];
    if (self) {
        isFavorites = YES;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
    
    [GeoService sharedInstance];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cityDidUpdated:) name:kGeoServiceDidUpdatedCity object:nil];
}

- (void)cityDidUpdated:(NSNotification *)notification {
    CLPlacemark *placemark = notification.object;
    NSLog(@"City: %@", placemark.locality);
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(placemark.location.coordinate, 10000, 10000);
    [_mapView setRegion:region];
    _mapView.showsUserLocation = YES;
    
    City *origin = [[DataManager sharedInstance] cityForLocation:placemark.location];
    if (!origin) { return ; }
    
    [[DataManager sharedInstance] mapPricesFor:origin withCompletion:^(NSArray *prices) {
        self.prices = prices;
    }];
}

- (void)setPrices:(NSArray *)prices {
    _prices = prices;
    [_mapView removeAnnotations: _mapView.annotations];
    
    for (Price *price in prices) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            annotation.title = [NSString stringWithFormat:@"%@ (%@)", price.destination.name, price.destination.code];
            annotation.subtitle = [NSString stringWithFormat:@"%ld руб.", (long)price.value];
            annotation.coordinate = price.destination.coordinate;
            
            [self->_mapView addAnnotation: annotation];
        });
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!isFavorites) {
        return ;
    }
    
    NSArray *cities = [[DatabaseService sharedInstance] favoritesCities];
    if (![cities count]) {
        return ;
    }
    
    for (FavoriteCity *city in cities) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            annotation.coordinate = CLLocationCoordinate2DMake(city.lat, city.lon);
            
            [self->_mapView addAnnotation: annotation];
        });
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)configureView {
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    _mapView.delegate = self;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(0, 0), 10000000, 10000000);
    [_mapView setRegion:region];
    [self.view addSubview:self.mapView];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKMarkerAnnotationView *annotationView = (MKMarkerAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:mapViewAnnotationReuseIdentifier];
    
    if (!annotationView) {
        annotationView = [[MKMarkerAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:mapViewAnnotationReuseIdentifier];
        annotationView.canShowCallout = YES;
        annotationView.calloutOffset = CGPointMake(-1.0, 0);
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
        [button addTarget:self action:@selector(toggleFavorite:) forControlEvents:UIControlEventTouchUpInside];
        
        annotationView.rightCalloutAccessoryView = button;
    }
    
    annotationView.annotation = annotation;
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    _selectedCoordinates = view.annotation.coordinate;
}
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    _selectedCoordinates = CLLocationCoordinate2DMake(0, 0);
}

- (void)toggleFavorite:(id)sender {
    FavoriteCity *model = [[DatabaseService sharedInstance]findFavoriteCity:(_selectedCoordinates)];
    if (model) {
        // remove from favorites cities
        [[DatabaseService sharedInstance] removeFavoriteCity:model];
    } else {
        // add to favorites cities
        [[DatabaseService sharedInstance] addFavoriteCity:_selectedCoordinates];
    }
}

@end
