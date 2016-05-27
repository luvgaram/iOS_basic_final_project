//
//  EJSetDayViewController.m
//  AT_benchmarking
//
//  Created by Eunjoo Im on 2016. 5. 17..
//  Copyright © 2016년 Jay Im. All rights reserved.
//

#import "EJSetDayViewController.h"
#import "EJColorLib.h"
#import "EJDateLib.h"
#import "EJData.h"
#import "PDTSimpleCalendarViewController.h"
#import "EJMainViewController.h"
#import "EJNavigationBar.h"

@interface EJSetDayViewController ()

@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UITextField *dayTitleTextView;

@property (weak, nonatomic) IBOutlet UIView *dayPeriodBG;
@property (weak, nonatomic) IBOutlet UIView *dayDateBG;
@property (weak, nonatomic) IBOutlet UILabel *dayPeriodLable;
@property (weak, nonatomic) IBOutlet UILabel *dayDateLable;
@property (weak, nonatomic) IBOutlet UILabel *dayStartPeriod;
@property (weak, nonatomic) IBOutlet UILabel *dayEndPeriod;
@property (weak, nonatomic) IBOutlet UILabel *dayDateSelect;

@end

@implementation EJSetDayViewController

UINavigationController *dayEditNavController;

BOOL isNewDay;
BOOL isPeriod;
BOOL isStartDate;
BOOL isEndDate;
int dayType;
int dayCharacterNumber;
NSDate *periodStart;
NSDate *periodEnd;
NSDate *oneDay;

// type 0: hour 1: day 2: week 3: month 4: year 5: anniversary 6:custom 7: today
enum {hour = 0, day = 1, week, month, year, anniversary, custom, today} EJDaytype;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isPeriod = YES;
    [self setNavigationBar];
    [self setTap];
    
    periodStart = nil;
    periodEnd = nil;
    oneDay = nil;

    isStartDate = NO;
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(characterChanged:) name:@"characterChanged" object:nil];
    
    [self setValuesFromData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    

    [self setValuesFromRecipe];
    
    dayEditNavController = [[UINavigationController alloc] initWithNavigationBarClass:[EJNavigationBar class] toolbarClass:nil];
    
    [self switchSaveButtonStatus];
}

- (void)setValuesFromData {
    if (self.dayData) {
        self.dayTitleTextView.text = self.dayData.title;

        if (self.dayData.type == day) {
            isPeriod = YES;
            periodStart = [EJDateLib dateFromString:self.dayData.start];
            periodEnd = [EJDateLib dateFromString:self.dayData.end];
            self.dayStartPeriod.text = [EJDateLib dayStringFromDate:periodStart];
            self.dayEndPeriod.text = [EJDateLib dayStringFromDate:periodEnd];
        } else {
            isPeriod = NO;
            [self dateViewTapped:nil];
            oneDay = [EJDateLib dateFromString:self.dayData.start];
            self.dayDateSelect.text = [EJDateLib dayStringFromDate:oneDay];
            
            NSLog(@"setValuesFromData: %@", self.dayDateSelect.text);
        }
        isNewDay = NO;
    } else isNewDay = YES;
}

- (void)setValuesFromRecipe {
    if (self.dayTitleFromRecipe) self.dayTitleTextView.text = self.dayTitleFromRecipe;
    if (self.dateTypeFromRecipe) [self dateViewTapped:nil];
}

- (IBAction)dayTitleTextViewClicked:(id)sender {
    [self switchSaveButtonStatus];
}

# pragma mark - navigation bar and button
- (void)setNavigationBar {
    self.navigationController.navigationBar.barTintColor = [EJColorLib colorFromHexString:@"#F8ECDA"];
    self.navigationController.navigationBar.tintColor = [EJColorLib colorFromHexString:@"#DD3243"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSForegroundColorAttributeName : [EJColorLib colorFromHexString:@"#DD3243"],
                                                                      NSFontAttributeName : [UIFont boldSystemFontOfSize:24.0]
                                                                      }];
    self.title = @"+AT";
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveDate)];
    self.navigationItem.rightBarButtonItem = saveButton;
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)switchSaveButtonStatus {
    BOOL isTitleInserted = (self.dayTitleTextView.text.length > 0) ? YES : NO;
    
    if (isPeriod) {
        NSLog(@"isTitleInserted: %hhd, sdate: %d, edate: %d", isTitleInserted, periodStart != nil, periodEnd != nil);
        if (isTitleInserted && periodStart != nil && periodEnd != nil) self.navigationItem.rightBarButtonItem.enabled = YES;
        else self.navigationItem.rightBarButtonItem.enabled = NO;
    } else {
        NSLog(@"isTitleInserted: %hhd, date: %d", isTitleInserted, oneDay != nil);
        if (isTitleInserted && oneDay != nil) self.navigationItem.rightBarButtonItem.enabled = YES;
        else self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

#pragma mark - Notification
- (void)characterChanged:(NSNotification*)notification {
    dayCharacterNumber = [notification.userInfo[@"characterNumber"] intValue];
    NSLog(@"character: %d", dayCharacterNumber);
}

# pragma mark - data save
- (void)saveDate {
    EJData *newData;

    if (isPeriod) {
        newData = [[EJData alloc] initWithType:day character:dayCharacterNumber title:self.dayTitleTextView.text date:[NSDate date] start:[EJDateLib stringFromDate:periodStart] end:[EJDateLib stringFromDate:periodEnd]];
    } else {
        newData = [[EJData alloc] initWithType:anniversary character:dayCharacterNumber title:self.dayTitleTextView.text date:[NSDate date] start:[EJDateLib stringFromDate:oneDay] end:[EJDateLib stringFromDate:oneDay]];
    }
    
    if (isNewDay) [self addDataToMainViewController:newData];
    else [self modifyDataToMainViewController:newData];
}

- (void)addDataToMainViewController:(EJData *) newData {
    EJMainViewController *mainViewController = (EJMainViewController *)[self.navigationController.viewControllers objectAtIndex:0];
    [mainViewController.dataArray addObject:newData];
    
    [self postNotiToMain];
}

- (void)modifyDataToMainViewController:(EJData *) newData {
    EJMainViewController *mainViewController = (EJMainViewController *)[self.navigationController.viewControllers objectAtIndex:0];
    mainViewController.dataArray[self.dayIndex] = newData;
    
    [self postNotiToMain];
}

- (void)postNotiToMain {
    NSNotification *notification = [NSNotification notificationWithName:@"addData" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    [[self navigationController] popToRootViewControllerAnimated:YES];
}

# pragma mark - tap gesture
- (void)setTap {
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(periodViewTapped:)];
    [self.dayPeriodBG addGestureRecognizer:singleFingerTap];
    
    singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(dateViewTapped:)];
    [self.dayDateBG addGestureRecognizer:singleFingerTap];
    
    singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(preiodStartTapped:)];
    [self.dayStartPeriod addGestureRecognizer:singleFingerTap];
    
    singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(preiodEndTapped:)];
    [self.dayEndPeriod addGestureRecognizer:singleFingerTap];
    
    singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(dateSelectTapped:)];
    [self.dayDateSelect addGestureRecognizer:singleFingerTap];
}

- (void)periodViewTapped:(UITapGestureRecognizer *)recognizer {
    isPeriod = YES;
    self.dayPeriodBG.backgroundColor = [EJColorLib colorFromHexString:@"#F3D47E"];
    self.dayPeriodLable.textColor = [EJColorLib colorFromHexString:@"#DD3243"];
    self.dayDateBG.backgroundColor = [EJColorLib colorFromHexString:@"#ECCF6F"];
    self.dayDateLable.textColor = [EJColorLib colorFromHexString:@"#444447"];
    
    [_firstView setHidden:NO];
    [_secondView setHidden:YES];
    [self switchSaveButtonStatus];
}

- (void)dateViewTapped:(UITapGestureRecognizer *)recognizer {
    isPeriod = NO;
    self.dayDateBG.backgroundColor = [EJColorLib colorFromHexString:@"#F3D47E"];
    self.dayDateLable.textColor = [EJColorLib colorFromHexString:@"#DD3243"];
    self.dayPeriodBG.backgroundColor = [EJColorLib colorFromHexString:@"#ECCF6F"];
    self.dayPeriodLable.textColor = [EJColorLib colorFromHexString:@"#444447"];
    
    [_secondView setHidden:NO];
    [_firstView setHidden:YES];
    [self switchSaveButtonStatus];
}

- (void)preiodStartTapped:(UITapGestureRecognizer *)recognizer {
    NSDate *date = [NSDate date];
    if (periodStart != nil) date = periodStart;
    [self setCalendarView:YES isRoot:YES targetDate:date];
    NSLog(@"start: %hhd, end: %hhd", isStartDate, isEndDate);
}

- (void)preiodEndTapped:(UITapGestureRecognizer *)recognizer {
    NSDate *date = [NSDate date];
    if (periodEnd != nil) date = periodEnd;
    [self setCalendarView:NO isRoot:YES targetDate:date];
    NSLog(@"start: %hhd, end: %hhd", isStartDate, isEndDate);
}

- (void)dateSelectTapped:(UITapGestureRecognizer *)recognizer {
    NSLog(@"dateSelectTapped");
    NSDate *date = [NSDate date];
    if (oneDay != nil) date = oneDay;
    [self setOneCalendarView:date];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

# pragma mark - Set Calendar

- (PDTSimpleCalendarViewController *)setCalendar{
    PDTSimpleCalendarViewController *calendarViewController = [[PDTSimpleCalendarViewController alloc] init];
    
    // set start Date
    calendarViewController.firstDate = [EJDateLib dateFromString:@"2010-01-01-00-00-00"];
    
    // set last Date
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    offsetComponents.month = 12;
    NSDate *lastDate =[calendarViewController.calendar dateByAddingComponents:offsetComponents toDate:[NSDate date] options:0];
    calendarViewController.lastDate = lastDate;
    
    // show today
    [calendarViewController scrollToDate:[NSDate date] animated:NO];
    
    [calendarViewController setDelegate:self];
    calendarViewController.weekdayHeaderEnabled = YES;
    calendarViewController.weekdayTextType = PDTSimpleCalendarViewWeekdayTextTypeVeryShort;
    calendarViewController.overlayTextColor = [EJColorLib colorFromHexString:@"#F8ECDA"];
    
    return calendarViewController;
}

- (void)setOneCalendarView:(NSDate *)date{
    PDTSimpleCalendarViewController *calendarViewController = [self setCalendar];
    
    [calendarViewController scrollToDate:date animated:NO];
    
    [dayEditNavController setViewControllers:@[calendarViewController] animated:NO];
    
    [calendarViewController setTitle:@"날짜를 골라주세요"];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveSelectedOneDay)];
    calendarViewController.navigationItem.rightBarButtonItem = saveButton;
    calendarViewController.navigationItem.rightBarButtonItem.enabled = oneDay ? YES : NO;
    [self setDayNavigationBar:dayEditNavController];
    [self presentViewController:dayEditNavController animated:YES completion:nil];
}

- (void)setCalendarView:(BOOL)isStart isRoot:(BOOL)isRoot targetDate:(NSDate *)date{
    
    NSLog(@"setCalendarView:isStart %hhd isRoot: %hhd targetDate: %@", isStart, isRoot, date);
    
    PDTSimpleCalendarViewController *calendarViewController = [self setCalendar];

    [calendarViewController scrollToDate:date animated:NO];
    
    if (isRoot) [dayEditNavController setViewControllers:@[calendarViewController] animated:NO];
    
    if (isStart) {
        [calendarViewController setTitle:@"시작일이 언제인가요?"];
        isStartDate = YES;
    } else {
        [calendarViewController setTitle:@"종료일이 언제인가요?"];
        isStartDate = NO;
    }
    
    [self setDayNavigationBar:dayEditNavController];
    
    if (isRoot) [self presentViewController:dayEditNavController animated:YES completion:nil];
    else [dayEditNavController pushViewController:calendarViewController animated:YES];
    
}

- (void)setDayNavigationBar:(UINavigationController *) navigationController {
    navigationController.navigationBar.barTintColor = [EJColorLib colorFromHexString:@"#F18A81"];
    navigationController.navigationBar.tintColor = [EJColorLib colorFromHexString:@"#FCE8E5"];
    [navigationController.navigationBar setTitleTextAttributes:@{
                                                                 NSForegroundColorAttributeName : [EJColorLib colorFromHexString:@"#FCE8E5"],
                                                                 NSFontAttributeName : [UIFont boldSystemFontOfSize:22.0]
                                                                 }];
    
    UIBarButtonItem *stopButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(closeEditDateViewController)];
    [navigationController viewControllers][0].navigationItem.leftBarButtonItem = stopButton;
}

- (void)closeEditDateViewController {
    [dayEditNavController dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveSelectedOneDay {
    NSLog(@"saveSelectedOneDay");
    
    self.dayDateSelect.text = [EJDateLib dayStringFromDate:oneDay];
    
    NSLog(@"self.dayDateSelect.text: %@", self.dayDateSelect.text );
    
    [self switchSaveButtonStatus];
    [dayEditNavController dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveSelectedDate {
    self.dayStartPeriod.text = [EJDateLib dayStringFromDate:periodStart];
    self.dayEndPeriod.text = [EJDateLib dayStringFromDate:periodEnd];

    [self switchSaveButtonStatus];
    [dayEditNavController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - PDTSimpleCalendarViewDelegate

// when date clicked
- (void)simpleCalendarViewController:(PDTSimpleCalendarViewController *)controller didSelectDate:(NSDate *)date {
    NSLog(@"Date Selected : %@", date);
    NSLog(@"Date Selected with Locale %@", [date descriptionWithLocale:[NSLocale systemLocale]]);
    
    if (!isPeriod) {
        oneDay = date;
        [dayEditNavController viewControllers][0].navigationItem.rightBarButtonItem.enabled = YES;
        return;
    }
    
    if (!isStartDate) {
        periodEnd = date;
        if (periodStart == nil) [self setCalendarView:YES isRoot:NO targetDate:date];
    } else {
        periodStart = date;
        
        if (!periodEnd) [self setCalendarView:NO isRoot:NO targetDate:date];
    }
    

    
    UIBarButtonItem *stopButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(closeEditDateViewController)];

    NSArray *viewController = [dayEditNavController viewControllers];
    [dayEditNavController viewControllers][viewController.count - 1].navigationItem.leftBarButtonItem = stopButton;
    
    
    if (periodStart != nil && periodEnd != nil) {
        if ([periodStart compare:periodEnd] == NSOrderedAscending) {
            UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveSelectedDate)];
        
            NSArray *viewControllers = [dayEditNavController viewControllers];
            [dayEditNavController viewControllers][viewControllers.count - 1].navigationItem.rightBarButtonItem = saveButton;
            
        } else {
            NSLog(@"errors in selected dates");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"시작일보다 종료일이 늦어야 해요."
                                                            message:@"날짜를 다시 골라주세요. ㅠㅠ"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
}

- (BOOL)simpleCalendarViewController:(PDTSimpleCalendarViewController *)controller shouldUseCustomColorsForDate:(NSDate *)date {
    
    if (isPeriod && ([periodStart isEqualToDate:date] || [periodEnd isEqualToDate:date])) return YES;
    else if (!isPeriod && [oneDay isEqualToDate:date]) return YES;
    
    return NO;
}

- (UIColor *)simpleCalendarViewController:(PDTSimpleCalendarViewController *)controller circleColorForDate:(NSDate *)date {
    return [EJColorLib colorFromHexString:@"#F0CA48"];
}

- (UIColor *)simpleCalendarViewController:(PDTSimpleCalendarViewController *)controller textColorForDate:(NSDate *)date {
    return [EJColorLib colorFromHexString:@"#464747"];
}
@end
