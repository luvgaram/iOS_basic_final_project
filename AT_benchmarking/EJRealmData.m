//
//  EJRealmData.m
//  AT_benchmarking
//
//  Created by Eunjoo Im on 2016. 5. 27..
//  Copyright © 2016년 Jay Im. All rights reserved.
//

#import "EJRealmData.h"

@implementation EJRealmData

//@property NSInteger id;
//@property BOOL status;
//@property int type;
//@property int character;
//@property NSString *title;
//@property NSDate *date;
//@property NSString *start;
//@property NSString *end;
//@property NSString *current;
//@property NSString *unit;
//
//@property NSString *startString;
//@property NSString *endString;
//@property NSString *now;
//@property int percent;

+ (NSString *)primaryKey {
    return @"id";
}

+ (NSArray *)requiredProperties {
    return @[@"id", @"type", @"title"];
}

+ (NSArray *)ignoredProperties {
    return @[@"startString", @"endString", @"now", @"percent"];
}

+ (NSArray *)indexedProperties {
    return @[@"status"];
}

+ (NSDictionary *)defaultPropertyValues {
    return @{@"status" : @YES};
}


@end
