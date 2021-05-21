//
//  City.h
//  TicketLand
//
//  Created by Дима Давыдов on 18.05.2021.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
{
"name": "Marshall",
"time_zone": "America/Chicago",
"name_translations": {
  "en": "Marshall",
  "ru": "Маршалл",
  "de": "Marshall",
  "tr": "Marshall",
  "th": "Marshall",
  "it": "Marshall",
  "fr": "Marshall",
  "es": "Marshall",
  "zh-CN": "马歇尔",
  "pl": "Marshall",
  "pt": "Marshall",
  "pt-BR": "Marshall",
  "lt": "Marshall",
  "jp": "Marshall",
  "zh-Hant": "Marshall",
  "tl": "Marshall",
  "ko": "Marshall",
  "ms": "Marshall",
  "vi": "Marshall",
  "zh-TW": "Marshall",
  "id": "Marshall",
  "ar": "Marshall",
  "uk": "Marshall"
},
"country_code": "US",
"code": "ASL",
"coordinates": {
  "lon": -94.38333,
  "lat": 32.55
}
 */
@interface City : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *timeZone;
@property (nonatomic, strong) NSDictionary *nameTranslations;
@property (nonatomic, strong) NSString *countryCode;
@property (nonatomic, strong) NSString *code;
@property (nonatomic) CLLocationCoordinate2D coordinate;

- (instancetype) initWithDictionary: (NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
