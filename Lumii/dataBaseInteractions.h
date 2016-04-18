//
//  dataBaseInteractions.h
//  Lumii
//
//  Created by Martin Kuvandzhiev on 8/17/15.
//  Copyright (c) 2015 PETAR LAZAROV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface dataBaseInteractions : NSObject

- (bool) login:(NSString *) name withPass:(NSString *) pass;

- (NSString *) registration:(NSString *) user withPass:(NSString *) pass;
- (int) getPoints:(NSString *) user withPass:(NSString *) pass;
- (NSString*) playgroundChartForTime:(NSInteger)period;
- (NSString*) usersChartForTime:(NSInteger)period;
- (NSString*) pointsTransactionWithUserName:(NSString*)username withPass:(NSString*)password withPoints:(NSInteger)points;
- (NSString *) postTransaction: (int) points forUser:(NSString *) user withPass:(NSString *) pass fromTime: (NSString *) startTime toTime:(NSString *) endTime atApplience:(NSString *) appl withVelocity: (NSString *)velocity;


@end
