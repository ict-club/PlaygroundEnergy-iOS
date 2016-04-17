//
//  coreDataController.m
//  Lumii
//
//  Created by Martin Kuvandzhiev on 8/17/15.
//  Copyright (c) 2015 PETAR LAZAROV. All rights reserved.
//

#import "coreDataController.h"
#import "viewController.h"

@implementation coreDataController
@synthesize managedObjectContext;

- (void) addData: (NSString *) points atDate: (NSDate *)date forUser:(NSString *)user
{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *failedBankInfo = [NSEntityDescription
                                       insertNewObjectForEntityForName:@"Lumi"
                                       inManagedObjectContext:context];
    [failedBankInfo setValue:user forKey:@"user"];
    [failedBankInfo setValue:date forKey:@"date"];
    [failedBankInfo setValue:points forKey:@"points"];
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

- (NSArray *) getData
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Lumi" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
//    for (NSManagedObject *info in fetchedObjects) {
//        NSLog(@"Date: %@",[info valueForKey:@"date"]);
//        //        NSManagedObject *details = [info valueForKey:@"details"];
//        //        NSLog(@"Zip: %@", [details valueForKey:@"zip"]);
//    }
    return fetchedObjects;
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    
    return context;
}

@end
