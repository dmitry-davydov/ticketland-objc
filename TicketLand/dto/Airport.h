//
//  Airport.h
//  TicketLand
//
//  Created by Дима Давыдов on 18.05.2021.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Airport : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *timeZone;
@property (nonatomic, strong) NSDictionary *nameTranslations;
@property (nonatomic, strong) NSString *countryCode;
@property (nonatomic, strong) NSString *cityCode;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, getter=isFlightable) BOOL flightable;
@property (nonatomic) CLLocationCoordinate2D coordinate;

- (instancetype) initWithDictionary: (NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
