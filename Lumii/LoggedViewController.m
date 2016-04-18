//
//  LoggedViewController.m
//  Lumii
//
//  Created by Martin Kuvandzhiev on 8/17/15.
//  Copyright (c) 2015 PETAR LAZAROV. All rights reserved.
//

#import "LoggedViewController.h"
#import "dataBaseInteractions.h"
#import "userDataSaving.h"
#import "AccountViewController.h"
#import <Social/Social.h>

@interface LoggedViewController ()

@end

@implementation LoggedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dataBaseInteractions *database = [[dataBaseInteractions alloc]init];
    userDataSaving *data = [[userDataSaving alloc]init];
    self.username.text = [data currentUser];
    self.points.text = [NSString stringWithFormat:@"%d",[database getPoints:[data currentUser] withPass:[data currentPassword]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)facebook:(id)sender {
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        
        NSString* str = [[NSString alloc] init];
        str = [NSString stringWithFormat:@"Congrats %@ you have earned %@ points",self.username.text, self.points.text];
        
        [controller addURL:[NSURL URLWithString:@"http://www.lumi.com"]];
        [controller addImage:[UIImage imageNamed:@"lumi.png"]];
        [controller setInitialText:str];
        
        [self presentViewController:controller animated:YES completion:Nil];
        
    }
  
}
- (IBAction)twitter:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        NSString* str = [[NSString alloc] init];
        str = [NSString stringWithFormat:@"Congrats %@ you have earned %@ points",self.username.text, self.points.text];
        [tweetSheet addURL:[NSURL URLWithString:@"http://www.appcoda.com"]];
        [tweetSheet addImage:[UIImage imageNamed:@"lumi.png"]];
        [tweetSheet setInitialText:str];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
}


- (IBAction)LogoutButton:(UIButton *)sender {
    userDataSaving *data = [[userDataSaving alloc]init];
    [data setCurrentUser:NULL];
    [data setCurrentPassword:NULL];
    [data setRememberMeState:false];
    
    AccountViewController *mainViewController = (AccountViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"AccountViewController"];
    mainViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:mainViewController animated:YES completion:nil];
    
    
    
}
@end
