//
//  Price.h
//  TicketLand
//
//  Created by Дима Давыдов on 02.06.2021.
//

#import <Foundation/Foundation.h>
#import "City.h"

NS_ASSUME_NONNULL_BEGIN

@interface Price : NSObject

@property (strong, nonatomic) City *destination;
@property (strong, nonatomic) City *origin;
@property (strong, nonatomic) NSDate *departure;
@property (strong, nonatomic) NSDate *returnDate;
@property (nonatomic) NSInteger numberOfChanges;
@property (nonatomic) NSInteger value;
@property (nonatomic) NSInteger distance;
@property (nonatomic) BOOL actual;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary withOrigin: (City *)origin;
@end

NS_ASSUME_NONNULL_END
