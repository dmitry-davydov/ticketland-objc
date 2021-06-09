//
//  Ticket.h
//  TicketLand
//
//  Created by Дима Давыдов on 03.06.2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Ticket : NSObject

@property (nonatomic, strong) NSString *airline;
@property (nonatomic, strong) NSString *from;
@property (nonatomic, strong) NSString *to;
@property (nonatomic, strong) NSNumber *flightNumber;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSDate *returnAt;
@property (nonatomic, strong) NSDate *departureAt;
@property (nonatomic, strong) NSDate *expiresAt;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
