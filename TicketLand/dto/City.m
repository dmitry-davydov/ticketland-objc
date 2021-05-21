//
//  City.m
//  TicketLand
//
//  Created by Дима Давыдов on 18.05.2021.
//

#import "City.h"

@implementation City

- (instancetype) initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _name = [dictionary valueForKey:@"name"];
        _timeZone = [dictionary valueForKey:@"time_zone"];
        _nameTranslations = [dictionary valueForKey:@"name_translations"];
        _countryCode = [dictionary valueForKey:@"country_code"];
        _code = [dictionary valueForKey:@"code"];
        
        NSDictionary *coords = [dictionary valueForKey:@"coordinates"];
        if (coords && ![coords isEqual:[NSNull null]]) {
            NSNumber *lon = [coords valueForKey:@"lon"];
            NSNumber *lat = [coords valueForKey:@"lat"];
            
            if (![lon isEqual:[NSNull null]] && ![lat isEqual:[NSNull null]]) {
                _coordinate = CLLocationCoordinate2DMake([lat doubleValue], [lon doubleValue]);
            }
        }
    }
    
    return self;
}

@end
