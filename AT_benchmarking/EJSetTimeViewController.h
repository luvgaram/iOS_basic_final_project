
//  EJSetTimeViewController.h
//  AT_benchmarking
//
//  Created by Eunjoo Im on 2016. 5. 24..
//  Copyright © 2016년 Jay Im. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "EJData.h"
#import "EJRealmData.h"

@interface EJSetTimeViewController : UIViewController

@property EJRealmData *timeData;
//@property EJData *timeData;
//@property int timeIndex;
@property NSString *timeTitleFromRecipe;

@end
