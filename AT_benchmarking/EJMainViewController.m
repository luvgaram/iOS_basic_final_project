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
#import "EJData.h"
#import "EJProgressView.h"
#import "EJColorLib.h"

@implementation EJMainViewController

// type 0: hour 1: day 2: week 3: month 4: year 5: life, 6: custom
typedef enum {hour, day = 1, week, month, year, life, custom} EJtype;


NSArray *colorArray;

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
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addData)];
    self.navigationItem.rightBarButtonItem = refreshButton;
    
    // 임시 데이터객체
    _dataArray = [[NSMutableArray alloc] init];
    
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

- (void)addData {
    
    // maximum data: 15
    if ([_dataArray count] > 14) {
        NSLog(@"no more add");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"앗! AT가 너무 많아요."
                                                        message:@"더 많은 AT를 만들기 위해서는 업그레이드가 필요해요."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EJAddViewController *addViewController = [storyboard instantiateViewControllerWithIdentifier:@"addViewControllerIdentifier"];
    [self.navigationController pushViewController:addViewController animated:YES];
    
}

// temp addData
//- (void)addData {
//    
//    // maximum data: 15
//    if ([dataArray count] > 14) {
//        NSLog(@"no more add");
//        return;
//    }
//    
//    EJtype type = hour;
//    NSString *start = @"2016-04-10-00-00-00";
//    NSString *end = @"2016-05-17-00-00-00";
//    
//    EJData *newData = [[EJData alloc] initWithType:type character:1 title:@"new" start:start end:end];
//    
//    [dataArray addObject:newData];
//    
//    [self.tableView reloadData];
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EJTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EJCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EJCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

    EJData *cellData = [_dataArray objectAtIndex:indexPath.row];
    cell.backgroundColor = [self colorFromHexString:[colorArray objectAtIndex:indexPath.row]];
    cell.cellTitle.text = cellData.title;
    cell.cellstart.text = cellData.startString;
    cell.cellEnd.text = cellData.endString;
    cell.cellPercent.text = [NSString stringWithFormat:@"%d", cellData.percent];
   
    UIProgressView* progressTest = [[EJProgressView alloc] initWithFrame:CGRectMake(66, 72, 200, 10)];
    progressTest.progress = cellData.percent / 100.0;
    
    [cell addSubview:progressTest];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - color library

- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}
                       
#pragma mark - DateConvertor
                       
- (NSDate *)dateFromString:(NSString *)string {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    return [dateFormatter dateFromString:string];
}
                       
- (NSString *)stringFromDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy MM dd HH mm ss"];
    return [dateFormatter stringFromDate:date];
}

@end
