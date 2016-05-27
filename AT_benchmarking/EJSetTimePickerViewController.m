//
//  EJSetTimePickerViewController.m
//  AT_benchmarking
//
//  Created by Eunjoo Im on 2016. 5. 25..
//  Copyright © 2016년 Jay Im. All rights reserved.
//

#import "EJSetTimePickerViewController.h"
#import "ESTimePicker.h"
#import "EJFlowTouchView.h"
#import "EJColorLib.h"

@interface EJSetTimePickerViewController ()
@property (weak, nonatomic) IBOutlet UIView *startTimeView;
@property (weak, nonatomic) IBOutlet UIView *endTimeView;
@property (weak, nonatomic) IBOutlet UILabel *startTimeHourLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeMinuteLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeHourLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeMinuteLabel;

@end

@implementation EJSetTimePickerViewController

BOOL isStart;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [EJColorLib colorFromHexString:@"#F18A81"];
    self.navigationController.navigationBar.tintColor = [EJColorLib colorFromHexString:@"#FCE8E5"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                 NSForegroundColorAttributeName : [EJColorLib colorFromHexString:@"#FCE8E5"],
                                                                 NSFontAttributeName : [UIFont boldSystemFontOfSize:22.0]
                                                                 }];
    self.title = @"시간을 선택해 주세요!";
    [self setPickers];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveSelectedTime)];
    self.navigationItem.rightBarButtonItem = saveButton;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    UIBarButtonItem *stopButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(closeEditTimeViewController)];
    self.navigationItem.leftBarButtonItem = stopButton;
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(timePickerClicked:) name:@"timePickerClicked" object:nil];
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

- (void)closeEditTimeViewController {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Notification
- (void)timePickerClicked:(NSNotification*)notification {
    isStart = [notification.userInfo[@"isStart"] boolValue];
    NSLog(@"isStart: %hhd", isStart);
}

- (void)setPickers {
    float viewSize = self.view.frame.size.height;
    float pickerSize = (viewSize - 120.0) / 2.0;
    
    NSLog(@"origin, %f, %f, size: %f, %f, picker: %f", self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height, pickerSize);
    
    ESTimePicker *startTimePicker = [[ESTimePicker alloc] initWithDelegate:self];
    
    [startTimePicker setFrame:CGRectMake((self.view.frame.size.width - pickerSize) / 2.0, 10, pickerSize, pickerSize)];
    [self.startTimeView addSubview:startTimePicker];
    
    EJFlowTouchView *startTouchView = [[EJFlowTouchView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height / 2)];
    [startTouchView setBackgroundColor:[UIColor clearColor]];
    startTouchView.timePicker = startTimePicker;
    startTouchView.isStart = YES;
    
    [self.startTimeView addSubview:startTouchView];
    
    ESTimePicker *endTimePicker = [[ESTimePicker alloc] initWithDelegate:self];
    
    [endTimePicker setFrame:CGRectMake((self.view.frame.size.width - pickerSize) / 2.0, 10, pickerSize, pickerSize)];
    [self.endTimeView addSubview:endTimePicker];
    
    EJFlowTouchView *endTouchView = [[EJFlowTouchView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height / 2)];
    [endTouchView setBackgroundColor:[UIColor clearColor]];
    endTouchView.timePicker = endTimePicker;
    endTouchView.isStart = NO;
    
    [self.endTimeView addSubview:endTouchView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - data save
- (void)saveSelectedTime {
    NSDictionary* userInfo = @{@"startHour": self.startTimeHourLabel.text,
                               @"startMinute": self.startTimeMinuteLabel.text,
                               @"endHour": self.endTimeHourLabel.text,
                               @"endMinute": self.endTimeMinuteLabel.text};
    
    NSNotification *notification = [NSNotification notificationWithName:@"timeSelected" object:self userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)switchSaveButtonStatus {
    if (![self.startTimeHourLabel.text isEqualToString:@"시"] &&
        ![self.startTimeMinuteLabel.text isEqualToString:@"분"] &&
        ![self.endTimeHourLabel.text isEqualToString:@"시"] &&
        ![self.startTimeHourLabel.text isEqualToString:@"분"]) {
        self.title = @"잘 했어요!";
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else self.navigationItem.rightBarButtonItem.enabled = NO;
}

#pragma mark - timePicker
- (void)timePickerHoursChanged:(ESTimePicker *)timePicker toHours:(int)hour {
    if (isStart) self.startTimeHourLabel.text = [NSString stringWithFormat:@"%d", hour];
    else self.endTimeHourLabel.text = [NSString stringWithFormat:@"%d", hour];
    
    [self switchSaveButtonStatus];
}

- (void)timePickerMinutesChanged:(ESTimePicker *)timePicker toMinutes:(int)minute {
    if (isStart) self.startTimeMinuteLabel.text = [NSString stringWithFormat:@"%d", minute];
    else self.endTimeMinuteLabel.text = [NSString stringWithFormat:@"%d", minute];
    
    [self switchSaveButtonStatus];
}
@end
