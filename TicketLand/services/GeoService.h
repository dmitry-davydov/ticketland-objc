//
//  GeoService.h
//  TicketLand
//
//  Created by Дима Давыдов on 28.05.2021.
//

#import <Foundation/Foundation.h>
#define kGeoServiceDidUpdatedCity @"GeoServiceDidUpdatedCity"

NS_ASSUME_NONNULL_BEGIN

@interface GeoService : NSObject
+ (instancetype)sharedInstance;
@end

NS_ASSUME_NONNULL_END
