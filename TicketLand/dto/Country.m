//
//  Country.m
//  TicketLand
//
//  Created by Дима Давыдов on 18.05.2021.
//

#import "Country.h"

@implementation Country
- (instancetype)initWithDictionary:(NSDictionary *) dictionary {
    self = [super init];
    if (self) {
        _name = [dictionary valueForKey:@"name"];
        _currency = [dictionary valueForKey:@"currency"];
        _translations = [dictionary valueForKey:@"name_translations"];
        _code = [dictionary valueForKey:@"code"];
    }
    
    return self;
}
@end
