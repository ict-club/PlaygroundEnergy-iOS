//
//  AppDelegate.h
//  Lumii
//
//  Created by PETAR LAZAROV on 8/16/15.
//  Copyright © 2015 PETAR LAZAROV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "userDataSaving.h"
#import <CoreData/CoreData.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

