//
//  EJSetCustomViewController.m
//  AT_benchmarking
//
//  Created by Eunjoo Im on 2016. 5. 26..
//  Copyright © 2016년 Jay Im. All rights reserved.
//

#import "EJSetCustomViewController.h"
#import "EJColorLib.h"
#import "EJDateLib.h"
#import "EJDataManager.h"
#import "EJMainViewController.h"

@interface EJSetCustomViewController ()
@property (weak, nonatomic) IBOutlet UITextField *customTitleTextView;
@property (weak, nonatomic) IBOutlet UITextField *customStart;
@property (weak, nonatomic) IBOutlet UITextField *customCurrent;
@property (weak, nonatomic) IBOutlet UITextField *customEnd;
@property (weak, nonatomic) IBOutlet UITextField *customUnit;

@end

@implementation EJSetCustomViewController

BOOL isNewCustom;
BOOL isCustomTitleInserted;
BOOL isCustomStartInserted;
BOOL isCustomCurrentInserted;
BOOL isCustomEndInserted;
BOOL isCustomUnitInserted;
int customCharacterNumber;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBar];
    [self setKeyboard];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(characterChanged:) name:@"characterChanged" object:nil];
    
    [self setValuesFromData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setValuesFromRecipe];
    [self switchSaveButtonStatus];
}

- (void)setKeyboard {
    self.customStart.keyboardType = UIKeyboardTypeDecimalPad;
    self.customCurrent.keyboardType = UIKeyboardTypeDecimalPad;
    self.customEnd.keyboardType = UIKeyboardTypeDecimalPad;
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = @[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)]];
    [numberToolbar sizeToFit];
    self.customStart.inputAccessoryView = numberToolbar;
    self.customCurrent.inputAccessoryView = numberToolbar;
    self.customEnd.inputAccessoryView = numberToolbar;
}

- (void)doneWithNumberPad {
    [self.view endEditing:YES];
}

- (void)setValuesFromData {
    if (self.customData) {
        // setCharacter
        customCharacterNumber = self.customData.character;
        [self postNotiToCharacter:customCharacterNumber];
        
        self.customTitleTextView.text = self.customData.title;
        self.customStart.text = self.customData.start;
        self.customCurrent.text = self.customData.current;
        self.customEnd.text = self.customData.end;
        self.customUnit.text = self.customData.unit;
        
        isNewCustom = NO;
    } else isNewCustom = YES;
}

- (void)setValuesFromRecipe {
    if (self.customTitleFromRecipe) {
        self.customTitleTextView.text = self.customTitleFromRecipe;
        if ([self.customTitleFromRecipe isEqualToString:@"일생"]) {
            self.customStart.text = @"0";
            self.customEnd.text = @"100";
        }
    }
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

- (IBAction)customTitleTextChanged:(id)sender {
    [self switchSaveButtonStatus];
}

- (IBAction)customStartTextChanged:(id)sender {
    [self switchSaveButtonStatus];
}
- (IBAction)customCurrentTextChanged:(id)sender {
    [self switchSaveButtonStatus];
}
- (IBAction)customEndTextChanged:(id)sender {
    [self switchSaveButtonStatus];
}
- (IBAction)customUnitTextChanged:(id)sender {
    [self switchSaveButtonStatus];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - Notification
- (void)characterChanged:(NSNotification*)notification {
    customCharacterNumber = [notification.userInfo[@"characterNumber"] intValue];
    NSLog(@"character: %d", customCharacterNumber);
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

// type 0: hour 1: day 2: week 3: month 4: year 5: anniversary 6:custom 7: today
# pragma mark - data save
- (void)saveDate {
    EJRealmData *newData;
    EJDataManager *dataManager = [EJDataManager sharedInstance];

    newData = [[EJRealmData alloc] initWithValue:@{
                                                   @"id" : @([dataManager getIdManager]),
                                                   @"type" : @(6),
                                                   @"character" : @(customCharacterNumber),
                                                   @"title" : self.customTitleTextView.text,
                                                   @"date" : [NSDate date],
                                                   @"start" : self.customStart.text,
                                                   @"end" : self.customEnd.text,
                                                   @"current" : self.customCurrent.text,
                                                   @"unit" : self.customUnit.text
                                                   }];
    
    if (isNewCustom) [self addDataToMainViewController:newData];
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
                                                                   @"id" : @(self.customData.id),
                                                                   @"type" : @(newData.type),
                                                                   @"character" : @(newData.character),
                                                                   @"title" : newData.title,
                                                                   @"date" : [NSDate date],
                                                                   @"start" : newData.start,
                                                                   @"end" : newData.end,
                                                                   @"current" : newData.current,
                                                                   @"unit" : newData.unit
                                                                   }];
    
    [dataManager updateData:updateData];
    [self postNotiToMain];
}

@end
