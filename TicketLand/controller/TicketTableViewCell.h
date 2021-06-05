//
//  TicketTableViewCell.h
//  TicketLand
//
//  Created by Дима Давыдов on 05.06.2021.
//

#import <UIKit/UIKit.h>
#import "Ticket.h"
#import "TicketLand-Swift.h"

NS_ASSUME_NONNULL_BEGIN

@interface TicketTableViewCell : UITableViewCell
@property (nonatomic, strong) Ticket *ticket;
@property (nonatomic, strong) FavoriteTicket *favoriteTicket;
@end

NS_ASSUME_NONNULL_END
