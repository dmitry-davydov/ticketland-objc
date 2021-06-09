//
//  DataManager.h
//  TicketLand
//
//  Created by Дима Давыдов on 18.05.2021.
//

#import <Foundation/Foundation.h>
#import "City.h"
#import "Country.h"
#import "Airport.h"
#import "Price.h"
#import "Ticket.h"

NS_ASSUME_NONNULL_BEGIN

#define kDataManagerLoadDataDidComplete @"DataManagerLoadDataDidComplete"

typedef enum DataSourceType {
    DataSourceTypeCountry,
    DataSourceTypeCity,
    DataSourceTypeAirport
} DataSourceType;

typedef struct SearchRequest {
    __unsafe_unretained NSString *origin;
    __unsafe_unretained NSString *destionation;
    __unsafe_unretained NSDate *departDate;
    __unsafe_unretained NSDate *returnDate;
} SearchRequest;

@interface DataManager : NSObject

+ (instancetype)sharedInstance;
- (void)loadData;

@property (nonatomic, strong, readonly) NSArray *countries;
@property (nonatomic, strong, readonly) NSArray *cities;
@property (nonatomic, strong, readonly) NSArray *airports;

- (City *)cityForIATA:(NSString *)iata;
- (void)mapPricesFor:(City *)origin withCompletion:(void (^)(NSArray<Price *> *prices))completion;
- (void)load:(NSString *)urlString withCompletion:(void (^)(id _Nullable result))completion;
- (City *)cityForLocation:(CLLocation *)location;
- (void)ticketsWithRequest:(SearchRequest)request withCompletion:(void (^)(NSArray *tickets))completion;

@end

NS_ASSUME_NONNULL_END
