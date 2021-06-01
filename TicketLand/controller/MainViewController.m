//
//  MainViewController.m
//  TicketLand
//
//  Created by Дима Давыдов on 15.05.2021.
//

#import "MainViewController.h"
#import "PlaceViewController.h"

typedef struct SearchRequest {
    __unsafe_unretained NSString *origin;
    __unsafe_unretained NSString *destionation;
    __unsafe_unretained NSDate *departDate;
    __unsafe_unretained NSDate *returnDate;
} SearchRequest;

@interface MainViewController () <PlaceViewControllerDelegate>
@property (nonatomic, strong) UIButton *departureButton;
@property (nonatomic, strong) UIButton *arrivalButton;
@property (nonatomic) SearchRequest searchRequest;
@end


@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[DataManager sharedInstance] loadData];

    self.navigationController.navigationBar.prefersLargeTitles = YES;
    self.title = @"Search";
    self.view.backgroundColor = [UIColor whiteColor];

    [self configureDepartureButton];
    [self configureArrivalButton];

}

- (void) configureDepartureButton{
    _departureButton = [UIButton buttonWithType: UIButtonTypeSystem];
    [_departureButton setTitle:@"Departure" forState:UIControlStateNormal];
    _departureButton.tintColor = [UIColor blackColor];
    _departureButton.frame = CGRectMake(30.0, 140.0, [UIScreen mainScreen].bounds.size.width - 60.0, 60.0);
    [_departureButton addTarget:self action:@selector(departureButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_departureButton];
}

- (void) configureArrivalButton{
    _arrivalButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_arrivalButton setTitle:@"Arrival" forState: UIControlStateNormal];
    _arrivalButton.tintColor = [UIColor blackColor];
    _arrivalButton.frame = CGRectMake(30.0, CGRectGetMaxY(_departureButton.frame) + 20.0, [UIScreen mainScreen].bounds.size.width - 60.0, 60.0);
    _arrivalButton.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    [_arrivalButton addTarget:self action:@selector(arrivalButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_arrivalButton];
    
}

- (void) departureButtonDidTap:(UIButton *)sender{
    PlaceViewController *placeViewController;
    placeViewController = [[PlaceViewController alloc] initWithType: PlaceDeparture];
    placeViewController.delegate = self;
    [self.navigationController pushViewController: placeViewController animated:YES];
}

- (void) arrivalButtonDidTap:(UIButton *)sender{
    PlaceViewController *placeViewController;
    placeViewController = [[PlaceViewController alloc] initWithType: PlaceArrival];
    placeViewController.delegate = self;
    [self.navigationController pushViewController: placeViewController animated:YES];
}

- (void)selectPlace:(nonnull id)place withType:(PlaceType)placeType andDataType:(DataSourceType)dataType {
    [self setPlace:place withDataType:dataType andPlaceType:placeType forButton: (placeType == PlaceDeparture) ? _departureButton : _arrivalButton ];

}

- (void)setPlace:(id)place withDataType:(DataSourceType)dataType andPlaceType:(PlaceType)placeType forButton:(UIButton *)button {
    NSString *title;
    NSString *iata;
    if (dataType == DataSourceTypeCity) {
        City *city = (City *)place;
        title = city.name;
        iata = city.code;
    }
    else if (dataType == DataSourceTypeAirport) {
        Airport *airport = (Airport *)place;
        title = airport.name;
        iata = airport.cityCode;
    }
    if (placeType == PlaceDeparture) {
        _searchRequest.origin = iata;
    } else {
        _searchRequest.destionation = iata;
    }

    [button setTitle: title forState: UIControlStateNormal];
}

@end
