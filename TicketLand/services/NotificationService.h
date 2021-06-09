//
//  NotificationService.h
//  TicketLand
//
//  Created by Дима Давыдов on 06.06.2021.
//

#import <Foundation/Foundation.h>

typedef struct Notification {
    __unsafe_unretained NSString * _Nullable title;
    __unsafe_unretained NSString * _Nonnull body;
    __unsafe_unretained NSDate * _Nonnull date;
    __unsafe_unretained NSURL * _Nullable imageURL;
} Notification;

NS_ASSUME_NONNULL_BEGIN

@interface NotificationService : NSObject
+ (instancetype)sharedInstance;
- (void)configureService;
- (void)send:(Notification)notification category:(NSString *)category;

Notification CreateNotification(NSString* _Nullable title, NSString* _Nonnull body, NSDate* _Nonnull date, NSURL* _Nullable imageURL);

@end

NS_ASSUME_NONNULL_END
