//
//  EJRecipeViewController.m
//  AT_benchmarking
//
//  Created by Eunjoo Im on 2016. 5. 26..
//  Copyright © 2016년 Jay Im. All rights reserved.
//

#import "EJRecipeViewController.h"
#import "EJColorLib.h"
#import "EJSetDayViewController.h"
#import "EJSetTimeViewController.h"
#import "EJSetCustomViewController.h"
#import "EJSelectCharacterViewController.h"

@interface EJRecipeViewController ()
@property (weak, nonatomic) IBOutlet UIView *recipeTest;
@property (weak, nonatomic) IBOutlet UIView *recipeLove;
@property (weak, nonatomic) IBOutlet UIView *recipeExcersize;
@property (weak, nonatomic) IBOutlet UIView *recipeDiet;
@property (weak, nonatomic) IBOutlet UIView *recipeToday;
@property (weak, nonatomic) IBOutlet UIView *recipeWeek;
@property (weak, nonatomic) IBOutlet UIView *recipeMonth;
@property (weak, nonatomic) IBOutlet UIView *recipeYear;
@property (weak, nonatomic) IBOutlet UIView *recipeLife;

@end

@implementation EJRecipeViewController

// type 0: hour 1: day 2: week 3: month 4: year 5: anniversary 6:custom 7: today
enum {hour = 0, day = 1, week, month, year, anniversary, custom, today} EJRecipetype;
UIStoryboard *mainStoryboard;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBar];
    [self setTap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - navigation bar
- (void)setNavigationBar {
    self.navigationController.navigationBar.barTintColor = [EJColorLib colorFromHexString:@"#F8ECDA"];
    self.navigationController.navigationBar.tintColor = [EJColorLib colorFromHexString:@"#DD3243"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSForegroundColorAttributeName : [EJColorLib colorFromHexString:@"#DD3243"],
                                                                      NSFontAttributeName : [UIFont boldSystemFontOfSize:24.0]
                                                                      }];
    self.title = @"+AT";
}

# pragma mark - tap gesture
- (void)setTap {
    mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(recipeTestTapped)];
    [self.recipeTest addGestureRecognizer:singleFingerTap];
    
    singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(recipeLoveTapped)];
    [self.recipeLove addGestureRecognizer:singleFingerTap];
    
    singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(recipeExcersizeTapped)];
    [self.recipeExcersize addGestureRecognizer:singleFingerTap];
    
    singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(recipeDietTapped)];
    [self.recipeDiet addGestureRecognizer:singleFingerTap];
    
    singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(recipeTodayTapped)];
    [self.recipeToday addGestureRecognizer:singleFingerTap];
    
    singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(recipeWeekTapped)];
    [self.recipeWeek addGestureRecognizer:singleFingerTap];
    
    singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(recipeMonthTapped)];
    [self.recipeMonth addGestureRecognizer:singleFingerTap];
    
    singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(recipeYearTapped)];
    [self.recipeYear addGestureRecognizer:singleFingerTap];
    
    singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(recipeLifeTapped)];
    [self.recipeLife addGestureRecognizer:singleFingerTap];
}

- (void)recipeTestTapped {
    EJSetDayViewController *dayViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"setDayViewControllerIdentifier"];
    dayViewController.dayTitleFromRecipe = @"시험";
    
    [self.navigationController pushViewController:dayViewController animated:YES];
}

- (void)recipeLoveTapped {
    EJSetDayViewController *dayViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"setDayViewControllerIdentifier"];
    dayViewController.dayTitleFromRecipe = @"♥";
    dayViewController.dateTypeFromRecipe = YES;
    
    [self.navigationController pushViewController:dayViewController animated:YES];
}

- (void)recipeExcersizeTapped {
    EJSetTimeViewController *timeViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"setTimeViewControllerIdentifier"];
    timeViewController.timeTitleFromRecipe = @"운동시간";
    
    [self.navigationController pushViewController:timeViewController animated:YES];
    
}

- (void)recipeDietTapped {
    EJSetCustomViewController *customViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"setCustomViewControllerIdentifier"];
    customViewController.customTitleFromRecipe = @"다이어트";
    customViewController.customUnitFromRecipe = @"kg";
    
    [self.navigationController pushViewController:customViewController animated:YES];
}

- (void)recipeTodayTapped {
    NSLog(@"recipeTodayTapped");
    
    EJSelectCharacterViewController *characterViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"setSelectCharacterViewControllerIdentifier"];
    characterViewController.typeFromRecipe = today;
    
    [self.navigationController pushViewController:characterViewController animated:YES];
}

- (void)recipeWeekTapped {
    NSLog(@"recipeWeekTapped");
    
    EJSelectCharacterViewController *characterViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"setSelectCharacterViewControllerIdentifier"];
    characterViewController.typeFromRecipe = week;
    
    [self.navigationController pushViewController:characterViewController animated:YES];
}

- (void)recipeMonthTapped {
    NSLog(@"recipeMonthTapped");
    
    EJSelectCharacterViewController *characterViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"setSelectCharacterViewControllerIdentifier"];
    characterViewController.typeFromRecipe = month;
    
    [self.navigationController pushViewController:characterViewController animated:YES];
}

- (void)recipeYearTapped {
    NSLog(@"recipeYearTapped");
    
    EJSelectCharacterViewController *characterViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"setSelectCharacterViewControllerIdentifier"];
    characterViewController.typeFromRecipe = year;
    
    [self.navigationController pushViewController:characterViewController animated:YES];
}

- (void)recipeLifeTapped {
    NSLog(@"recipeLifeTapped");

    EJSetCustomViewController *customViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"setCustomViewControllerIdentifier"];
    customViewController.customTitleFromRecipe = @"일생";
    customViewController.customUnitFromRecipe = @"세";
    
    [self.navigationController pushViewController:customViewController animated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
