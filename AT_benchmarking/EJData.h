//
//  EJData.h
//  AT_benchmarking
//
//  Created by Eunjoo Im on 2016. 5. 10..
//  Copyright © 2016년 Jay Im. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EJData : NSObject

@property int type;
@property int character;
@property NSString *title;
@property NSDate *date;
@property NSString *start;
@property NSString *end;
@property NSString *now;
@property int percent;
@property float measure;
@property NSString *startString;
@property NSString *endString;

- (id)initWithType:(int)type character:(int)character title:(NSString *)title date:(NSDate *)date start:(NSString *)start end:(NSString *)end;

- (id)initWithType:(int)type character:(int)character title:(NSString *)title date:(NSDate *)date start:(NSString *)start end:(NSString *)end now:(NSString *)now unit:(NSString *)customUnit;

- (NSString *)unit;
- (NSString *)nowForUnit;

@end
