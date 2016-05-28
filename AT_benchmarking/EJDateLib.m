//
//  EJDateLib.m
//  AT_benchmarking
//
//  Created by 채식상어 on 2016. 5. 23..
//  Copyright © 2016년 Jay Im. All rights reserved.
//

#import "EJDateLib.h"

@implementation EJDateLib

#pragma mark - DateConvertor

+ (NSDate *)dateFromString:(NSString *)string {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    return [dateFormatter dateFromString:string];
}

+ (NSString *)stringFromDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy MM dd HH mm ss"];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)dayStringFromDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yy년 M월 d일"];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)simpleDayStringFromDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"M월 d일"];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)simpleHourStringFromDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"HH:mm"];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)simpleHourStringFromDateString:(NSString *)string {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"HH:mm"];
    
    return [dateFormatter stringFromDate:[self dateFromString:string]];
}

+ (NSDateComponents *)componentsFrom:(NSDate *)startDate To:(NSDate *)endDate {
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    
    //    unsigned int unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitDay | NSCalendarUnitMonth;
    unsigned int unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitDay;
    
    NSDateComponents *conversionInfo = [sysCalendar components:unitFlags fromDate:startDate  toDate:endDate  options:0];

    NSLog(@"Conversion: %dmin %dhours %ddays",[conversionInfo minute], [conversionInfo hour], [conversionInfo day]);
    
    return conversionInfo;
}

+ (NSDateComponents *)componentsForToday:(NSDate *)date {
    return [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
}

+ (NSDate *)dateFromHour:(int)hour Minite:(int)minute {
    NSDate *todayMidNight = [[NSCalendar currentCalendar] startOfDayForDate:[NSDate date]];

    int addSeconds = (60 * 60 * hour) + (60 * minute);
    return [todayMidNight dateByAddingTimeInterval:addSeconds];
}

@end
