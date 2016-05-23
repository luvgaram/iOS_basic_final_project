//
//  EJSetDayViewController.m
//  AT_benchmarking
//
//  Created by Eunjoo Im on 2016. 5. 17..
//  Copyright © 2016년 Jay Im. All rights reserved.
//

#import "EJSetDayViewController.h"
#import "EJColorLib.h"
#import "PDTSimpleCalendarViewController.h"
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
BOOL isStartDate;
BOOL isEndDate;

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

// change navigation bar style
- (void)setNavigationBar {
    self.navigationController.navigationBar.barTintColor = [EJColorLib colorFromHexString:@"#F8ECDA"];
    self.navigationController.navigationBar.tintColor = [EJColorLib colorFromHexString:@"#DD3243"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSForegroundColorAttributeName : [EJColorLib colorFromHexString:@"#DD3243"],
                                                                      NSFontAttributeName : [UIFont boldSystemFontOfSize:24.0]
                                                                      }];
    self.title = @"+AT";
}

- (void)viewWillAppear:(BOOL)animated {
    dayEditNavController = [[UINavigationController alloc] initWithNavigationBarClass:[EJNavigationBar class] toolbarClass:nil];
}

- (PDTSimpleCalendarViewController *)setCalendar{
    PDTSimpleCalendarViewController *calendarViewController = [[PDTSimpleCalendarViewController alloc] init];
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
    [self setCalendarView:YES isRoot:YES];
    NSLog(@"start: %hhd, end: %hhd", isStartDate, isEndDate);
}

- (void)preiodEndViewTapped:(UITapGestureRecognizer *)recognizer {
    [self setCalendarView:NO isRoot:YES];
    NSLog(@"start: %hhd, end: %hhd", isStartDate, isEndDate);
}

- (void)setCalendarView:(BOOL)isStart isRoot:(BOOL)isRoot {
    PDTSimpleCalendarViewController *calendarViewController = [self setCalendar];
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
    [dayEditNavController dismissModalViewControllerAnimated:YES];
}

#pragma mark - PDTSimpleCalendarViewDelegate

- (void)simpleCalendarViewController:(PDTSimpleCalendarViewController *)controller didSelectDate:(NSDate *)date {
    NSLog(@"Date Selected : %@", date);
    NSLog(@"Date Selected with Locale %@", [date descriptionWithLocale:[NSLocale systemLocale]]);
    
    if (!isStartDate) {
        _customDates[1] = date;
        if ([_customDates[0] isKindOfClass:[NSNull class]]) [self setCalendarView:YES isRoot:NO];
    } else {
        _customDates[0] = date;
        [self setCalendarView:NO isRoot:NO];
    }
    
    if (![_customDates[0] isKindOfClass:[NSNull class]] && ![_customDates[1] isKindOfClass:[NSNull class]]) {
        UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(temp)];
        
        [dayEditNavController.viewControllers objectAtIndex:1].navigationItem.rightBarButtonItem = refreshButton;
    }
}

- (void)temp {
    NSLog(@"temp!");
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
