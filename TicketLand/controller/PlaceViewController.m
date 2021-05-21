//
//  PlaceViewController.m
//  TicketLand
//
//  Created by Дима Давыдов on 20.05.2021.
//

#define ReuseIdentifier @"PlaceCellIdentifier"

#import "PlaceViewController.h"

@interface PlaceViewController ()
@property (nonatomic) PlaceType placeType;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) NSArray *currentArray;
@end

@implementation PlaceViewController

- (instancetype) initWithType:(PlaceType)type {
    self = [super init];
    if (self) {
        _placeType = type;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureTitle];
    [self configureTableView];
    [self configureSegmentedControl];
    
    [self changeSource];
}

- (void)configureTitle{
    if (_placeType == PlaceDeparture) {
        self.title = @"Departure";
    } else {
        self.title = @"Arrival";
    }
}

- (void)configureTableView{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)configureSegmentedControl {
    NSArray *segments = @[@"Cities", @"Airports"];
    
    _segmentedControl = [[UISegmentedControl alloc] initWithItems: segments];
    _segmentedControl.selectedSegmentIndex = 0;
    [_segmentedControl addTarget:self action:@selector(changeSource) forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.titleView = _segmentedControl;
}

- (void) changeSource {
    switch (_segmentedControl.selectedSegmentIndex) {
        case 0:
            _currentArray = [[DataManager sharedInstance] cities];
            break;
        case 1:
            _currentArray = [[DataManager sharedInstance] airports];
            break;
        default:
            break;
    }
    
    [self.tableView reloadData];
}

// MARK: - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_currentArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:ReuseIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (_segmentedControl.selectedSegmentIndex == 0) {
        City *city = [_currentArray objectAtIndex:indexPath.row];
        cell.textLabel.text = city.name;
        cell.detailTextLabel.text = city.code;
    }
    else if (_segmentedControl.selectedSegmentIndex == 1) {
        Airport *airport = [_currentArray objectAtIndex:indexPath.row];
        cell.textLabel.text = airport.name;
        cell.detailTextLabel.text = airport.code;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DataSourceType dataType = ((int)_segmentedControl.selectedSegmentIndex) + 1;
    [self.delegate selectPlace:[_currentArray objectAtIndex:indexPath.row] withType:_placeType andDataType:dataType];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
