//
//  MapViewController.m
//  TicketLand
//
//  Created by Дима Давыдов on 28.05.2021.
//

#import "MapViewController.h"
#import "GeoService.h"
#import <MapKit/MapKit.h>

#define mapViewAnnotationReuseIdentifier @"mapViewReuseIdenitfier"

@interface MapViewController () <MKMapViewDelegate>
@property (nonnull, strong) MKMapView *mapView;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
    [self addAnnotation];
    
    [GeoService sharedInstance];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cityDidUpdated:) name:kGeoServiceDidUpdatedCity object:nil];
}

- (void)cityDidUpdated:(NSNotification *)notification {
    CLPlacemark *placemark = notification.object;
    NSLog(@"City: %@", placemark.locality);
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(placemark.location.coordinate, 10000, 10000);
    [_mapView setRegion:region];
    _mapView.showsUserLocation = YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)configureView {
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    _mapView.delegate = self;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(0, 0), 10000000, 10000000);
    [_mapView setRegion:region];
    [self.view addSubview:self.mapView];
}

- (void)addAnnotation {
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.title = @"Test title annotation";
    annotation.subtitle = @"Test description of annotation";
    annotation.coordinate = CLLocationCoordinate2DMake(37.802087, -122.397063);
    [_mapView addAnnotation:annotation];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKMarkerAnnotationView *annotationView = (MKMarkerAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:mapViewAnnotationReuseIdentifier];
    if (!annotationView) {
        annotationView = [[MKMarkerAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:mapViewAnnotationReuseIdentifier];
        annotationView.canShowCallout = YES;
        annotationView.calloutOffset = CGPointMake(-1.0, 0);
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    
    annotationView.annotation = annotation;
    return annotationView;
}

@end
