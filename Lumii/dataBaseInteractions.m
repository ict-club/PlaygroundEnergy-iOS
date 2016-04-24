//
//  dataBaseInteractions.m
//  Lumii
//
//  Created by Martin Kuvandzhiev on 8/17/15.
//  Copyright (c) 2015 PETAR LAZAROV. All rights reserved.
//

#import "dataBaseInteractions.h"

@implementation dataBaseInteractions

- (bool) login:(NSString *) name withPass:(NSString *) pass
{
    NSString* hide = [NSString stringWithFormat:@"Success"];
    NSString *post = [NSString stringWithFormat:@""];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString* req = [NSString stringWithFormat:@"{\"username\":\"%@\",\"password\":\"%@\"}",name, pass];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSMutableURLRequest *request;
    request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://www.rapiddevcrew.com/Lumi/"]];
    
    
    
    [request setHTTPMethod:@"POST"];
    [request setValue:req forHTTPHeaderField:@"Credentials"];
    [request setHTTPBody:postData];
    
    
    NSURLResponse *requestResponse;
    NSData *requestHandler = [NSURLConnection sendSynchronousRequest:request returningResponse:&requestResponse error:nil];
    
    NSString *requestReply = [[NSString alloc] initWithBytes:[requestHandler bytes] length:[requestHandler length] encoding:NSASCIIStringEncoding];
    NSLog(@"requestReply: %@", requestReply);
    
    if ([requestReply isEqualToString:hide]) { return true; }
    else return false;

}

- (NSString *) registration:(NSString *) user withPass:(NSString *) pass
{
    NSString *post = [NSString stringWithFormat:@""];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString * jsonData = [NSString stringWithFormat:@"{\"username\":\"%@\",\"password\":\"%@\"}", user, pass];
    NSLog(@"%@", jsonData);
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSMutableURLRequest *request;
    request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://www.rapiddevcrew.com/Lumi/register"]];
    [request setHTTPMethod:@"POST"];
    
    [request setValue: jsonData forHTTPHeaderField:@"Data"];
    [request setHTTPBody:postData];
    
    NSURLResponse *requestResponse;
    NSData *requestHandler = [NSURLConnection sendSynchronousRequest:request returningResponse:&requestResponse error:nil];
    
    NSString *requestReply = [[NSString alloc] initWithBytes:[requestHandler bytes] length:[requestHandler length] encoding:NSASCIIStringEncoding];
    NSLog(@"requestReply: %@", requestReply);
    return requestReply;
}

- (int) getPoints:(NSString *) user withPass:(NSString *) pass
{
    
    NSString *post = [NSString stringWithFormat:@""];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString * jsonData = [NSString stringWithFormat:@"{\"username\":\"%@\",\"password\":\"%@\"}", user, pass];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSMutableURLRequest *request;
    request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://www.rapiddevcrew.com/Lumi/getAllPoints"]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:jsonData forHTTPHeaderField:@"Credentials"];
    [request setHTTPBody:postData];
    
    NSURLResponse *requestResponse;
    NSData *requestHandler = [NSURLConnection sendSynchronousRequest:request returningResponse:&requestResponse error:nil];
    
    NSString *requestReply = [[NSString alloc] initWithBytes:[requestHandler bytes] length:[requestHandler length] encoding:NSASCIIStringEncoding];
    //NSLog(@"requestReply: %@", requestReply);
    
    NSString *newStr = [requestReply substringWithRange:NSMakeRange(12, [requestReply length]-12)];
    NSString *points = [newStr substringToIndex:[newStr length]-2];
    return [points integerValue];

}

- (NSString *) postTransaction:(int)points forUser:(NSString *)user withPass:(NSString *)pass fromTime:(NSString *)startTime toTime:(NSString *)endTime atApplience:(NSString *)appl withVelocity:(NSString *)velocity
{

        NSString* req = [NSString stringWithFormat:@"{\"username\":\"%@\",\"appliance\":\"%@\", \"time_from\": \"%@\",\"time_to\": \"%@\", \"velocity\":\"%@\", \"reward_points\":\"%d\"}", user, appl, startTime, endTime,  velocity, points];
    NSString * userdata = [NSString stringWithFormat:@"{\"username\":\"%@\",\"password\":\"%@\"}", user, pass];
    NSLog(@"%@", userdata);
        NSLog(@"%@",req);
    
    
       NSString *post = [NSString stringWithFormat:@""];
       NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
       NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
       NSMutableURLRequest *request;
       request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:@"http://www.rapiddevcrew.com/Lumi/postTransaction"]];
    
    

        [request setHTTPMethod:@"POST"];
        [request setValue:userdata forHTTPHeaderField:@"Credentials"];
        [request setValue:req forHTTPHeaderField:@"Data"];
        [request setHTTPBody:postData];
    
    
    
        NSURLResponse *requestResponse;
        NSData *requestHandler = [NSURLConnection sendSynchronousRequest:request returningResponse:&requestResponse error:nil];
    
        NSString *requestReply = [[NSString alloc] initWithBytes:[requestHandler bytes] length:[requestHandler length] encoding:NSASCIIStringEncoding];
        NSLog(@"requestReply: %@", requestReply);
    
    return requestReply;
    
}

- (NSString*) playgroundChartForTime:(NSInteger)period
{
    NSString *post = [NSString stringWithFormat:@""];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString * jsonData = [NSString stringWithFormat:@"{\"period\":\"%ld\"}", period];
    NSLog(@"%@", jsonData);
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSMutableURLRequest *request;
    request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://www.rapiddevcrew.com/Lumi/playgroundChartForTime"]];
    [request setHTTPMethod:@"POST"];
    
    [request setValue: jsonData forHTTPHeaderField:@"Credentials"];
    [request setHTTPBody:postData];
    
    NSURLResponse *requestResponse;
    NSData *requestHandler = [NSURLConnection sendSynchronousRequest:request returningResponse:&requestResponse error:nil];
    
    NSString *requestReply = [[NSString alloc] initWithBytes:[requestHandler bytes] length:[requestHandler length] encoding:NSASCIIStringEncoding];
    NSLog(@"requestReply: %@", requestReply);
    return requestReply;
}
- (NSString*) usersChartForTime:(NSInteger)period
{
    NSString *post = [NSString stringWithFormat:@""];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString * jsonData = [NSString stringWithFormat:@"{\"period\":\"%ld\"}", period];
    NSLog(@"%@", jsonData);
//    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSMutableURLRequest *request;
    request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://www.rapiddevcrew.com/Lumi/userchartForTime"]];
    [request setHTTPMethod:@"POST"];
    
    [request setValue: jsonData forHTTPHeaderField:@"Credentials"];
    [request setHTTPBody:postData];
    
    NSURLResponse *requestResponse;
    NSData *requestHandler = [NSURLConnection sendSynchronousRequest:request returningResponse:&requestResponse error:nil];
    
    NSString *requestReply = [[NSString alloc] initWithBytes:[requestHandler bytes] length:[requestHandler length] encoding:NSASCIIStringEncoding];
    //NSLog(@"requestReply: %@", requestReply);
    return requestReply;
}
- (NSString*) pointsTransactionWithUserName:(NSString*)username withPass:(NSString*)password withPoints:(NSInteger)points
{
    NSString* req = [NSString stringWithFormat:@"{\"username\":\"%@\",\"password\":\"%@\", \"points\": \"%ld\"}", username, password, points];
    NSLog(@"%@",req);
    NSString *post = [NSString stringWithFormat:@""];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
//    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSMutableURLRequest *request;
    request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://www.rapiddevcrew.com/Lumi/pointsTransaction"]];
    [request setHTTPMethod:@"POST"];
//    [request setValue:userdata forHTTPHeaderField:@"Credentials"];
    [request setValue:req forHTTPHeaderField:@"Credentials"];
    [request setHTTPBody:postData];
    NSURLResponse *requestResponse;
    NSData *requestHandler = [NSURLConnection sendSynchronousRequest:request returningResponse:&requestResponse error:nil];
    
    NSString *requestReply = [[NSString alloc] initWithBytes:[requestHandler bytes] length:[requestHandler length] encoding:NSASCIIStringEncoding];
    //NSLog(@"requestReply: %@", requestReply);
    
    return requestReply;
    
}



@end
