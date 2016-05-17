//
//  EJSetDayViewController.m
//  AT_benchmarking
//
//  Created by Eunjoo Im on 2016. 5. 17..
//  Copyright © 2016년 Jay Im. All rights reserved.
//

#import "EJSetDayViewController.h"
#import "EJColorLib.h"

@interface EJSetDayViewController ()
@property (weak, nonatomic) IBOutlet UITextField *dayTitleTextView;
@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *daySegmentControl;
@property (weak, nonatomic) IBOutlet UIButton *dayPeriodButton;
@property (weak, nonatomic) IBOutlet UIButton *dayDayButton;
@property (weak, nonatomic) IBOutlet UIView *dayPeriodBG;
@property (weak, nonatomic) IBOutlet UIView *dayDateBG;
@property (weak, nonatomic) IBOutlet UILabel *dayPeriodLable;
@property (weak, nonatomic) IBOutlet UILabel *dayDateLable;

@end

@implementation EJSetDayViewController
- (IBAction)periodButtonClicked:(id)sender {
    _dayPeriodButton.backgroundColor = [EJColorLib colorFromHexString:@"#F2DB85"];
    [_dayPeriodButton setTitleColor:[EJColorLib colorFromHexString:@"#DD3243"] forState:UIControlStateNormal];
    _dayPeriodButton.titleLabel.textColor = [EJColorLib colorFromHexString:@"#DD3243"];
    _dayDayButton.backgroundColor = [EJColorLib colorFromHexString:@"#ECCF6F"];
    [_dayDayButton setTitleColor:[EJColorLib colorFromHexString:@"#444447"] forState:UIControlStateNormal];
    [_firstView setHidden:NO];
    [_secondView setHidden:YES];
    [self.view setNeedsDisplay];
}

- (IBAction)dayButtonClicked:(id)sender {
    _dayDayButton.backgroundColor = [EJColorLib colorFromHexString:@"#F2DB85"];
    [_dayDayButton setTitleColor:[EJColorLib colorFromHexString:@"#DD3243"] forState:UIControlStateNormal];
    _dayPeriodButton.backgroundColor = [EJColorLib colorFromHexString:@"#ECCF6F"];
    [_dayPeriodButton setTitleColor:[EJColorLib colorFromHexString:@"#444447"] forState:UIControlStateNormal];

    [_firstView setHidden:YES];
    [_secondView setHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTap];
    
    // set text field style
//    _dayTitleTextView.borderStyle = UITextBorderStyleNone;
//    
//    CGRect frameRect = _dayTitleTextView.frame;
//    frameRect.size.height = 120;
//    _dayTitleTextView.frame = frameRect;
    

//    _daySegmentControl.frame = CGRectMake(10, 7, _daySegmentControl.frame.size.width, _daySegmentControl.frame.size.height + 20);
    
//    UIGraphicsBeginImageContextWithOptions(CGSizeMake(1, _daySegmentControl.frame.size.height), NO, 0.0);
//    UIImage *blank = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    [_daySegmentControl setDividerImage:blank
//                    forLeftSegmentState:UIControlStateNormal
//                      rightSegmentState:UIControlStateNormal
//                             barMetrics:UIBarMetricsDefault];
//    
    
//    [_daySegmentControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[EJColorLib colorFromHexString:@"#444447"]}  forState:UIControlStateNormal];
//    [_daySegmentControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[EJColorLib colorFromHexString:@"#DD3243"]}  forState:UIControlStateSelected];
//    [_daySegmentControl setBackgroundImage:[UIImage imageNamed:@"nht_icon_80"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
//    _daySegmentControl.layer.borderColor = [UIColor clearColor].CGColor;
//    _daySegmentControl.layer.borderWidth = 1.0;
//    [_daySegmentControl.subviews objectAtIndex:0].layer.borderColor = [UIColor clearColor].CGColor;
//    [_daySegmentControl.subviews objectAtIndex:1].layer.borderColor = [UIColor clearColor].CGColor;
}

# pragma mark - tap gesture
- (void)setTap {
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(periodViewTapped:)];
    [self.dayPeriodBG addGestureRecognizer:singleFingerTap];
    
    singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(dateViewTapped:)];
    [self.dayDateBG addGestureRecognizer:singleFingerTap];
}

- (void)periodViewTapped:(UITapGestureRecognizer *)recognizer {
    self.dayPeriodBG.backgroundColor = [EJColorLib colorFromHexString:@"#F3D47E"];
    self.dayPeriodLable.textColor = [EJColorLib colorFromHexString:@"#DD3243"];
    self.dayDateBG.backgroundColor = [EJColorLib colorFromHexString:@"#ECCF6F"];
    self.dayDateLable.textColor = [EJColorLib colorFromHexString:@"#444447"];
    
    [_firstView setHidden:NO];
    [_secondView setHidden:YES];
}

- (void)dateViewTapped:(UITapGestureRecognizer *)recognizer {
    self.dayDateBG.backgroundColor = [EJColorLib colorFromHexString:@"#F3D47E"];
    self.dayDateLable.textColor = [EJColorLib colorFromHexString:@"#DD3243"];
    self.dayPeriodBG.backgroundColor = [EJColorLib colorFromHexString:@"#ECCF6F"];
    self.dayPeriodLable.textColor = [EJColorLib colorFromHexString:@"#444447"];
    
    [_secondView setHidden:NO];
    [_firstView setHidden:YES];
}

@end
