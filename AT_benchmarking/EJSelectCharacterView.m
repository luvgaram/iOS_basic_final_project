//
//  EJSelectCharacterView.m
//  AT_benchmarking
//
//  Created by Eunjoo Im on 2016. 5. 26..
//  Copyright © 2016년 Jay Im. All rights reserved.
//

#import "EJSelectCharacterView.h"
#import "EJTapGestureRecognizer.h"

@interface EJSelectCharacterView ()
@property (weak, nonatomic) IBOutlet UIImageView *selectTriangle01;
@property (weak, nonatomic) IBOutlet UIImageView *selectTriangle02;
@property (weak, nonatomic) IBOutlet UIImageView *selectTriangle03;
@property (weak, nonatomic) IBOutlet UIImageView *selectTriangle04;
@property (weak, nonatomic) IBOutlet UIImageView *selectTriangle05;
@property (weak, nonatomic) IBOutlet UIImageView *selectTriangle06;
@property (weak, nonatomic) IBOutlet UIImageView *select01;
@property (weak, nonatomic) IBOutlet UIImageView *select02;
@property (weak, nonatomic) IBOutlet UIImageView *select03;
@property (weak, nonatomic) IBOutlet UIImageView *select04;
@property (weak, nonatomic) IBOutlet UIImageView *select05;
@property (weak, nonatomic) IBOutlet UIImageView *select06;

@end

@implementation EJSelectCharacterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
int selectedCharacter;
NSMutableArray *triangleArray;
NSMutableArray *subviewPositionArray;

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        // 1. load the interface
        [[NSBundle mainBundle] loadNibNamed:@"SelectCharacterView" owner:self options:nil];
        // 2. add as subview
        [self addSubview:self.view];
        // 3. allow for autolayout
        [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
        // 4. add constraints to span entire view
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view":self.view}]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view":self.view}]];
        
    }
    return self;
}

- (void)awakeFromNib {
    NSLog(@"awakeFromNib");
    [self initTriangleArray];
    [self setTriangle:0];
    [self setTap];
}

- (void)initTriangleArray {
    triangleArray = [[NSMutableArray alloc] initWithCapacity:6];
    triangleArray[0] = self.selectTriangle01;
    triangleArray[1] = self.selectTriangle02;
    triangleArray[2] = self.selectTriangle03;
    triangleArray[3] = self.selectTriangle04;
    triangleArray[4] = self.selectTriangle05;
    triangleArray[5] = self.selectTriangle06;
}

# pragma mark - tap gesture
- (void)setTap {
    EJTapGestureRecognizer *singleFingerTap =
    [[EJTapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(characterTapped:)];
    singleFingerTap.index = 0;
    [self.select01 addGestureRecognizer:singleFingerTap];
    
    
    singleFingerTap =
    [[EJTapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(characterTapped:)];
    singleFingerTap.index = 1;
    [self.select02 addGestureRecognizer:singleFingerTap];
    
    
    singleFingerTap =
    [[EJTapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(characterTapped:)];
    singleFingerTap.index = 2;
    [self.select03 addGestureRecognizer:singleFingerTap];
    
    singleFingerTap =
    [[EJTapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(characterTapped:)];
    singleFingerTap.index = 3;
    [self.select04 addGestureRecognizer:singleFingerTap];
    
    
    singleFingerTap =
    [[EJTapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(characterTapped:)];
    singleFingerTap.index = 4;
    [self.select05 addGestureRecognizer:singleFingerTap];
    
    
    singleFingerTap =
    [[EJTapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(characterTapped:)];
    singleFingerTap.index = 5;
    [self.select06 addGestureRecognizer:singleFingerTap];
}

- (void)characterTapped:(EJTapGestureRecognizer *)recognizer {
    int index = recognizer.index;
    
    NSDictionary *userInfo = @{@"characterNumber":[NSNumber numberWithInteger:index]};
    
    NSNotification *notification = [NSNotification notificationWithName:@"characterChanged" object:self userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [self setTriangle:index];
}

- (void)setTriangle:(int)targetIndex {
    selectedCharacter = targetIndex + 1;
    
    NSLog(@"%d selected", selectedCharacter);
    
    for (UIImageView *imageView in triangleArray) {
        imageView.alpha = 0;
    }
    
    UIImageView *targetTriange = triangleArray[targetIndex];
    targetTriange.alpha = 1;
}

//- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent *)event {
//    [super touchesBegan:touches withEvent:event];
//    
//    NSLog(@"touches began!");
//}
//
//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [super touchesEnded:touches withEvent:event];
//    
//    NSLog(@"touches ended!");
//
//}


@end
