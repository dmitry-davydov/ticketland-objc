//
//  DataManager.m
//  TicketLand
//
//  Created by Дима Давыдов on 18.05.2021.
//

#import "DataManager.h"


#define API_TOKEN @"9cfb220fbf225dc196d63ea213925fc8"
#define API_URL_CHEAP @"http://api.travelpayouts.com/v1/prices/cheap"
#define API_URL_MAP_PRICE @"https://map.aviasales.ru/prices.json?origin_iata="


@interface DataManager ()
@property (nonatomic, strong) NSMutableArray *countriesArray;
@property (nonatomic, strong) NSMutableArray *citiesArray;
@property (nonatomic, strong) NSMutableArray *airportsArray;
@end

@implementation DataManager

+ (instancetype)sharedInstance {
    static DataManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DataManager alloc] init];
    });
    return instance;
}

- (void)loadData {
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^{
        NSArray *countriesJsonArray = [self arrayFromFileName:@"countries" ofType:@"json"];
        self->_countriesArray = [self createObjectsFromArray:countriesJsonArray withType: DataSourceTypeCountry];
        
        NSArray *citiesJsonArray = [self arrayFromFileName:@"cities" ofType:@"json"];
        self->_citiesArray = [self createObjectsFromArray:citiesJsonArray withType: DataSourceTypeCity];
        
        NSArray *airportsJsonArray = [self arrayFromFileName:@"airports" ofType:@"json"];
        self->_airportsArray = [self createObjectsFromArray:airportsJsonArray withType: DataSourceTypeAirport];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kDataManagerLoadDataDidComplete object:nil];
        });
        NSLog(@"Complete load data");
    });
}

- (NSMutableArray *)createObjectsFromArray:(NSArray *)array withType:(DataSourceType)type {
    NSMutableArray *results = [NSMutableArray new];
    
    for (NSDictionary *jsonObject in array) {
        if (type == DataSourceTypeCountry) {
            Country *country = [[Country alloc] initWithDictionary: jsonObject];
            [results addObject: country];
        }
        else if (type == DataSourceTypeCity) {
            City *city = [[City alloc] initWithDictionary: jsonObject];
            [results addObject: city];
        }
        else if (type == DataSourceTypeAirport) {
            Airport *airport = [[Airport alloc] initWithDictionary: jsonObject];
            [results addObject: airport];
        }
    }
    
    return results;
}

- (NSArray *)arrayFromFileName:(NSString *)fileName ofType:(NSString *)type {
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:type];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
}

- (NSArray *)countries {
    return _countriesArray;
}

- (NSArray *)cities {
    return _citiesArray;
}

- (NSArray *)airports {
    return _airportsArray;
}

- (void)load:(NSString *)urlString withCompletion:(void (^)(id _Nullable result))completion {
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        completion([NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil]);
    }] resume] ;
}

- (City *)cityForIATA:(NSString *)iata {
    if (iata) {
        for (City *city in _citiesArray) {
            if ([city.code isEqualToString:iata]) {
                return city;
            }
        }
    }
    return nil;
}

- (void)mapPricesFor:(City *)origin withCompletion:(void (^)(NSArray<Price *> *prices))completion
{
    static BOOL isLoading;
    if (isLoading) { return; }
    isLoading = YES;
    [self load:[NSString stringWithFormat:@"%@%@", API_URL_MAP_PRICE, origin.code] withCompletion:^(id  _Nullable result) {
        NSArray *array = result;
        NSMutableArray *prices = [NSMutableArray new];
        if (!array) { return ;}
        
        for (NSDictionary *mapPriceDictionary in array) {
            Price *price = [[Price alloc] initWithDictionary:mapPriceDictionary withOrigin:origin];
            [prices addObject:price];
        }
        isLoading = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(prices);
        });
    }];
}

- (City *)cityForLocation:(CLLocation *)location {
    for (City *city in _citiesArray) {
        if (ceilf(city.coordinate.latitude) == ceilf(location.coordinate.latitude)
            && ceilf(city.coordinate.longitude) == ceilf(location.coordinate.longitude)) {
            return city;
        }
    }
    return nil;
}

NSString * SearchRequestQuery(SearchRequest request) {
    NSString *result = [NSString stringWithFormat:@"origin=%@&destination=%@", request.origin, request.destionation];
    if (request.departDate && request.returnDate) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM";
        result = [NSString stringWithFormat:@"%@&depart_date=%@&return_date=%@", result, [dateFormatter stringFromDate:request.departDate], [dateFormatter stringFromDate:request.returnDate]];
    }
    return result;
}

- (void)ticketsWithRequest:(SearchRequest)request withCompletion:(void (^)(NSArray *tickets))completion {
    NSString *urlString = [NSString stringWithFormat:@"%@?%@&token=%@", API_URL_CHEAP, SearchRequestQuery(request), API_TOKEN];
    [self load:urlString withCompletion:^(id  _Nullable result) {
        NSDictionary *response = result;
        if (response) {
            NSDictionary *json = [[response valueForKey:@"data"] valueForKey:request.destionation];
            NSMutableArray *array = [NSMutableArray new];
            for (NSString *key in json) {
                NSDictionary *value = [json valueForKey: key];
                Ticket *ticket = [[Ticket alloc] initWithDictionary:value];
                ticket.from = request.origin;
                ticket.to = request.destionation;
                [array addObject:ticket];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(array);
            });
        }
    }];
}

@end
