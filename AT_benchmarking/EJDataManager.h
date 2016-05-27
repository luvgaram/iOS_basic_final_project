//
//  EJDataManager.h
//  AT_benchmarking
//
//  Created by Eunjoo Im on 2016. 5. 27..
//  Copyright © 2016년 Jay Im. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EJRealmData.h"

@interface EJDataManager : NSObject

+ (EJDataManager *)sharedInstance;
- (void)addData:(EJRealmData *)data;
- (EJRealmData *)getData:(int)id;
- (void)updateData:(EJRealmData *)data;
- (void)deleteData:(int)id;
- (NSMutableArray *)getAllData;
- (int)getIdManager;
@end
