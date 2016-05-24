//
//  EJData.m
//  AT_benchmarking
//
//  Created by Eunjoo Im on 2016. 5. 10..
//  Copyright © 2016년 Jay Im. All rights reserved.
//

#import "EJData.h"
#import "EJDateLib.h"

@implementation EJData

// type 0: hour 1: day 2: week 3: month 4: year 5: life, 6: anniversary 7: custom
enum {hour, day = 1, week, month, year, life, anniversary, custom} curType;

//@property int type;
//@property int character;
//@property NSString *title;
//@property NSString *start;
//@property NSString *end;
//@property NSString *now;
//@property int percent;
//@property float measure;

- (id)initWithType:(int)type character:(int)character title:(NSString *)title date:(NSDate *)date start:(NSString *)start end:(NSString *)end {
    self = [super init];
    
    if (self) {
        _type = type;
        _character = character;
        _title = title;
        _date = date;
        _start = start;
        _end = end;
        
        [self setProperties:start end:end type:type];
    }
    
    return self;
}

- (void)setProperties:(NSString *)start end:(NSString *)end type:(int)type {
    
    NSLog(@"type: %d", type);
    
    switch (type) {
        case hour: {
            NSDate *startDate = [EJDateLib dateFromString:start];
            NSDate *endDate = [EJDateLib dateFromString:end];
            NSDate *now = [NSDate date];
            
            NSDateComponents *conversionInfo = [EJDateLib componentsFrom:startDate To:endDate];
            
            _measure = [conversionInfo day] * 24 * 60 + [conversionInfo hour] * 60 + [conversionInfo minute];
            
            NSDateComponents *conversionInfoPercent = [EJDateLib componentsFrom:startDate To:now];
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
            NSDate *startDate = [EJDateLib dateFromString:start];
            NSDate *endDate = [EJDateLib dateFromString:end];
            NSDate *now = [NSDate date];
            
            NSDateComponents *conversionInfo = [EJDateLib componentsFrom:startDate To:endDate];
            
            _measure = [conversionInfo day];
            
            NSDateComponents *conversionInfoPercent = [EJDateLib componentsFrom:startDate To:now];
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
            
            NSDateComponents *components = [EJDateLib componentsForToday:today];

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
            
        case anniversary: {
            NSDate *startDate = [EJDateLib dateFromString:start];
            NSDate *endDate = [EJDateLib dateFromString:end];
            NSDate *now = [NSDate date];
            
            NSLog(@"startDate: %@, endDate: %@", startDate, endDate);
            
            // check d-day
            if ([now compare:startDate] == NSOrderedAscending) {
                endDate = startDate;
                NSDate *inputDateMidNight = [[NSCalendar currentCalendar] startOfDayForDate:_date];
                startDate = inputDateMidNight;
                NSLog(@"startDate: %@, endDate: %@", startDate, endDate);
                
                NSDateComponents *conversionInfo = [EJDateLib componentsFrom:startDate To:endDate];
                
                _measure = [conversionInfo day];
                
                NSDateComponents *conversionInfoPercent = [EJDateLib componentsFrom:startDate To:now];
                int measurePercent = [conversionInfoPercent day];
                
                NSLog(@"_measure: %f, now: %d", _measure, measurePercent);
                
                _startString = [EJDateLib simpleDayStringFromDate:startDate];
                _endString = [EJDateLib simpleDayStringFromDate:endDate];
                _percent = (measurePercent / _measure) * 100;
                
            } else {
                NSDate *todayMidNight = [[NSCalendar currentCalendar] startOfDayForDate:[NSDate date]];
                NSDateComponents *checkDays = [EJDateLib componentsFrom:startDate To:now];
                int measureR = [checkDays day];
                
                int r = 100 - (measureR % 100);
                NSLog(@"measurePercent: %d, 100r: %d", measureR, r );
                
                endDate = [todayMidNight dateByAddingTimeInterval:60 * 60 * 24 * r];
                
                NSDateComponents *conversionInfo = [EJDateLib componentsFrom:startDate To:endDate];
                
                _measure = [conversionInfo day];
                
                NSDateComponents *conversionInfoPercent = [EJDateLib componentsFrom:startDate To:now];
                int measurePercent = [conversionInfoPercent day];
                
                NSLog(@"_measure: %f, now: %d", _measure, measurePercent);
                
                _startString = [EJDateLib simpleDayStringFromDate:startDate];
                _endString = [NSString stringWithFormat:@"%d일", [[NSNumber numberWithFloat:_measure] intValue]];
                _percent = (measurePercent / _measure) * 100;
            }
            
            break;
        }
        case custom:
            break;
    }
}


//#pragma mark - DateConvertor
//
//- (NSDate *)dateFromString:(NSString *)string {
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
//    return [dateFormatter dateFromString:string];
//}
//
//- (NSString *)stringFromDate:(NSDate *)date {
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//    [dateFormatter setDateFormat:@"yyyy MM dd HH mm ss"];
//    return [dateFormatter stringFromDate:date];
//}
//
//- (NSDateComponents *)componentsFrom:(NSDate *)startDate To:(NSDate *)endDate {
//    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
//
////    unsigned int unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitDay | NSCalendarUnitMonth;
//    unsigned int unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitDay;
//    
//    NSDateComponents *conversionInfo = [sysCalendar components:unitFlags fromDate:startDate  toDate:endDate  options:0];
//
////    NSLog(@"Conversion: %dmin %dhours %ddays %dmonths",[conversionInfo minute], [conversionInfo hour], [conversionInfo day], [conversionInfo month]);
//    NSLog(@"Conversion: %dmin %dhours %ddays",[conversionInfo minute], [conversionInfo hour], [conversionInfo day]);
//
//    return conversionInfo;
//}
//
//- (NSDateComponents *)componentsForToday:(NSDate *)date {
//    return [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
//}

@end
