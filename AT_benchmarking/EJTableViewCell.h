//
//  EJTableViewCell.h
//  AT_benchmarking
//
//  Created by Eunjoo Im on 2016. 5. 10..
//  Copyright © 2016년 Jay Im. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EJTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *cellTitle;
@property (weak, nonatomic) IBOutlet UILabel *cellPercent;
@property (weak, nonatomic) IBOutlet UILabel *cellstart;
@property (weak, nonatomic) IBOutlet UILabel *cellEnd;

@end
