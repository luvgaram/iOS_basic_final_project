//
//  EJSetCustomViewController.h
//  AT_benchmarking
//
//  Created by Eunjoo Im on 2016. 5. 26..
//  Copyright © 2016년 Jay Im. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EJData.h"

@interface EJSetCustomViewController : UIViewController

@property EJData *customData;
@property int customIndex;
@property NSString *customTitleFromRecipe;
@property NSString *customUnitFromRecipe;

@end
