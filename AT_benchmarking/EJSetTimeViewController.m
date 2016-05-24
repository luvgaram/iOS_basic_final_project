//
//  EJSetTimeViewController.m
//  AT_benchmarking
//
//  Created by Eunjoo Im on 2016. 5. 24..
//  Copyright © 2016년 Jay Im. All rights reserved.
//

#import "EJSetTimeViewController.h"
#import "ESTimePicker.h"

@interface EJSetTimeViewController ()
@property (weak, nonatomic) IBOutlet UIView *startTimeview;
@property (weak, nonatomic) IBOutlet UIView *endTimeView;

@end

@implementation EJSetTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    float viewSize = self.view.frame.size.height;
    float pickerSize = (viewSize - 120.0) / 2.0;
    
    NSLog(@"origin, %f, %f, size: %f, %f, picker: %f", self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height, pickerSize);

    ESTimePicker *startTimePicker = [[ESTimePicker alloc] initWithDelegate:self];
    
    [startTimePicker setFrame:CGRectMake((self.view.frame.size.width - pickerSize) / 2.0, 10, pickerSize, pickerSize)];
    [self.startTimeview addSubview:startTimePicker];
    
    ESTimePicker *endTimePicker = [[ESTimePicker alloc] initWithDelegate:self];
    
    [endTimePicker setFrame:CGRectMake((self.view.frame.size.width - pickerSize) / 2.0, 10, pickerSize, pickerSize)];
    [self.endTimeView addSubview:endTimePicker];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - timePicker
- (void)timePickerHoursChanged:(ESTimePicker *)timePicker toHours:(int)hour {
//    [hoursLabel setText:[NSString stringWithFormat:@"%i", hours]];
}

- (void)timePickerMinutesChanged:(ESTimePicker *)timePicker toMinutes:(int)minute {
//    [minutesLabel setText:[NSString stringWithFormat:@"%i", minutes]];
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
