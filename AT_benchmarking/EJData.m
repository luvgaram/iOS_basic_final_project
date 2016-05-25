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
enum {hour = 0, day = 1, week, month, year, life, anniversary, custom} curType;

//@property int type;
//@property int character;
//@property NSString *title;
//@property NSString *start;
//@property NSString *end;
//@property NSString *now;
//@property int percent;
//@property float measure;

NSString *unit;
NSString *nowForUnit;

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

- (id)initWithType:(int)type character:(int)character title:(NSString *)title date:(NSDate *)date start:(NSString *)start end:(NSString *)end now:(NSString *)customNow unit:(NSString *)customUnit {
    
    nowForUnit = customNow;
    unit = customUnit;
    NSLog(@"now: %@ %@", nowForUnit, unit);

    self = [self initWithType:type character:character title:title date:date start:start end:end];
    
    return self;
}

#pragma mark - set properties

- (void)setProperties:(NSString *)start end:(NSString *)end type:(int)type {
    
    
    NSLog(@"type: %d", type);
    
    switch (type) {
        case hour:
            [self setHourType:start end:end];
            break;
        
        case day:
            [self setDayType:start end:end];
            break;
    
        case week:
            [self setWeekType:start end:end];
            break;
            
        case month:
            [self setMonthType:start end:end];
            break;

        case year:
            break;
        case life:
            break;
            
        case anniversary:
            [self setAnniversaryType:start end:end];
            break;
            
        case custom:
            [self setCustomType:start end:end];
            break;
    }
}

- (void)setCustomType:(NSString *)start end:(NSString *)end {
    NSLog(@"custom");
    float startNumber = [start floatValue];
    float endNumber = [end floatValue];
    float currentNumber = [nowForUnit floatValue];
    float measurePercent;
    

    
    _measure = endNumber - startNumber;
    measurePercent = currentNumber - startNumber;
    
    if (startNumber > endNumber) {
        _measure = -_measure;
        measurePercent = -measurePercent;
    }
    
    NSLog(@"startNumber: %f, endNumber: %f, currentNumber: %f, measure: %f, mPer: %f", startNumber, endNumber, currentNumber, _measure, measurePercent);
    
    _percent = (int)((measurePercent / _measure) * 100);
        
    NSLog(@"startNumber: %f, endNumber: %f, currentNuber: %f, measure: %f, mPer: %f", startNumber, endNumber, currentNumber, _measure, measurePercent);
    
    _startString = [NSString stringWithFormat:@"%d%@", (int)startNumber, unit];
    _endString = [NSString stringWithFormat:@"%d%@", (int)endNumber, unit];
}

- (void)setHourType:(NSString *)start end:(NSString *)end {
    NSDate *startDate = [EJDateLib dateFromString:start];
    NSDate *endDate = [EJDateLib dateFromString:end];
    NSDate *now = [NSDate date];
    
    NSDateComponents *conversionInfo = [EJDateLib componentsFrom:startDate To:endDate];
    
    _measure = [conversionInfo day] * 24 * 60 + [conversionInfo hour] * 60 + [conversionInfo minute];
    
    NSDateComponents *conversionInfoPercent = [EJDateLib componentsFrom:startDate To:now];
    int measurePercent = [conversionInfoPercent day] * 24 * 60 + [conversionInfoPercent hour] * 60 + [conversionInfoPercent minute];
    
    NSLog(@"_measure: %f, now: %d", _measure, measurePercent);
    
    //            _startString = @"0분";
    //            _endString = [NSString stringWithFormat:@"%d분", [[NSNumber numberWithFloat:_measure] intValue]];
    
    _startString = [EJDateLib simpleHourStringFromDate:startDate];
    _endString = [EJDateLib simpleHourStringFromDate:endDate];
    
    if ([now compare:endDate] == NSOrderedAscending) {
        _percent = (measurePercent / _measure) * 100;
    } else {
        _percent = 100;
    }
}

- (void)setDayType:(NSString *)start end:(NSString *)end {
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
}

- (void)setWeekType:(NSString *)start end:(NSString *)end {
    _startString = @"일";
    _endString = @"토";
    
    NSCalendar* currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents* dateComponents = [currentCalendar components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    NSInteger weekDay = [dateComponents weekday];
    
    _measure = 7;
    _percent = ((weekDay - 1) / _measure) * 100;
}

- (void)setMonthType:(NSString *)start end:(NSString *)end {
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
}

- (void)setAnniversaryType:(NSString *)start end:(NSString *)end {
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
}

@end
