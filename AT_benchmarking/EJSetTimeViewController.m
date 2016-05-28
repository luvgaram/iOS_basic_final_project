//
//  EJSetTimeViewController.m
//  AT_benchmarking
//
//  Created by Eunjoo Im on 2016. 5. 24..
//  Copyright © 2016년 Jay Im. All rights reserved.
//

#import "EJSetTimeViewController.h"
#import "EJSetTimePickerViewController.h"
#import "EJDateLib.h"
#import "EJColorLib.h"
#import "EJMainViewController.h"
#import "EJNavigationBar.h"
#import "EJDataManager.h"

@interface EJSetTimeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *timeStart;
@property (weak, nonatomic) IBOutlet UITextField *timeTitleTextView;
@property (weak, nonatomic) IBOutlet UILabel *timeEnd;
@property (weak, nonatomic) IBOutlet UIView *timeEdit;

@end

@implementation EJSetTimeViewController

BOOL isNewTime;
NSDate *startTime;
NSDate *endTime;
int timeCharacterNumber;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBar];
    [self setTap];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(timeSelected:) name:@"timeSelected" object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(characterChanged:) name:@"characterChanged" object:nil];
    
    [self setValuesFromData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setValuesFromRecipe];
    [self switchSaveButtonStatus];
}

- (void)setValuesFromData {
    if (self.timeData) {
        // setCharacter
        timeCharacterNumber = self.timeData.character;
        [self postNotiToCharacter:timeCharacterNumber];
        
        self.timeTitleTextView.text = self.timeData.title;
        self.timeStart.text = [EJDateLib simpleHourStringFromDateString:self.timeData.start];
        self.timeEnd.text = [EJDateLib simpleHourStringFromDateString:self.timeData.end];
        isNewTime = NO;
    } else isNewTime = YES;
}

- (void)setValuesFromRecipe {
    if (self.timeTitleFromRecipe) self.timeTitleTextView.text = self.timeTitleFromRecipe;
}

# pragma mark - Notification
- (void)timeSelected:(NSNotification*)notification {
    NSString *startHour = notification.userInfo[@"startHour"];
    NSString *startMinute = notification.userInfo[@"startMinute"];
    NSString *endHour = notification.userInfo[@"endHour"];
    NSString *endMinute = notification.userInfo[@"endMinute"];
    
    startTime = [EJDateLib dateFromHour:[startHour intValue] Minite:[startMinute intValue]];
    endTime = [EJDateLib dateFromHour:[endHour intValue] Minite:[endMinute intValue]];
    
    NSLog(@"startTime: %@, endTime: %@", [EJDateLib stringFromDate:startTime], [EJDateLib stringFromDate:endTime]);
    
    // convert time
    if ([startTime compare:[NSDate date]] == NSOrderedDescending) {
        NSLog(@"startTime > now");
        startTime = [startTime dateByAddingTimeInterval: - (60 * 60 * 24 * 1)];
    }
    
    if ([[NSDate date] compare:endTime] == NSOrderedDescending) {
        NSLog(@"now > endTime");
        endTime = [endTime dateByAddingTimeInterval:60 * 60 * 24 * 1];
    }
    
    NSLog(@"startTime: %@, endTime: %@", [EJDateLib stringFromDate:startTime], [EJDateLib stringFromDate:endTime]);
    
    self.timeStart.text = [EJDateLib simpleHourStringFromDate:startTime];
    self.timeEnd.text = [EJDateLib simpleHourStringFromDate:endTime];
    
    [self switchSaveButtonStatus];
}

#pragma mark - Notification
- (void)characterChanged:(NSNotification*)notification {
    timeCharacterNumber = [notification.userInfo[@"characterNumber"] intValue];
    NSLog(@"character: %d", timeCharacterNumber);
}

- (void)postNotiToMain {
    NSNotification *notification = [NSNotification notificationWithName:@"addData" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    [[self navigationController] popToRootViewControllerAnimated:YES];
}

- (void)postNotiToCharacter:(int)characterIndex {
    NSDictionary *userinfo = @{@"characterIndex" : [NSNumber numberWithInt:characterIndex]};
    NSNotification *notification = [NSNotification notificationWithName:@"setCharacter" object:self userInfo:userinfo];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
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
    BOOL isTimeTitleInserted = (self.timeTitleTextView.text.length > 0) ? YES : NO;
    
    NSLog(@"isTitleInserted: %hhd, sdate: %d, edate: %d", isTimeTitleInserted, startTime != nil, endTime != nil);
    if (isTimeTitleInserted && startTime != nil && endTime != nil) self.navigationItem.rightBarButtonItem.enabled = YES;
    else self.navigationItem.rightBarButtonItem.enabled = NO;
    
}

# pragma mark - tap gesture
- (void)setTap {
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(timeLabelTapped)];
    [self.timeEdit addGestureRecognizer:singleFingerTap];
}

- (void)timeLabelTapped {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EJSetTimePickerViewController *timePickerViewController = [storyboard instantiateViewControllerWithIdentifier:@"setTimePickerControllerIdentifier"];
    
    UINavigationController *timeEditNavController = [[UINavigationController alloc] initWithNavigationBarClass:[EJNavigationBar class] toolbarClass:nil];

    [timeEditNavController setViewControllers:@[timePickerViewController] animated:NO];
    
    [self presentViewController:timeEditNavController animated:YES completion:nil];
}

- (IBAction)timeTitleTextEdited:(id)sender {
    [self switchSaveButtonStatus];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

# pragma mark - data save
- (void)saveDate {
    EJRealmData *newData;
    EJDataManager *dataManager = [EJDataManager sharedInstance];
    
    newData = [[EJRealmData alloc] initWithValue:@{
                                                   @"id" : @([dataManager getIdManager]),
                                                   @"type" : @(0),
                                                   @"character" : @(timeCharacterNumber ),
                                                   @"title" : self.timeTitleTextView.text,
                                                   @"date" : [NSDate date],
                                                   @"start" : [EJDateLib stringFromDate:startTime],
                                                   @"end" : [EJDateLib stringFromDate:endTime]
                                                   }];

    if (isNewTime) [self addDataToMainViewController:newData];
    else [self modifyDataToMainViewController:newData];
}

- (void)addDataToMainViewController:(EJRealmData *) newData {
    EJDataManager *dataManager = [EJDataManager sharedInstance];
    [dataManager addData:newData];
    
    [self postNotiToMain];
}

- (void)modifyDataToMainViewController:(EJRealmData *) newData {
    EJDataManager *dataManager = [EJDataManager sharedInstance];
    EJRealmData *updateData = [[EJRealmData alloc] initWithValue:@{
                                                                   @"id" : @(self.timeData.id),
                                                                   @"type" : @(newData.type),
                                                                   @"character" : @(newData.character),
                                                                   @"title" : newData.title,
                                                                   @"date" : [NSDate date],
                                                                   @"start" : newData.start,
                                                                   @"end" : newData.end
                                                                   }];
    
    [dataManager updateData:updateData];
    [self postNotiToMain];
}

@end
