//
//  EJProgressView.m
//  AT_benchmarking
//
//  Created by Eunjoo Im on 2016. 5. 10..
//  Copyright © 2016년 Jay Im. All rights reserved.
//

#import "EJProgressView.h"
#import "EJColorLib.h"

@implementation EJProgressView

NSArray *characterArray;
UIImage *bubble;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *subViews = self.subviews;
        for (UIView *view in subViews) {
            [view removeFromSuperview];
        }
    }

    characterArray = [NSArray arrayWithObjects: [UIImage imageNamed:@"male01.png"], [UIImage imageNamed:@"male02.png"], [UIImage imageNamed:@"male03.png"], [UIImage imageNamed:@"female01.png"], [UIImage imageNamed:@"female02.png"], [UIImage imageNamed:@"female03.png"], nil];
    bubble = [UIImage imageNamed:@"bubble.png"];
  
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    NSArray *subViews = self.subviews;
    for (UIView *view in subViews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    
    NSInteger maxWidth = rect.size.width;
    NSInteger currentWidth = floor([self progress] * maxWidth);

    UIView *progressBG =[[UIView alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y + 50, rect.size.width, rect.size.height - 40)];
    [progressBG setBackgroundColor:[UIColor whiteColor]];
    
    UIView *progressBar =[[UIView alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y + 50, 0, rect.size.height - 40)];
    [progressBar setBackgroundColor:[EJColorLib colorFromHexString:@"#C8454D"]];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:characterArray[self.characterIndex]];
    imageView.frame = CGRectMake(0, 28, 12, 24);
    
    UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:bubble];
    bubbleImageView.frame = CGRectMake(-30, 0, 60, 24);
    
    UILabel *fromLabel = [[UILabel alloc]initWithFrame:CGRectMake(-30, 0, 60, 20)];
    fromLabel.text = self.bubbleText;
    fromLabel.numberOfLines = 1;
    fromLabel.font = [UIFont systemFontOfSize:9];
    fromLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters; // or UIBaselineAdjustmentAlignCenters, or UIBaselineAdjustmentNone
    fromLabel.adjustsFontSizeToFitWidth = YES;
    fromLabel.minimumScaleFactor = 10.0f/12.0f;
    fromLabel.clipsToBounds = YES;
    fromLabel.backgroundColor = [UIColor clearColor];
    fromLabel.textColor = [UIColor blackColor];
    fromLabel.textAlignment = NSTextAlignmentCenter;

    [self addSubview:progressBG];
    [self addSubview:progressBar];
    [self addSubview:imageView];
    [self addSubview:bubbleImageView];
    [self addSubview:fromLabel];
    
    NSLog(@"drawRect %d", self.characterIndex);

    [UIView animateWithDuration:0.8 animations:^{
        progressBar.frame = CGRectMake(rect.origin.x, rect.origin.y + 50, currentWidth, rect.size.height - 40);
        imageView.frame = CGRectMake(currentWidth - 6, 28, 12, 24);
        bubbleImageView.frame = CGRectMake(currentWidth - 30, 0, 60, 24);
        fromLabel.frame = CGRectMake(currentWidth - 30, 0, 60, 20);
    }];
}

@end
