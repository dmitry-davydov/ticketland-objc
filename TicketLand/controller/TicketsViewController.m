//
//  TicketsViewController.m
//  TicketLand
//
//  Created by Дима Давыдов on 05.06.2021.
//

#import "TicketsViewController.h"
#import "MapViewController.h"
#import "NotificationService.h"

#define TicketCellReuseIdentifier @"TicketCellIdentifier"

@interface TicketsViewController ()
@property (nonatomic, strong) NSArray *tickets;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UITextField *dateTextField;
@property BOOL isFavorites;
@property (nonatomic, strong) TicketTableViewCell* notificationCell;


@property (nonatomic, strong) MapViewController *mapVC;

@end

@implementation TicketsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureSegmentedControl];
}

- (void)configureDatePicker {
    _datePicker = [[UIDatePicker alloc] init];
    _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    _datePicker.minimumDate = [NSDate date];
    
    _dateTextField = [[UITextField alloc] initWithFrame:self.view.bounds];
    _dateTextField.hidden = YES;
    _dateTextField.inputView = _datePicker;
    
    UIToolbar *keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonDidTap:)];
    keyboardToolbar.items = @[flexBarButton, doneBarButton];
    
    _dateTextField.inputAccessoryView = keyboardToolbar;
    [self.view addSubview:_dateTextField];
}

- (void) configureSegmentedControl {
    NSArray *segments = @[@"Tickets", @"Map"];
    
    _segmentedControl = [[UISegmentedControl alloc] initWithItems: segments];
    _segmentedControl.selectedSegmentIndex = 0;
    [_segmentedControl addTarget:self action:@selector(changeSource) forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.titleView = _segmentedControl;
}

- (void) changeSource {
    
    if (_segmentedControl.selectedSegmentIndex == 1) {
        [self addChildViewController:_mapVC];
        [self didMoveToParentViewController:_mapVC];
        [self.view addSubview:_mapVC.view];
    }
    
    if (_segmentedControl.selectedSegmentIndex == 0) {
        [_mapVC.view removeFromSuperview];
    }
}

- (instancetype)initWithTickets:(NSArray *)tickets {
    self = [super init];
    if (self) {
        _tickets = tickets;
        self.title = @"Tickets";
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[TicketTableViewCell class] forCellReuseIdentifier:TicketCellReuseIdentifier];
    }
    
    return self;
}

- (instancetype)initFavoriteTicketsController {
    self = [super init];
    if (self) {
        _isFavorites = YES;
        self.tickets = [NSArray new];
        self.title = @"Favorites";
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[TicketTableViewCell class] forCellReuseIdentifier:TicketCellReuseIdentifier];
        
        self.mapVC = [[MapViewController alloc]initWithFavorites];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
   [super viewDidAppear:animated];
   
   if (_isFavorites) {
       self.navigationController.navigationBar.prefersLargeTitles = YES;
       [self configureDatePicker];
       _tickets = [[DatabaseService sharedInstance] favorites];
       [self.tableView reloadData];
       
   }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tickets.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TicketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TicketCellReuseIdentifier forIndexPath:indexPath];
    if (_isFavorites) {
        cell.favoriteTicket = [_tickets objectAtIndex:indexPath.row];
    } else {
        cell.ticket = [_tickets objectAtIndex:indexPath.row];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Действия с билетом" message:@"Что необходимо сделать с выбранным билетом?" preferredStyle:UIAlertControllerStyleActionSheet];
    
    if (_isFavorites) {
        UIAlertAction *notificationAction = [UIAlertAction actionWithTitle:@"Напомнить" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            self->_notificationCell = [tableView cellForRowAtIndexPath:indexPath];
            [self->_dateTextField becomeFirstResponder];
        }];
        
        [alertController addAction:notificationAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return ;
    }
    
    UIAlertAction *favoriteAction;
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleCancel handler:nil];
    
    if ([[DatabaseService sharedInstance] isFavorite: [_tickets objectAtIndex:indexPath.row]]) {
        favoriteAction = [UIAlertAction actionWithTitle:@"Удалить из избранного" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [[DatabaseService sharedInstance] removeFromFavorite:[self->_tickets objectAtIndex:indexPath.row]];
        }];
    } else {
        favoriteAction = [UIAlertAction actionWithTitle:@"Добавить в избранное" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[DatabaseService sharedInstance] addToFavorite:[self->_tickets objectAtIndex:indexPath.row]];
        }];
    }
    
    [alertController addAction:favoriteAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)doneButtonDidTap:(UIBarButtonItem *)sender
{
    if (_datePicker.date && _notificationCell) {
        
        NSString *message = [NSString stringWithFormat:@"%@ - %@ за %lld руб.", _notificationCell.favoriteTicket.from, _notificationCell.favoriteTicket.to, _notificationCell.favoriteTicket.price];

        NSURL *imageURL;
//        if (notificationCell.airlineLogoView.image) {
//            NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:[NSString stringWithFormat:@"/%@.png", notificationCell.ticket.airline]];
//            if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
//                UIImage *logo = notificationCell.airlineLogoView.image;
//                NSData *pngData = UIImagePNGRepresentation(logo);
//                [pngData writeToFile:path atomically:YES];
//
//            }
//            imageURL = [NSURL fileURLWithPath:path];
//        }

        
        
        Notification notification = CreateNotification(@"Напоминание о билете", message, _datePicker.date, imageURL);
        [[NotificationService sharedInstance] send:notification category:@"favorite-ticket"];

        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Успешно" message:[NSString stringWithFormat:@"Уведомление будет отправлено - %@", _datePicker.date] preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    _datePicker.date = [NSDate date];
    _notificationCell = nil;
    [self.view endEditing:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell.contentView setAlpha:0.0];
    [UIView animateWithDuration:0.5
                          delay:0.2
                        options: UIViewAnimationOptionCurveEaseInOut animations:^
    {
        [cell.contentView setAlpha:1];
    } completion:nil];
}

@end
