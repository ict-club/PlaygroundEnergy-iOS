//
//  coreDataController.h
//  Lumii
//
//  Created by Martin Kuvandzhiev on 8/17/15.
//  Copyright (c) 2015 PETAR LAZAROV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface coreDataController : NSObject
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

- (void) addData: (NSString *) points atDate: (NSDate *)date forUser: (NSString *) user;
- (NSArray *) getData;
@end
