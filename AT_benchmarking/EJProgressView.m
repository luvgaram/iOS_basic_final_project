//
//  EJProgressView.m
//  AT_benchmarking
//
//  Created by Eunjoo Im on 2016. 5. 10..
//  Copyright © 2016년 Jay Im. All rights reserved.
//

#import "EJProgressView.h"

@implementation EJProgressView

// http://iosameer.blogspot.kr/2012/09/creating-custom-uiprogressview.html

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *subViews = self.subviews;
        for (UIView *view in subViews) {
            [view removeFromSuperview];
        }
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    UIImage *background = [[UIImage imageNamed:@"bar_white.png"]
                           resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 4)];
    UIImage *fill = [[UIImage imageNamed:@"bar_red.png"]
                     resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 4)];

    [background drawInRect:rect];

    NSInteger maxWidth = rect.size.width;

    NSInteger currentWidth = floor([self progress] * maxWidth);

    CGRect fillRect = CGRectMake(rect.origin.x,
                                 rect.origin.y,
                                 currentWidth,
                                 rect.size.height);
    [fill drawInRect:fillRect];
}

@end
