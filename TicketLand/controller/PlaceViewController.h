//
//  PlaceViewController.h
//  TicketLand
//
//  Created by Дима Давыдов on 20.05.2021.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum PlaceType {
    PlaceArrival,
    PlaceDeparture
} PlaceType;

@protocol PlaceViewControllerDelegate <NSObject>
- (void) selectPlace:(id)place withType:(PlaceType)placeType andDataType:(DataSourceType)dataType;
@end

@interface PlaceViewController: UIViewController<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) id<PlaceViewControllerDelegate>delegate;
- (instancetype)initWithType:(PlaceType)type;

@end

NS_ASSUME_NONNULL_END
