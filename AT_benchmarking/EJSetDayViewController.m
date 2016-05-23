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
@property (weak, nonatomic) IBOutlet UITextField *dayTitleTextView;
@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *daySegmentControl;
@property (weak, nonatomic) IBOutlet UIButton *dayPeriodButton;
@property (weak, nonatomic) IBOutlet UIButton *dayDayButton;
@property (weak, nonatomic) IBOutlet UIView *dayPeriodBG;
@property (weak, nonatomic) IBOutlet UIView *dayDateBG;
@property (weak, nonatomic) IBOutlet UILabel *dayPeriodLable;
@property (weak, nonatomic) IBOutlet UILabel *dayDateLable;
@property (weak, nonatomic) IBOutlet UILabel *dayStartPeriod;
@property (weak, nonatomic) IBOutlet UILabel *dayEndPeriod;

@property (nonatomic, strong) NSMutableArray *customDates;
@end

@implementation EJSetDayViewController

UINavigationController *dayEditNavController;

BOOL isTitleInserted;
BOOL isStartDate;
BOOL isEndDate;
int dayType;
NSString* dayTitle;

- (IBAction)dayTitleTextViewClicked:(id)sender {
    if (self.dayTitleTextView.text.length > 0)
        isTitleInserted = YES;
    else isTitleInserted = NO;
    
    NSLog(@"textview: %hhd, %d", isTitleInserted, self.dayTitleTextView.text.length);
    [self swichSaveButtonStatus];
}

- (void)swichSaveButtonStatus {
    NSLog(@"isTitleInserted: %hhd, sdate: %d, edate: %d", isTitleInserted, ![_customDates[0] isKindOfClass:[NSNull class]], ![_customDates[1] isKindOfClass:[NSNull class]]);
    
    if (isTitleInserted &&
        ![_customDates[0] isKindOfClass:[NSNull class]] &&
        ![_customDates[1] isKindOfClass:[NSNull class]])
        self.navigationItem.rightBarButtonItem.enabled = YES;
    else self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (IBAction)periodButtonClicked:(id)sender {
    _dayPeriodButton.backgroundColor = [EJColorLib colorFromHexString:@"#F2DB85"];
    [_dayPeriodButton setTitleColor:[EJColorLib colorFromHexString:@"#DD3243"] forState:UIControlStateNormal];
    _dayPeriodButton.titleLabel.textColor = [EJColorLib colorFromHexString:@"#DD3243"];
    _dayDayButton.backgroundColor = [EJColorLib colorFromHexString:@"#ECCF6F"];
    [_dayDayButton setTitleColor:[EJColorLib colorFromHexString:@"#444447"] forState:UIControlStateNormal];
    [_firstView setHidden:NO];
    [_secondView setHidden:YES];
}

- (IBAction)dayButtonClicked:(id)sender {
    _dayDayButton.backgroundColor = [EJColorLib colorFromHexString:@"#F2DB85"];
    [_dayDayButton setTitleColor:[EJColorLib colorFromHexString:@"#DD3243"] forState:UIControlStateNormal];
    _dayPeriodButton.backgroundColor = [EJColorLib colorFromHexString:@"#ECCF6F"];
    [_dayPeriodButton setTitleColor:[EJColorLib colorFromHexString:@"#444447"] forState:UIControlStateNormal];

    [_firstView setHidden:YES];
    [_secondView setHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBar];
    [self setTap];
    
    self.customDates = [[NSMutableArray alloc] initWithCapacity:2];
    _customDates[0] = [NSNull null];
    _customDates[1] = [NSNull null];
    
    isStartDate = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    dayEditNavController = [[UINavigationController alloc] initWithNavigationBarClass:[EJNavigationBar class] toolbarClass:nil];
}

// change navigation bar style
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

- (void)saveDate {
    EJData *newData = [[EJData alloc] initWithType:1 character:1 title:self.dayTitleTextView.text start:[EJDateLib stringFromDate:_customDates[0]] end:[EJDateLib stringFromDate:_customDates[1]]];
    [self addDataToMainViewController:newData];
}

- (void)addDataToMainViewController:(EJData *) newData {
    EJMainViewController *mainViewController = (EJMainViewController *)[self.navigationController.viewControllers objectAtIndex:0];
    [mainViewController.dataArray addObject:newData];
    
    NSNotification *notification = [NSNotification notificationWithName:@"addData" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    [[self navigationController] popToRootViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

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
    
    calendarViewController.backgroundColor = [EJColorLib colorFromHexString:@"#F8ECDA"];
    calendarViewController.overlayTextColor = [EJColorLib colorFromHexString:@"#F8ECDA"];
    
    return calendarViewController;
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
                                            action:@selector(preiodStartViewTapped:)];
    [self.dayStartPeriod addGestureRecognizer:singleFingerTap];
    
    singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(preiodEndViewTapped:)];
    [self.dayEndPeriod addGestureRecognizer:singleFingerTap];
}

- (void)periodViewTapped:(UITapGestureRecognizer *)recognizer {
    self.dayPeriodBG.backgroundColor = [EJColorLib colorFromHexString:@"#F3D47E"];
    self.dayPeriodLable.textColor = [EJColorLib colorFromHexString:@"#DD3243"];
    self.dayDateBG.backgroundColor = [EJColorLib colorFromHexString:@"#ECCF6F"];
    self.dayDateLable.textColor = [EJColorLib colorFromHexString:@"#444447"];
    
    [_firstView setHidden:NO];
    [_secondView setHidden:YES];
}

- (void)dateViewTapped:(UITapGestureRecognizer *)recognizer {
    self.dayDateBG.backgroundColor = [EJColorLib colorFromHexString:@"#F3D47E"];
    self.dayDateLable.textColor = [EJColorLib colorFromHexString:@"#DD3243"];
    self.dayPeriodBG.backgroundColor = [EJColorLib colorFromHexString:@"#ECCF6F"];
    self.dayPeriodLable.textColor = [EJColorLib colorFromHexString:@"#444447"];
    
    [_secondView setHidden:NO];
    [_firstView setHidden:YES];
}

- (void)preiodStartViewTapped:(UITapGestureRecognizer *)recognizer {
    NSDate *date = [NSDate date];
    if (![_customDates[0] isKindOfClass:[NSNull class]]) date = _customDates[0];
    [self setCalendarView:YES isRoot:YES targetDate:date];
    NSLog(@"start: %hhd, end: %hhd", isStartDate, isEndDate);
}

- (void)preiodEndViewTapped:(UITapGestureRecognizer *)recognizer {
    NSDate *date = [NSDate date];
    if (![_customDates[1] isKindOfClass:[NSNull class]]) date = _customDates[1];
    [self setCalendarView:NO isRoot:YES targetDate:date];
    NSLog(@"start: %hhd, end: %hhd", isStartDate, isEndDate);
}

- (void)setCalendarView:(BOOL)isStart isRoot:(BOOL)isRoot targetDate:(NSDate *)date{
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
    
//    if ([_customDates[0] isKindOfClass:[NSNull class]]) {
//        NSLog(@"start date is null");
//    }
//    
//    if ([_customDates[1] isKindOfClass:[NSNull class]]) {
//        NSLog(@"end date is null");
//    }
    
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

- (void)saveSelectedDate {
    self.dayStartPeriod.text = [EJDateLib dayStringFromDate:_customDates[0]];
    self.dayEndPeriod.text = [EJDateLib dayStringFromDate:_customDates[1]];

    [self swichSaveButtonStatus];
    [dayEditNavController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - PDTSimpleCalendarViewDelegate

- (void)simpleCalendarViewController:(PDTSimpleCalendarViewController *)controller didSelectDate:(NSDate *)date {
    NSLog(@"Date Selected : %@", date);
    NSLog(@"Date Selected with Locale %@", [date descriptionWithLocale:[NSLocale systemLocale]]);
    
    if (!isStartDate) {
        _customDates[1] = date;
        if ([_customDates[0] isKindOfClass:[NSNull class]]) [self setCalendarView:YES isRoot:NO targetDate:date];
    } else {
        _customDates[0] = date;
        [self setCalendarView:NO isRoot:NO targetDate:date];
    }
    
    UIBarButtonItem *stopButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(closeEditDateViewController)];
    [dayEditNavController viewControllers][1].navigationItem.leftBarButtonItem = stopButton;
    
    if (![_customDates[0] isKindOfClass:[NSNull class]] &&
        ![_customDates[1] isKindOfClass:[NSNull class]]) {
        if ([_customDates[0] compare:_customDates[1]] == NSOrderedAscending) {
        UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveSelectedDate)];
        
        [dayEditNavController viewControllers][1].navigationItem.rightBarButtonItem = refreshButton;
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
    if ([self.customDates containsObject:date]) {
        return YES;
    }
    
    return NO;
}

- (UIColor *)simpleCalendarViewController:(PDTSimpleCalendarViewController *)controller circleColorForDate:(NSDate *)date {
    return [EJColorLib colorFromHexString:@"#F0CA48"];
}

- (UIColor *)simpleCalendarViewController:(PDTSimpleCalendarViewController *)controller textColorForDate:(NSDate *)date {
    return [EJColorLib colorFromHexString:@"#464747"];
}
@end
