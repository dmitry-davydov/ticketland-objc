//
//  DatabaseService.h
//  TicketLand
//
//  Created by Дима Давыдов on 03.06.2021.
//

#import <Foundation/Foundation.h>
#import "TicketLand-Swift.h"
#import "Ticket.h"
#import "City.h"

NS_ASSUME_NONNULL_BEGIN

@interface DatabaseService : NSObject
+ (instancetype)sharedInstance;
- (FavoriteTicket *)favoriteFromTicket:(Ticket *)ticket;
- (BOOL)isFavorite:(Ticket *)ticket;
- (void)addToFavorite:(Ticket *)ticket;
- (void)removeFromFavorite:(Ticket *)ticket;
- (NSArray *)favorites;

- (void)addFavoriteCity:(CLLocationCoordinate2D)coordinate;
- (FavoriteCity *)findFavoriteCity:(CLLocationCoordinate2D)coordinate;
- (void)removeFavoriteCity:(FavoriteCity *)city;
- (NSArray *)favoritesCities;
@end

NS_ASSUME_NONNULL_END
