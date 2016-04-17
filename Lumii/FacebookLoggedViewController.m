//
//  FacebookLoggedViewController.m
//  Lumii
//
//  Created by Martin Kuvandzhiev on 8/18/15.
//  Copyright (c) 2015 PETAR LAZAROV. All rights reserved.
//

#import "FacebookLoggedViewController.h"

@interface FacebookLoggedViewController ()

@end

@implementation FacebookLoggedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [FBSDKProfilePictureView class];
     //[FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    // Do any additional setup after loading the view.
    [self getUserDetails];
    dataBaseInteractions *database = [[dataBaseInteractions alloc]init];
    userDataSaving *data = [[userDataSaving alloc]init];
    self.points.text = [NSString stringWithFormat:@"%d",[database getPoints:[data currentUser] withPass:[data currentPassword]]];
    
    NSLog(@"Current user : %@", data.currentUser);
    NSLog(@"Current password : %@", data.currentPassword);
    
    
    FBSDKProfilePictureView * profilePicture = [[FBSDKProfilePictureView alloc]initWithFrame:self.picture.frame];
    [profilePicture setProfileID:[FBSDKAccessToken currentAccessToken].userID];
    [profilePicture setPictureMode:FBSDKProfilePictureModeSquare];
    
    profilePicture.layer.cornerRadius = profilePicture.frame.size.width / 2;
    profilePicture.clipsToBounds = YES;
    
//    profilePicture.layer.cornerRadius = 30.0;
//    profilePicture.clipsToBounds=YES;
    profilePicture.layer.borderColor = [UIColor lightGrayColor].CGColor;
    profilePicture.layer.borderWidth = 1.0;

    [self.view addSubview:profilePicture];
    
}

- (void) viewDidAppear:(BOOL)animated
{
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


- (IBAction)facebookLogoutButton:(UIButton *)sender {
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logOut];
    userDataSaving *data = [[userDataSaving alloc]init];
    [data setCurrentUser:NULL];
    [data setCurrentPassword:NULL];
    [data setRememberMeState:false];
    [data setFacebookLogin:false];
    
    AccountViewController *mainViewController = (AccountViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"AccountViewController"];
    mainViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:mainViewController animated:YES completion:nil];

}

- (IBAction)historyButton:(UIButton *)sender {
    [self.tabBarController setSelectedIndex:3];
}

- (IBAction)shareViaFacebook:(UIButton *)sender {
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

- (IBAction)shareViaTwitter:(UIButton *)sender {
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

- (void) getUserDetails
{
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             self.FBuserid = [[FBSDKAccessToken currentAccessToken] userID];
             self.FBusername = [result valueForKey:@"name"];
             NSLog(@"Username got from getUserDetails = %@", self.FBusername);
             self.username.text = self.FBusername;
            // NSString *email =  [result valueForKey:@"email"];
         }
         else{
             NSLog(@"%@",error.localizedDescription);
         }
     }];
}

@end
