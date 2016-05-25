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
#import "EJColorLib.h"

@interface EJAddViewController ()
@property (weak, nonatomic) IBOutlet UIView *dayView;
@property (weak, nonatomic) IBOutlet UIView *timeView;
@property (weak, nonatomic) IBOutlet UIView *customView;
@property (weak, nonatomic) IBOutlet UIView *recipeView;

@end

@implementation EJAddViewController

// type 0: hour 1: day 2: week 3: month 4: year 5: life, 6: anniversary 7: custom
typedef enum {hour = 0, day = 1, week, month, year, life, anniversary, custom} MyType;

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNavigationBar];
    [self setTap];
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

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:nil action:nil];
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
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *addViewController = [storyboard instantiateViewControllerWithIdentifier:@"setDayViewControllerIdentifier"];
    [self.navigationController pushViewController:addViewController animated:YES];
    
}

- (void)timeViewTapped:(UITapGestureRecognizer *)recognizer {
    NSLog(@"timeViewTapped");

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *addViewController = [storyboard instantiateViewControllerWithIdentifier:@"setTimeViewControllerIdentifier"];
    [self.navigationController pushViewController:addViewController animated:YES];
}

- (void)customViewTapped:(UITapGestureRecognizer *)recognizer {
    NSLog(@"customViewTapped");
    MyType type = custom;
    NSString *start = @"44.346";
    NSString *end = @"26.234";
    NSString *now = @"32.23";
    
    NSString *unit = @"kg";
    
    EJData *newData = [[EJData alloc] initWithType:type character:1 title:@"커스텀테스트" date:[NSDate date] start:start end:end now:now unit:unit];
    
    [self addDataToMainViewController:newData];
}

- (void)recipeViewTapped:(UITapGestureRecognizer *)recognizer {
    NSLog(@"recipeViewTapped");
}

- (void)addDataToMainViewController:(EJData *) newData {
    EJMainViewController *mainViewController = (EJMainViewController *)[self backViewController];
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

@end
