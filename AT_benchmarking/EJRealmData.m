//
//  EJRealmData.m
//  AT_benchmarking
//
//  Created by Eunjoo Im on 2016. 5. 27..
//  Copyright © 2016년 Jay Im. All rights reserved.
//

#import "EJRealmData.h"

@implementation EJRealmData

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
