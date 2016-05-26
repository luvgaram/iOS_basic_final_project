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

// http://iosameer.blogspot.kr/2012/09/creating-custom-uiprogressview.html
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *subViews = self.subviews;
        for (UIView *view in subViews) {
            
            NSLog(@"view: %@", view);
            [view removeFromSuperview];
        }
    }

    characterArray = [NSArray arrayWithObjects: [UIImage imageNamed:@"male01.png"], [UIImage imageNamed:@"male02.png"], [UIImage imageNamed:@"male03.png"], [UIImage imageNamed:@"female01.png"], [UIImage imageNamed:@"female02.png"], [UIImage imageNamed:@"female03.png"], nil];
  
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    NSInteger maxWidth = rect.size.width;
    NSInteger currentWidth = floor([self progress] * maxWidth);

    UIView *progressBG =[[UIView alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y + 50, rect.size.width, rect.size.height - 40)];
    [progressBG setBackgroundColor:[UIColor whiteColor]];
    
    UIView *progressBar =[[UIView alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y + 50, 0, rect.size.height - 40)];
    [progressBar setBackgroundColor:[EJColorLib colorFromHexString:@"#C8454D"]];
    
    UIView *characterView = [[UIView alloc] initWithFrame:CGRectMake(0, 24, 10, 24)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:characterArray[self.characterIndex]];
    imageView.frame = characterView.bounds;
    [characterView addSubview:imageView];
    
    [self addSubview:progressBG];
    [self addSubview:progressBar];
    [self addSubview:characterView];
    
    NSLog(@"drawRect %d", self.characterIndex);

    [UIView animateWithDuration:1.0 animations:^{
        progressBar.frame = CGRectMake(rect.origin.x, rect.origin.y + 50, currentWidth, rect.size.height - 40);
        characterView.frame = CGRectMake(currentWidth - 5, 24, 10, 24);
    }];
}

@end
