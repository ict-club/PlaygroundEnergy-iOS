//
//  userDataSaving.h
//  Lumii
//
//  Created by Martin Kuvandzhiev on 8/16/15.
//  Copyright (c) 2015 PETAR LAZAROV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface userDataSaving : NSObject

@property NSString *userKey, *passwordKey, *rememberMeKey;
-(void) writeData: (NSString*) data forKey:(NSString *) Key;
-(NSString *) readData: (NSString *) Key;
- (void) setCurrentUser: (NSString *) user;
- (NSString *) currentUser;
- (void) setCurrentPassword: (NSString *) pass;
-(NSString *) currentPassword;
- (void) setRememberMeState: (bool) state;
-(bool) rememberMeState;
- (void) setFacebookLogin: (bool) state;
- (bool) facebookLogin;

@end
