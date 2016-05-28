//
//  EJSetDayViewController.h
//  AT_benchmarking
//
//  Created by Eunjoo Im on 2016. 5. 17..
//  Copyright © 2016년 Jay Im. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EJRealmData.h"

@interface EJSetDayViewController : UIViewController

@property EJRealmData *dayData;
@property NSString *dayTitleFromRecipe;
@property BOOL dateTypeFromRecipe;

@end
