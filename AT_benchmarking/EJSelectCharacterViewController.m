//
//  EJSelectCharacterViewController.m
//  AT_benchmarking
//
//  Created by Eunjoo Im on 2016. 5. 26..
//  Copyright © 2016년 Jay Im. All rights reserved.
//

#import "EJSelectCharacterViewController.h"
#import "EJData.h"
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

# pragma mark - data save
- (void)saveDate {
    EJData *newData;
    NSString *todayString = [EJDateLib stringFromDate:[NSDate date]];
    switch (self.typeFromRecipe) {
        case week:
            newData = [[EJData alloc] initWithType:week character:characterNumber title:@"이번주" date:[NSDate date] start:todayString end:todayString];
            break;
            
        case month:
            newData = [[EJData alloc] initWithType:month character:characterNumber title:@"이번달" date:[NSDate date] start:todayString end:todayString];
            break;
        case year:
            newData = [[EJData alloc] initWithType:year character:characterNumber title:@"올해" date:[NSDate date] start:todayString end:todayString];
            break;
        case today:
            newData = [[EJData alloc] initWithType:today character:characterNumber title:@"오늘" date:[NSDate date] start:todayString end:todayString];
            break;
    }
    
    [self addDataToMainViewController:newData];
}

- (void)addDataToMainViewController:(EJData *) newData {
    EJMainViewController *mainViewController = (EJMainViewController *)[self.navigationController.viewControllers objectAtIndex:0];
    [mainViewController.dataArray addObject:newData];
    
    NSNotification *notification = [NSNotification notificationWithName:@"addData" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    [[self navigationController] popToRootViewControllerAnimated:YES];
}

@end
