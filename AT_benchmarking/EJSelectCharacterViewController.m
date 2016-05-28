//
//  EJSelectCharacterViewController.m
//  AT_benchmarking
//
//  Created by Eunjoo Im on 2016. 5. 26..
//  Copyright © 2016년 Jay Im. All rights reserved.
//

#import "EJSelectCharacterViewController.h"
#import "EJRealmData.h"
#import "EJDataManager.h"
#import "EJMainViewController.h"
#import "EJColorLib.h"
#import "EJDateLib.h"

@interface EJSelectCharacterViewController ()

@end

@implementation EJSelectCharacterViewController

// type 0: hour 1: day 2: week 3: month 4: year 5: anniversary 6:custom 7: today
enum {hour = 0, day = 1, week, month, year, anniversary, custom, today} recType;
int characterNumber;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBar];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(characterChanged:) name:@"characterChanged" object:nil];
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
}

#pragma mark - Notification
- (void)characterChanged:(NSNotification*)notification {
    characterNumber = [notification.userInfo[@"characterNumber"] intValue];
    NSLog(@"character: %d", characterNumber);
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

# pragma mark - data save
- (void)saveDate {
    EJRealmData *newData;
    EJDataManager *dataManager = [EJDataManager sharedInstance];
    
    NSString *todayString = [EJDateLib stringFromDate:[NSDate date]];
    switch (self.typeFromRecipe) {
        case week:
            newData = [[EJRealmData alloc] initWithValue:@{
                                                           @"id" : @([dataManager getIdManager]),
                                                           @"type" : @(week),
                                                           @"character" : @(characterNumber),
                                                           @"title" : @"이번주",
                                                           @"date" : [NSDate date]
                                                           }];
            break;
            
        case month:
            newData = [[EJRealmData alloc] initWithValue:@{
                                                           @"id" : @([dataManager getIdManager]),
                                                           @"type" : @(characterNumber),
                                                           @"character" : @(characterNumber),
                                                           @"title" : @"이번달",
                                                           @"date" : [NSDate date]
                                                           }];
            break;
        case year:
            newData = [[EJRealmData alloc] initWithValue:@{
                                                           @"id" : @([dataManager getIdManager]),
                                                           @"type" : @(year),
                                                           @"character" : @(characterNumber),
                                                           @"title" : @"올해",
                                                           @"date" : [NSDate date]
                                                           }];
            break;
        case today:
            newData = [[EJRealmData alloc] initWithValue:@{
                                                           @"id" : @([dataManager getIdManager]),
                                                           @"type" : @(today),
                                                           @"character" : @(characterNumber),
                                                           @"title" : @"오늘",
                                                           @"date" : [NSDate date]
                                                           }];
            break;
    }
    
    [self addDataToMainViewController:newData];
}

- (void)addDataToMainViewController:(EJRealmData *) newData {
    EJDataManager *dataManager = [EJDataManager sharedInstance];
    [dataManager addData:newData];
    
    [self postNotiToMain];
}

@end
