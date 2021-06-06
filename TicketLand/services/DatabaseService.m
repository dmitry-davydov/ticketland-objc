//
//  DatabaseService.m
//  TicketLand
//
//  Created by Дима Давыдов on 03.06.2021.
//

#import "DatabaseService.h"
#import <CoreData/CoreData.h>
#import "Ticket.h"
#import "Price.h"
#import "TicketLand-Swift.h"

@interface DatabaseService ()
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@end

@implementation DatabaseService
+ (instancetype)sharedInstance
{
    static DatabaseService *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DatabaseService alloc] init];
        [instance setup];
    });
    return instance;
}

- (void)setup {
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    NSURL *docsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [docsURL URLByAppendingPathComponent:@"db.sqlite"];
    
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
    
    NSPersistentStore* store = [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:nil];
    if (!store) {
        abort();
    }
    
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _managedObjectContext.persistentStoreCoordinator = _persistentStoreCoordinator;
}

- (void)save {
    NSError *error;
    [_managedObjectContext save: &error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
}

- (FavoriteTicket *)favoriteFromTicket:(Ticket *)ticket {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteTicket"];
    request.predicate = [NSPredicate predicateWithFormat:@"price == %ld AND airline == %@ AND from == %@ AND to == %@ AND departureAt == %@ AND expiresAt == %@ AND flightNumber == %ld", (long)ticket.price.integerValue, ticket.airline, ticket.from, ticket.to, ticket.departureAt, ticket.expiresAt, (long)ticket.flightNumber.integerValue];
    return [[_managedObjectContext executeFetchRequest:request error:nil] firstObject];
}

- (MapPrice *)favoriteMapPriceFromPrice:(Price *)price {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"MapPrice"];
    request.predicate = [NSPredicate predicateWithFormat:@"arrival == %@ and departure == %@", price.actual, price.departure];
    
    return [[_managedObjectContext executeFetchRequest:request error:nil] firstObject];
}

- (BOOL)isFavorite:(Ticket *)ticket {
    return [self favoriteFromTicket:ticket] != nil;
}

- (void)addToFavorite:(Ticket *)ticket {
    FavoriteTicket *favorite = [NSEntityDescription insertNewObjectForEntityForName:@"FavoriteTicket" inManagedObjectContext:_managedObjectContext];
    favorite.price = ticket.price.intValue;
    favorite.airline = ticket.airline;
    favorite.departureAt = ticket.departureAt;
    favorite.expiresAt = ticket.expiresAt;
    favorite.flightNumber = ticket.flightNumber.intValue;
    favorite.returnAt = ticket.returnAt;
    favorite.from = ticket.from;
    favorite.to = ticket.to;
    favorite.createdAt = [NSDate date];
      
    [self save];
}

- (void)addFavoriteCity:(CLLocationCoordinate2D)coordinate {
    FavoriteCity *model = [NSEntityDescription insertNewObjectForEntityForName:@"FavoriteCity" inManagedObjectContext:_managedObjectContext];
    model.lat = (float)coordinate.latitude;
    model.lon = (float)coordinate.longitude;
    
    [self save];
}
- (FavoriteCity *)findFavoriteCity:(CLLocationCoordinate2D)coordinate {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteCity"];
    request.predicate = [NSPredicate predicateWithFormat:@"lat == %@ AND lon == %@", coordinate.latitude, coordinate.longitude];
    
    return [[_managedObjectContext executeFetchRequest:request error:nil] firstObject];
}

- (void)removeFavoriteCity:(FavoriteCity *)city {
    [_managedObjectContext deleteObject:city];
    [self save];
}

- (void)addPriceToFavorite:(Price *)price {
    MapPrice *mapPrice = [NSEntityDescription insertNewObjectForEntityForName:@"MapPrice" inManagedObjectContext:_managedObjectContext];
    mapPrice.departure = price.origin.name;
    mapPrice.arrival = price.origin.name;
    
    [self save];
}

- (void)removePriceFromFavorite:(Price *)price {
    MapPrice *mapPrice = [self favoriteMapPriceFromPrice:price];
    if (mapPrice) {
        [_managedObjectContext deleteObject:mapPrice];
        [self save];
    }
}

- (void)removeFromFavorite:(Ticket *)ticket {
    FavoriteTicket *favorite = [self favoriteFromTicket:ticket];
    if (favorite) {
        [_managedObjectContext deleteObject:favorite];
        [self save];
    }
}

- (NSArray *)favorites {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteTicket"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:YES]];
    return [_managedObjectContext executeFetchRequest:request error:nil];
}

- (NSArray *)favoritesCities {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteCity"];
    return [_managedObjectContext executeFetchRequest:request error:nil];
}

@end
