//
//  EJData.m
//  AT_benchmarking
//
//  Created by Eunjoo Im on 2016. 5. 10..
//  Copyright © 2016년 Jay Im. All rights reserved.
//

#import "EJData.h"

@implementation EJData

// type 0: hour 1: day 2: week 3: month 4: year 5: life, 6: custom
enum {hour, day = 1, week, month, year, life, custom} curType;

//@property int type;
//@property int character;
//@property NSString *title;
//@property NSString *start;
//@property NSString *end;
//@property NSString *now;
//@property int percent;
//@property float measure;

- (id)initWithType:(int)type character:(int)character title:(NSString *)title start:(NSString *)start end:(NSString *)end {
    self = [super init];
    
    if (self) {
        _type = type;
        _character = character;
        _title = title;
        _start = start;
        _end = end;
        
        [self setProperties:start end:end type:type];
    }
    
    return self;
}

- (void)setProperties:(NSString *)start end:(NSString *)end type:(int)type {
    switch (type) {
        case hour: {
            NSDate *startDate = [self dateFromString:start];
            NSDate *endDate = [self dateFromString:end];
            NSDate *now = [NSDate date];
            
            NSDateComponents *conversionInfo = [self componentsFrom:startDate To:endDate];
            
            _measure = [conversionInfo day] * 24 * 60 + [conversionInfo hour] * 60 + [conversionInfo minute];
            
            NSDateComponents *conversionInfoPercent = [self componentsFrom:startDate To:now];
            int measurePercent = [conversionInfoPercent day] * 24 * 60 + [conversionInfoPercent hour] * 60 + [conversionInfoPercent minute];
            
            NSLog(@"_measure: %f, now: %d", _measure, measurePercent);
            
            _startString = @"0분";
            _endString = [NSString stringWithFormat:@"%d분", [[NSNumber numberWithFloat:_measure] intValue]];
            
            if ([now compare:endDate] == NSOrderedAscending) {
                _percent = (measurePercent / _measure) * 100;
            } else {
                _percent = 100;
            }
            
            break;
        }
            
        case day: {
            NSDate *startDate = [self dateFromString:start];
            NSDate *endDate = [self dateFromString:end];
            NSDate *now = [NSDate date];
            
            NSDateComponents *conversionInfo = [self componentsFrom:startDate To:endDate];
            
            _measure = [conversionInfo day];
            
            NSDateComponents *conversionInfoPercent = [self componentsFrom:startDate To:now];
            int measurePercent = [conversionInfoPercent day];
            
            NSLog(@"_measure: %f, now: %d", _measure, measurePercent);
            
            _startString = @"0일";
            _endString = [NSString stringWithFormat:@"%d일", [[NSNumber numberWithFloat:_measure] intValue]];
            
            if ([now compare:endDate] == NSOrderedAscending) {
                _percent = (measurePercent / _measure) * 100;
            } else {
                _percent = 100;
            }
            
            break;
        }
            
        case week: {
            _startString = @"일";
            _endString = @"토";
            
            NSCalendar* currentCalendar = [NSCalendar currentCalendar];
            NSDateComponents* dateComponents = [currentCalendar components:NSCalendarUnitWeekday fromDate:[NSDate date]];
            NSInteger weekDay = [dateComponents weekday];
            
            _measure = 7;
            _percent = ((weekDay - 1) / _measure) * 100;
            
            break;
        }
            
        case month: {
            NSDate *today = [NSDate date];
            NSCalendar *currentCalendar = [NSCalendar currentCalendar];
            NSRange days = [currentCalendar rangeOfUnit:NSCalendarUnitDay
                                                 inUnit:NSCalendarUnitMonth
                                                forDate:today];
            
            _measure = days.length;
            
            NSDateComponents *components = [self componentsForToday:today];

            int day = [components day];

            _percent = ((day - 1) / _measure) * 100;
            _startString = @"0일";
            _endString = [NSString stringWithFormat:@"%d일", [[NSNumber numberWithFloat:_measure] intValue]];
            
            break;
        }
        case year:
            break;
        case life:
            break;
        case custom:
            break;
    }
}


#pragma mark - DateConvertor

- (NSDate *)dateFromString:(NSString *)string {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    return [dateFormatter dateFromString:string];
}

- (NSString *)stringFromDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy MM dd HH mm ss"];
    return [dateFormatter stringFromDate:date];
}

- (NSDateComponents *)componentsFrom:(NSDate *)startDate To:(NSDate *)endDate {
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];

//    unsigned int unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitDay | NSCalendarUnitMonth;
    unsigned int unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitDay;
    
    NSDateComponents *conversionInfo = [sysCalendar components:unitFlags fromDate:startDate  toDate:endDate  options:0];

//    NSLog(@"Conversion: %dmin %dhours %ddays %dmonths",[conversionInfo minute], [conversionInfo hour], [conversionInfo day], [conversionInfo month]);
    NSLog(@"Conversion: %dmin %dhours %ddays",[conversionInfo minute], [conversionInfo hour], [conversionInfo day]);

    return conversionInfo;
}

- (NSDateComponents *)componentsForToday:(NSDate *)date {
    return [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
}

@end
