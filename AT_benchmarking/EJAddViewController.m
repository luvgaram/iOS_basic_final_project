//
//  EJAddViewController.m
//  AT_benchmarking
//
//  Created by Eunjoo Im on 2016. 5. 16..
//  Copyright © 2016년 Jay Im. All rights reserved.
//

#import "EJMainViewController.h"
#import "EJAddViewController.h"
#import "EJDataManager.h"
#import "EJColorLib.h"

@interface EJAddViewController ()
@property (weak, nonatomic) IBOutlet UIView *dayView;
@property (weak, nonatomic) IBOutlet UIView *timeView;
@property (weak, nonatomic) IBOutlet UIView *customView;
@property (weak, nonatomic) IBOutlet UIView *recipeView;

@end

@implementation EJAddViewController

UIStoryboard *storyboard;

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
    storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
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

    UIViewController *addViewController = [storyboard instantiateViewControllerWithIdentifier:@"setDayViewControllerIdentifier"];
    [self.navigationController pushViewController:addViewController animated:YES];
    
}

- (void)timeViewTapped:(UITapGestureRecognizer *)recognizer {
    NSLog(@"timeViewTapped");

    UIViewController *addViewController = [storyboard instantiateViewControllerWithIdentifier:@"setTimeViewControllerIdentifier"];
    [self.navigationController pushViewController:addViewController animated:YES];
}

- (void)customViewTapped:(UITapGestureRecognizer *)recognizer {
    NSLog(@"customViewTapped");
    
    UIViewController *addViewController = [storyboard instantiateViewControllerWithIdentifier:@"setCustomViewControllerIdentifier"];
    [self.navigationController pushViewController:addViewController animated:YES];
}

- (void)recipeViewTapped:(UITapGestureRecognizer *)recognizer {
    NSLog(@"recipeViewTapped");
    
    UIViewController *addViewController = [storyboard instantiateViewControllerWithIdentifier:@"setRecipeViewControllerIdentifier"];
    [self.navigationController pushViewController:addViewController animated:YES];
}

- (UIViewController *)backViewController {
    NSInteger numberOfViewControllers = self.navigationController.viewControllers.count;
    
    if (numberOfViewControllers < 2)
        return nil;
    else
        return [self.navigationController.viewControllers objectAtIndex:numberOfViewControllers - 2];
}

@end
