//
//  TicketsViewController.h
//  TicketLand
//
//  Created by Дима Давыдов on 05.06.2021.
//

#import <UIKit/UIKit.h>
#import "Ticket.h"
#import "TicketTableViewCell.h"
#import "DatabaseService.h"

NS_ASSUME_NONNULL_BEGIN

@interface TicketsViewController : UITableViewController
- (instancetype)initWithTickets:(NSArray<Ticket*> *)tickets;
- (instancetype)initFavoriteTicketsController;
@end

NS_ASSUME_NONNULL_END
