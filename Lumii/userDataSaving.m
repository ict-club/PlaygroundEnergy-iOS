//
//  userDataSaving.m
//  Lumii
//
//  Created by Martin Kuvandzhiev on 8/16/15.
//  Copyright (c) 2015 PETAR LAZAROV. All rights reserved.
//

#import "userDataSaving.h"
#define userkey @"USER"
#define passkey @"PASS"
#define rememberkey @"REMKEY"
#define facebookLogin @"FACELOG"

@implementation userDataSaving

@synthesize userKey, passwordKey, rememberMeKey;

- (void) writeData:(NSString *) data forKey: (NSString *) Key
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    // the mutalbe array of all debts
    //NSMutableArray * alldebtRecords = [[defaults objectForKey:Key] mutableCopy];
    
    [defaults setObject:data forKey:Key];
    [defaults synchronize];
    
}

- (NSString *) readData: (NSString *) Key
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    return [defaults stringForKey:Key];
}

- (void) setCurrentUser: (NSString *) user
{
    [self writeData:user forKey:userkey];
}
- (NSString *) currentUser
{
    return [self readData:userkey];
}


- (void) setCurrentPassword: (NSString *) pass
{
    [self writeData:pass forKey:passkey];
}
-(NSString *) currentPassword
{
    return [self readData:passkey];
}

- (void) setRememberMeState: (bool) state
{
    [self writeData:[NSString stringWithFormat:@"%d", state] forKey:rememberkey];
}
-(bool) rememberMeState
{
    if([self readData:rememberkey].integerValue == true )
    {
        return true;
    }
    else return false;
}

- (void) setFacebookLogin: (bool) state
{
    [self writeData:[NSString stringWithFormat:@"%d", state] forKey:facebookLogin];
}
-(bool) facebookLoginState
{
    if([self readData:facebookLogin].integerValue == true )
    {
        return true;
    }
    else return false;
}






@end
