//
//  EJDataManager.m
//  AT_benchmarking
//
//  Created by Eunjoo Im on 2016. 5. 27..
//  Copyright © 2016년 Jay Im. All rights reserved.
//

#import "EJDataManager.h"
#import <Realm/Realm.h>
#import "EJRealmData.h"
#import "EJDateLib.h"

@implementation EJDataManager

// type 0: hour 1: day 2: week 3: month 4: year 5: anniversary 6:custom 7: today
enum {hour = 0, day = 1, week, month, year, anniversary, custom, today} dataType;
RLMRealm *realm;
int idManager;

+ (EJDataManager *)sharedInstance {
    static dispatch_once_t pred;
    static EJDataManager *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[EJDataManager alloc] init];
        realm = [RLMRealm defaultRealm];
        idManager = [[[EJRealmData allObjects] maxOfProperty:@"id"] intValue] + 1;
    });
    
    return shared;
}

- (int)getIdManager {
    NSLog(@"idManager: %d", idManager);
    return idManager++;
}

- (void)addData:(EJRealmData *)data {
    [realm beginWriteTransaction];
    [realm addObject:data];
    [realm commitWriteTransaction];
}

- (EJRealmData *)getData:(int)id {
    return [EJRealmData objectInRealm:realm forPrimaryKey:@(id)];
}

- (void)updateData:(EJRealmData *)data {
    [realm beginWriteTransaction];
    [realm addOrUpdateObject:data];
    [realm commitWriteTransaction];
}

- (void)deleteData:(int)id {
    [realm beginWriteTransaction];
    EJRealmData *targetData = [self getData:id];
    targetData.status = NO;
    [realm commitWriteTransaction];
}

- (NSMutableArray *)getAllData {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"status = %hhd", YES];
    RLMResults *allData = [EJRealmData objectsWithPredicate:pred];
    
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    for (EJRealmData *data in allData) {
        [resultArray addObject:[self setProperties:data start:data.start end:data.end type:data.type]];
        NSLog(@"data added: %@, %@", resultArray[[resultArray count] - 1], [resultArray[[resultArray count] - 1] startString]);
    }
    
    return resultArray;
}

#pragma mark - set properties
- (EJRealmData *)setProperties:(EJRealmData *)data start:(NSString *)start end:(NSString *)end type:(int)type {
    switch (type) {
        case hour:
            return [self setHourType:data start:start end:end];
            
        case day:
            return [self setDayType:data start:start end:end];
            
        case week:
            return [self setWeekType:data];
            
        case month:
            return [self setMonthType:data];
            
        case year:
            return [self setYearType:data];
            
        case anniversary:
            return [self setAnniversaryType:data start:start end:end];
            
        case custom:
            return [self setCustomType:data start:start end:end];
            
        case today:
            return [self setTodayType: data];
    }
    
    return data;
}

- (EJRealmData *)setHourType:(EJRealmData *)data start:(NSString *)start end:(NSString *)end {
    NSDate *startDate = [EJDateLib dateFromString:start];
    NSDate *endDate = [EJDateLib dateFromString:end];
    NSDate *now = [NSDate date];
    
    NSDateComponents *conversionInfo = [EJDateLib componentsFrom:startDate To:endDate];
    
    int measure = [conversionInfo day] * 24 * 60 + [conversionInfo hour] * 60 + [conversionInfo minute];
    
    NSDateComponents *conversionInfoPercent = [EJDateLib componentsFrom:startDate To:now];
    int measurePercent = [conversionInfoPercent day] * 24 * 60 + [conversionInfoPercent hour] * 60 + [conversionInfoPercent minute];

    data.now = [EJDateLib simpleHourStringFromDate:[NSDate date]];
    data.startString = [EJDateLib simpleHourStringFromDate:startDate];
    data.endString = [EJDateLib simpleHourStringFromDate:endDate];
    
    if ([now compare:endDate] == NSOrderedAscending) {
        data.percent = (measurePercent / measure) * 100;
    } else {
        data.percent = 100;
    }
    
    return data;
}

- (EJRealmData *)setDayType:(EJRealmData *)data start:(NSString *)start end:(NSString *)end {
    NSDate *startDate = [EJDateLib dateFromString:start];
    NSDate *endDate = [EJDateLib dateFromString:end];
    NSDate *now = [NSDate date];
    
    NSDateComponents *conversionInfo = [EJDateLib componentsFrom:startDate To:endDate];
    
    int measure = [conversionInfo day];
    
    NSDateComponents *conversionInfoPercent = [EJDateLib componentsFrom:startDate To:now];
    int measurePercent = [conversionInfoPercent day];
    
    data.now = [NSString stringWithFormat:@"%d일", measure];
    data.startString = @"0일";
    data.endString = [NSString stringWithFormat:@"%d일", [[NSNumber numberWithFloat:measure] intValue]];
    
    if ([now compare:endDate] == NSOrderedAscending) {
        data.percent = (measurePercent / measure) * 100;
    } else {
        data.percent = 100;
    }
    
    return data;
}

- (EJRealmData *)setTodayType:(EJRealmData *)data {
    NSDate *startDate = [[NSCalendar currentCalendar] startOfDayForDate:[NSDate date]];
    NSDate *endDate = [startDate dateByAddingTimeInterval: (60 * 60 * 24 * 1)];
    NSDate *now = [NSDate date];
    
    NSDateComponents *conversionInfo = [EJDateLib componentsFrom:startDate To:endDate];
    
    int measure = [conversionInfo day] * 24 * 60 + [conversionInfo hour] * 60 + [conversionInfo minute];
    
    NSDateComponents *conversionInfoPercent = [EJDateLib componentsFrom:startDate To:now];
    int measurePercent = [conversionInfoPercent day] * 24 * 60 + [conversionInfoPercent hour] * 60 + [conversionInfoPercent minute];
    
    data.now = [EJDateLib simpleHourStringFromDate:[NSDate date]];
    data.startString = @"0시";
    data.endString = @"24시";
    
    if ([now compare:endDate] == NSOrderedAscending) {
        data.percent = (measurePercent / measure) * 100;
    } else {
        data.percent = 100;
    }
    
    return data;
}


- (EJRealmData *)setWeekType:(EJRealmData *)data {
    NSCalendar* currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents* dateComponents = [currentCalendar components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    NSInteger weekDay = [dateComponents weekday];
    
    int measure = 7;
    data.percent = ((weekDay - 1) / measure) * 100;
    
    NSArray *weekName = [NSArray arrayWithObjects:@"일", @"월", @"화", @"수", @"목", @"금", @"토", nil];
    data.now = weekName[weekDay];
    data.startString = @"일";
    data.endString = @"토";
    
    return data;
}

- (EJRealmData *)setMonthType:(EJRealmData *)data {
    NSDate *today = [NSDate date];
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSRange days = [currentCalendar rangeOfUnit:NSCalendarUnitDay
                                         inUnit:NSCalendarUnitMonth
                                        forDate:today];
    
    int measure = days.length;
    
    NSDateComponents *components = [EJDateLib componentsForToday:today];
    
    int day = [components day];
    
    data.percent = ((day - 1) / measure) * 100;
    
    data.now = [NSString stringWithFormat:@"%d일", day];
    data.startString = @"0일";
    data.endString = [NSString stringWithFormat:@"%d일", [[NSNumber numberWithFloat:measure] intValue]];
    
    return data;
}

- (EJRealmData *)setYearType:(EJRealmData *)data {
    NSDate *today = [NSDate date];
    
    NSDateComponents *dateCompoForThisYear = [[NSDateComponents alloc] init];
    int thisYearNumber = [[NSCalendar currentCalendar] component:NSCalendarUnitYear fromDate:NSDate.date];
    dateCompoForThisYear.year = thisYearNumber;
    dateCompoForThisYear.month = 1;
    dateCompoForThisYear.day = 1;
    
    NSDate *firstDayOfThisYear = [[NSCalendar currentCalendar] dateFromComponents:dateCompoForThisYear];
    NSDateComponents *conversionInfo = [EJDateLib componentsFrom:firstDayOfThisYear To:today];
    
    int currentDay = [conversionInfo day];
    
    NSDateComponents *dateCompoForNextYear = [[NSDateComponents alloc] init];
    dateCompoForNextYear.year = thisYearNumber + 1;
    dateCompoForNextYear.month = 1;
    dateCompoForNextYear.day = 1;
    
    NSDate *firstDayOfNextYear = [[NSCalendar currentCalendar] dateFromComponents:dateCompoForNextYear];
    
    NSDateComponents *conversionInfo2 = [EJDateLib componentsFrom:firstDayOfThisYear To:firstDayOfNextYear];
    
    int daysInThisYear = [conversionInfo2 day];
    int measure = daysInThisYear;

    data.percent = (currentDay / measure) * 100;
    
    data.now = [EJDateLib simpleDayStringFromDate:[NSDate date]];
    data.startString = @"1일1일";
    data.endString = @"12일31일";
    
    return data;
}

- (EJRealmData *)setAnniversaryType:(EJRealmData *)data start:(NSString *)start end:(NSString *)end {
    NSDate *startDate = [EJDateLib dateFromString:start];
    NSDate *endDate = [EJDateLib dateFromString:end];
    NSDate *now = [NSDate date];
    
    NSLog(@"startDate: %@, endDate: %@", startDate, endDate);
    
    // check d-day
    if ([now compare:startDate] == NSOrderedAscending) {
        endDate = startDate;
        NSDate *inputDateMidNight = [[NSCalendar currentCalendar] startOfDayForDate:data.date];
        startDate = inputDateMidNight;
        
        NSDateComponents *conversionInfo = [EJDateLib componentsFrom:startDate To:endDate];
        
        int measure = [conversionInfo day];
        NSDateComponents *conversionInfoPercent = [EJDateLib componentsFrom:startDate To:now];
        int measurePercent = [conversionInfoPercent day];
        
        data.now = [NSString stringWithFormat:@"-%d일", measure];
        data.startString = [EJDateLib simpleDayStringFromDate:startDate];
        data.endString = [EJDateLib simpleDayStringFromDate:endDate];
        data.percent = (measurePercent / measure) * 100;
        
    } else {
        NSDate *todayMidNight = [[NSCalendar currentCalendar] startOfDayForDate:[NSDate date]];
        NSDateComponents *checkDays = [EJDateLib componentsFrom:startDate To:now];
        int measureR = [checkDays day];
        
        int r = 100 - (measureR % 100);
        
        endDate = [todayMidNight dateByAddingTimeInterval:60 * 60 * 24 * r];
        
        NSDateComponents *conversionInfo = [EJDateLib componentsFrom:startDate To:endDate];
        
        int measure = [conversionInfo day];
        
        NSDateComponents *conversionInfoPercent = [EJDateLib componentsFrom:startDate To:now];
        int measurePercent = [conversionInfoPercent day];

        data.now = [NSString stringWithFormat:@"%d일", measure];
        data.startString = [EJDateLib simpleDayStringFromDate:startDate];
        data.endString = [NSString stringWithFormat:@"%d일", [[NSNumber numberWithFloat:measure] intValue]];
        data.percent = (measurePercent / measure) * 100;
    }
    
    return data;
}

- (EJRealmData *)setCustomType:(EJRealmData *)data start:(NSString *)start end:(NSString *)end {
    NSLog(@"custom");
    float startNumber = [start floatValue];
    float endNumber = [end floatValue];
    float currentNumber = [data.unit floatValue];
    float measurePercent;
    
    int measure = endNumber - startNumber;
    measurePercent = currentNumber - startNumber;
    
    if (startNumber > endNumber) {
        measure = -measure;
        measurePercent = -measurePercent;
    }
    
    data.percent = (int)((measurePercent / measure) * 100);

    data.now = [NSString stringWithFormat:@"%d%@", (int)data.current, data.unit];
    data.startString = [NSString stringWithFormat:@"%d%@", (int)startNumber, data.unit];
    data.endString = [NSString stringWithFormat:@"%d%@", (int)endNumber, data.unit];
    
    return data;
}

@end
