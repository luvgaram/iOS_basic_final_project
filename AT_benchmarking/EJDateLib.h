//
//  EJDateLib.h
//  AT_benchmarking
//
//  Created by 채식상어 on 2016. 5. 23..
//  Copyright © 2016년 Jay Im. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EJDateLib : NSObject

#pragma mark - DateConvertor

+ (NSDate *)dateFromString:(NSString *)string;
+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSString *)dayStringFromDate:(NSDate *)date;
+ (NSString *)simpleDayStringFromDate:(NSDate *)date;
+ (NSDateComponents *)componentsFrom:(NSDate *)startDate To:(NSDate *)endDate;
+ (NSDateComponents *)componentsForToday:(NSDate *)date;

@end
