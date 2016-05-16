//
//  EJAddViewController.m
//  AT_benchmarking
//
//  Created by Eunjoo Im on 2016. 5. 16..
//  Copyright © 2016년 Jay Im. All rights reserved.
//

#import "EJMainViewController.h"
#import "EJAddViewController.h"
#import "EJData.h"

@interface EJAddViewController ()
@property (weak, nonatomic) IBOutlet UIView *dayView;
@property (weak, nonatomic) IBOutlet UIView *timeView;
@property (weak, nonatomic) IBOutlet UIView *customView;
@property (weak, nonatomic) IBOutlet UIView *recipeView;

@end

@implementation EJAddViewController

// type 0: hour 1: day 2: week 3: month 4: year 5: life, 6: custom
typedef enum {hour, day = 1, week, month, year, life, custom} MyType;

- (void)viewDidLoad {
    [super viewDidLoad];

    // change navigation bar style
    self.navigationController.navigationBar.barTintColor = [self colorFromHexString:@"#F8ECDA"];
    self.navigationController.navigationBar.tintColor = [self colorFromHexString:@"#DD3243"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSForegroundColorAttributeName : [self colorFromHexString:@"#DD3243"],
                                                                      NSFontAttributeName : [UIFont boldSystemFontOfSize:24.0]
                                                                      }];
    self.title = @"+AT";
    
    [self setTap];
}

# pragma mark - tap gesture
- (void)setTap {
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(dayViewTapped:)];
    [self.dayView addGestureRecognizer:singleFingerTap];
    
    singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(timeViewTapped:)];
    [self.timeView addGestureRecognizer:singleFingerTap];
    
    singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(customViewTapped:)];
    [self.customView addGestureRecognizer:singleFingerTap];
    
    singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(recipeViewTapped:)];
    [self.recipeView addGestureRecognizer:singleFingerTap];
}

- (void)dayViewTapped:(UITapGestureRecognizer *)recognizer {
    NSLog(@"dayViewTapped");
    MyType type = day;
    NSString *start = @"2016-05-10-00-00-00";
    NSString *end = @"2016-05-20-00-00-00";
    
    EJData *newData = [[EJData alloc] initWithType:type character:1 title:@"날짜" start:start end:end];
    
    [self addDataToMainViewController:newData];
}

- (void)timeViewTapped:(UITapGestureRecognizer *)recognizer {
    NSLog(@"timeViewTapped");
    MyType type = hour;
    NSString *start = @"2016-04-10-00-00-00";
    NSString *end = @"2016-05-18-00-00-00";
    
    EJData *newData = [[EJData alloc] initWithType:type character:1 title:@"시간" start:start end:end];
    
    [self addDataToMainViewController:newData];
}

- (void)customViewTapped:(UITapGestureRecognizer *)recognizer {
    NSLog(@"customViewTapped");
}

- (void)recipeViewTapped:(UITapGestureRecognizer *)recognizer {
    NSLog(@"recipeViewTapped");
}

- (void)addDataToMainViewController:(EJData *) newData {
    EJMainViewController *mainViewController = [self backViewController];
    [mainViewController.dataArray addObject:newData];
    
    NSNotification *notification = [NSNotification notificationWithName:@"addData" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
        
    [[self navigationController] popToRootViewControllerAnimated:YES];
}

- (UIViewController *)backViewController {
    NSInteger numberOfViewControllers = self.navigationController.viewControllers.count;
    
    if (numberOfViewControllers < 2)
        return nil;
    else
        return [self.navigationController.viewControllers objectAtIndex:numberOfViewControllers - 2];
}

#pragma mark - color library

- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

@end
