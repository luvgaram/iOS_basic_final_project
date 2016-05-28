//
//  EJFlowTouchView.m
//  AT_benchmarking
//
//  Created by Eunjoo Im on 2016. 5. 25..
//  Copyright © 2016년 Jay Im. All rights reserved.
//

#import "EJFlowTouchView.h"

@implementation EJFlowTouchView

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    NSLog(@"touches began!");
    NSLog(@"nextResponder: %@", [self nextResponder]);
    [[self nextResponder] touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    NSLog(@"touches ended!");
    NSLog(@"nextResponder: %@", [self nextResponder]);
    [[self nextResponder] touchesEnded:touches withEvent:event];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    CGPoint tViewHit = [self.timePicker convertPoint:point fromView:self];
    if ([self.timePicker pointInside:tViewHit withEvent:event]) {
        NSLog(@"inside %hhd Picker!", self.isStart);
        
        NSDictionary* userInfo = @{@"isStart": [NSNumber numberWithBool:self.isStart]};
        NSNotification *notification = [NSNotification notificationWithName:@"timePickerClicked" object:nil userInfo:userInfo];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        return self.timePicker;
    }
    
    NSLog(@"outside %hhd Picker!", self.isStart);
    return [super hitTest:point withEvent:event];
}

@end
