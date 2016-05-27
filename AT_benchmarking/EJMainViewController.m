//
//  EJMainViewController.m
//  AT_benchmarking
//
//  Created by Eunjoo Im on 2016. 5. 10..
//  Copyright © 2016년 Jay Im. All rights reserved.
//

#import "EJMainViewController.h"
#import "EJAddViewController.h"
#import "EJTableViewCell.h"
#import "EJSetTimeViewController.h"
#import "EJSetDayViewController.h"
#import "EJSetCustomViewController.h"

#import "EJData.h"
#import "EJProgressView.h"
#import "EJColorLib.h"
#import "EJDateLib.h"

@implementation EJMainViewController

// type 0: hour 1: day 2: week 3: month 4: year 5: anniversary 6:custom 7: today
enum {hour = 0, day = 1, week, month, year, anniversary, custom, today} EJtype;

NSArray *colorArray;
UIStoryboard *myStoryboard;

- (void)viewWillAppear:(BOOL)animated {
    // navigation bar style
    
    self.navigationController.navigationBar.barTintColor = [EJColorLib colorFromHexString:@"#F74553"];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                      NSFontAttributeName : [UIFont boldSystemFontOfSize:24.0]
                                                                      }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    myStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addData)];
    self.navigationItem.rightBarButtonItem = refreshButton;
    
    // 임시 데이터객체
    self.dataArray = [[NSMutableArray alloc] init];
    
    EJData *temp = [[EJData alloc] initWithType:today character:2 title:@"오늘" date:[NSDate date] start:[EJDateLib stringFromDate:[NSDate date]] end:[EJDateLib stringFromDate:[NSDate date]]];
    EJData *temp2 = [[EJData alloc] initWithType:week character:1 title:@"이번주" date:[NSDate date] start:[EJDateLib stringFromDate:[NSDate date]] end:[EJDateLib stringFromDate:[NSDate date]]];
    EJData *temp3 = [[EJData alloc] initWithType:month character:4 title:@"이번달" date:[NSDate date] start:[EJDateLib stringFromDate:[NSDate date]] end:[EJDateLib stringFromDate:[NSDate date]]];
    EJData *temp4 = [[EJData alloc] initWithType:year character:5 title:@"올해" date:[NSDate date] start:[EJDateLib stringFromDate:[NSDate date]] end:[EJDateLib stringFromDate:[NSDate date]]];

    [self.dataArray addObject:temp];
    [self.dataArray addObject:temp2];
    [self.dataArray addObject:temp3];
    [self.dataArray addObject:temp4];

    // color values
    colorArray = [NSArray arrayWithObjects:@"#99CCCC", @"#BDD5BD", @"#D7D8B1", @"#F5DC90", @"#F2CA78", @"#EFAB79", @"#EC8C71",
                  @"#E6756B", @"#EC8C71", @"#EFAB79", @"#F2CA78", @"#F5DC90", @"#D7D8B1", @"#BDD5BD", @"#99CCCC", nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(dataReceived:) name:@"addData" object:nil];
}

#pragma mark - Notification
- (void)dataReceived:(NSNotification*)notification {
    NSLog(@"Data received");
    [self.tableView reloadData];
}

#pragma mark - add data

- (void)addData {
    // maximum data: 15
    if ([self.dataArray count] > 14) {
        NSLog(@"no more add");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"앗! AT가 너무 많아요."
                                                        message:@"더 많은 AT를 만들기 위해서는 업그레이드가 필요해요."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    EJAddViewController *addViewController = [myStoryboard instantiateViewControllerWithIdentifier:@"addViewControllerIdentifier"];
    [self.navigationController pushViewController:addViewController animated:YES];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EJTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EJCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EJCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSArray *subViews = cell.subviews;
    for (UIView *view in subViews) {
        if ([view isKindOfClass:[EJProgressView class]]) {
            NSLog(@"EJProgressView: %@", view);
            [view removeFromSuperview];
        }
    }

    EJData *cellData = [self.dataArray objectAtIndex:indexPath.row];
    cell.backgroundColor = [EJColorLib colorFromHexString:[colorArray objectAtIndex:indexPath.row]];
    cell.cellTitle.text = cellData.title;
    cell.cellstart.text = cellData.startString;
    cell.cellEnd.text = cellData.endString;
    cell.cellPercent.text = [NSString stringWithFormat:@"%d", cellData.percent];
    
    EJProgressView* progressTest = [[EJProgressView alloc] initWithFrame:CGRectMake(66, 22, 200, 50)];
    NSLog(@"character in cellData %d", cellData.character);

    progressTest.progress = cellData.percent / 100.0;
    progressTest.characterIndex = cellData.character;
    
    [cell addSubview:progressTest];
    
    return cell;
}

#pragma mark - tableViewDetail
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EJData *data;
    
    data = self.dataArray[indexPath.row];

    switch (data.type) {
        case hour: {
            EJSetTimeViewController *addViewController = [myStoryboard instantiateViewControllerWithIdentifier:@"setTimeViewControllerIdentifier"];
            addViewController.timeData = data;
            addViewController.timeIndex = indexPath.row;
            
            [self.navigationController pushViewController:addViewController animated:YES];
            
            break;
        }
            
        case day: {
            EJSetDayViewController *addViewController = [myStoryboard instantiateViewControllerWithIdentifier:@"setDayViewControllerIdentifier"];
            addViewController.dayData = data;
            addViewController.dayIndex = indexPath.row;
            
            [self.navigationController pushViewController:addViewController animated:YES];
            
            break;
        }
            
        case anniversary: {
            EJSetDayViewController *addViewController = [myStoryboard instantiateViewControllerWithIdentifier:@"setDayViewControllerIdentifier"];
            addViewController.dayData = data;
            addViewController.dayIndex = indexPath.row;
            
            [self.navigationController pushViewController:addViewController animated:YES];
            
            break;
        }
            
        case custom: {
            EJSetCustomViewController *addViewController = [myStoryboard instantiateViewControllerWithIdentifier:@"setCustomViewControllerIdentifier"];
            addViewController.customData = data;
            addViewController.customIndex = indexPath.row;
            
            [self.navigationController pushViewController:addViewController animated:YES];
            
            break;
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView beginUpdates];
    [self.dataArray removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
    [self.tableView endUpdates];
}

@end
