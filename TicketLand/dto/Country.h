//
//  Country.h
//  TicketLand
//
//  Created by Дима Давыдов on 18.05.2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Country : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, strong) NSDictionary *translations;
@property (nonatomic, strong) NSString *code;

-(instancetype)initWithDictionary:(NSDictionary *) dictionary;
@end

NS_ASSUME_NONNULL_END
