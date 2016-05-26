//
//  EJSetCustomViewController.m
//  AT_benchmarking
//
//  Created by Eunjoo Im on 2016. 5. 26..
//  Copyright © 2016년 Jay Im. All rights reserved.
//

#import "EJSetCustomViewController.h"
#import "EJColorLib.h"
#import "EJData.h"
#import "EJDateLib.h"
#import "EJMainViewController.h"

@interface EJSetCustomViewController ()
@property (weak, nonatomic) IBOutlet UITextField *customTitleTextView;
@property (weak, nonatomic) IBOutlet UITextField *customStart;
@property (weak, nonatomic) IBOutlet UITextField *customCurrent;
@property (weak, nonatomic) IBOutlet UITextField *customEnd;
@property (weak, nonatomic) IBOutlet UITextField *customUnit;

@end

@implementation EJSetCustomViewController

BOOL isCustomTitleInserted;
BOOL isCustomStartInserted;
BOOL isCustomCurrentInserted;
BOOL isCustomEndInserted;
BOOL isCustomUnitInserted;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBar];
    
    self.customStart.keyboardType = UIKeyboardTypeDecimalPad;
    self.customCurrent.keyboardType = UIKeyboardTypeDecimalPad;
    self.customEnd.keyboardType = UIKeyboardTypeDecimalPad;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setValuesFromRecipe];
    [self switchSaveButtonStatus];
}

- (void)setValuesFromRecipe {
    if (self.customTitleFromRecipe) self.customTitleTextView.text = self.customTitleFromRecipe;
    if (self.customUnitFromRecipe) self.customUnit.text = self.customUnitFromRecipe;
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
    isCustomTitleInserted = (self.customTitleTextView.text.length > 0) ? YES : NO;
    isCustomStartInserted = (self.customStart.text.length > 0) ? YES : NO;
    isCustomCurrentInserted = (self.customCurrent.text.length > 0) ? YES : NO;
    isCustomEndInserted = (self.customEnd.text.length > 0) ? YES : NO;
    isCustomUnitInserted = (self.customUnit.text.length > 0) ? YES : NO;
    
    if (isCustomTitleInserted && isCustomStartInserted && isCustomCurrentInserted && isCustomEndInserted && isCustomUnitInserted) self.navigationItem.rightBarButtonItem.enabled = YES;
    else self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (IBAction)customTitleTextEdited:(id)sender {
    [self switchSaveButtonStatus];
}
- (IBAction)customStartTextEdited:(id)sender {
    [self switchSaveButtonStatus];
}
- (IBAction)customCurrentTextEdited:(id)sender {
    [self switchSaveButtonStatus];
}
- (IBAction)customEndTextEdited:(id)sender {
    [self switchSaveButtonStatus];
}
- (IBAction)customUnitTextEdited:(id)sender {
    [self switchSaveButtonStatus];
}

# pragma mark - data save
- (void)saveDate {
    EJData *newData = [[EJData alloc] initWithType:7 character:1 title:self.customTitleTextView.text date:[NSDate date] start:self.customStart.text end:self.customEnd.text now:self.customCurrent.text unit:self.customUnit.text];
    
    [self addDataToMainViewController:newData];
}

- (void)addDataToMainViewController:(EJData *) newData {
    EJMainViewController *mainViewController = (EJMainViewController *)[self.navigationController.viewControllers objectAtIndex:0];
    [mainViewController.dataArray addObject:newData];
    
    NSNotification *notification = [NSNotification notificationWithName:@"addData" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    [[self navigationController] popToRootViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
