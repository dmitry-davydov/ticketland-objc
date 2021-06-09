//
//  PointAnnotation.h
//  TicketLand
//
//  Created by Дима Давыдов on 05.06.2021.
//

#import <MapKit/MapKit.h>
#import "Price.h"

NS_ASSUME_NONNULL_BEGIN

@interface PointAnnotation : MKPointAnnotation
@property int priceId;
@end

NS_ASSUME_NONNULL_END
