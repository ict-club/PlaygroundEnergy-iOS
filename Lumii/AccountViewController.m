//
//  AccountViewController.m
//  lumi
//
//  Created by PETAR LAZAROV on 8/16/15.
//  Copyright © 2015 PETAR LAZAROV. All rights reserved.
//

#import "AccountViewController.h"
#import <Social/Social.h>
#import "userDataSaving.h"
#import "LoggedViewController.h"
#import "dataBaseInteractions.h"
#import "FacebookLoggedViewController.h"

@interface AccountViewController ()


@end

@implementation AccountViewController
float screenWidthIndex2;
float screenHeightIndex2;
NSInteger baseWidth2 = 375;
NSInteger baseHeight2 = 667;
- (void)viewDidLoad {
    [super viewDidLoad];
    [FBSDKProfilePictureView class];
    self.Password.secureTextEntry = true;
    self.rememberMeState = self.rememberMeSwitch.on;
    [self appearLoginScreen];
    userDataSaving * data = [[userDataSaving alloc]init];
    dataBaseInteractions *database = [[dataBaseInteractions alloc] init];
    self.userName.text = [data currentUser];
    self.pointsUsername.text = [NSString stringWithFormat:@"%d",[database getPoints:[data currentUser] withPass:[data currentPassword]]];
    
    
}

- (void) loaddata
{
    userDataSaving * data = [[userDataSaving alloc]init];
    dataBaseInteractions *database = [[dataBaseInteractions alloc] init];
    self.userName.text = [data currentUser];
    self.pointsUsername.text = [NSString stringWithFormat:@"%d",[database getPoints:[data currentUser] withPass:[data currentPassword]]];
}


-(void) viewDidAppear:(BOOL)animated
{
    NSLog(@"View appeared");
    userDataSaving * data = [[userDataSaving alloc]init];
    dataBaseInteractions *database = [[dataBaseInteractions alloc] init];
    [self loaddata];
    if([FBSDKAccessToken currentAccessToken])
    {
        NSLog(@"Facebook logging in");
        [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
      
        if([self.view.subviews containsObject:[self.view viewWithTag:8001]] == false)[self displayFacebookPicture];
        
        [self getUserDetails];
        [self displayFacebookPicture];
        [self appearLoggedInScreen];
    }
    else if([data rememberMeState] == true ) // if the user wants to be remembered or is logged in with facebook
    {
        if([database login:[data currentUser] withPass:[data currentPassword]] == true)
        {
            [self appearLoggedInScreen];
            
            
            
            //            LoggedViewController *mainViewController = (LoggedViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"LoggedViewController"];
            //            mainViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            //            [self presentViewController:mainViewController animated:YES completion:nil];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login unsuccessful"
                                                            message:@"Username or/and password incorrect. Please enter username and password again"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [data setRememberMeState:false];
        }
        
    }
    else{
        [data setFacebookLogin:false];
    }
    
    
}

- (IBAction)facebook:(id)sender {
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        
        NSString* str = [[NSString alloc] init];
        str = [NSString stringWithFormat:@"Congrats %@ you have earned %@ points",self.userName.text, self.pointsUsername.text];
        
        [controller addURL:[NSURL URLWithString:@"http://www.playgroundenergy.com"]];
        [controller addImage:[UIImage imageNamed:@"lumi.png"]];
        [controller setInitialText:str];
        
        [self presentViewController:controller animated:YES completion:Nil];
        
    }
    
}
- (IBAction)historyButton:(id)sender {
    [self.tabBarController setSelectedIndex:3];
}
- (IBAction)twitter:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        NSString* str = [[NSString alloc] init];
        str = [NSString stringWithFormat:@"Congrats %@ you have earned %@ points",self.userName.text, self.pointsUsername.text];
        [tweetSheet addURL:[NSURL URLWithString:@"http://playgroundenergy.com"]];
        [tweetSheet addImage:[UIImage imageNamed:@"lumi.png"]];
        [tweetSheet setInitialText:str];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
}


- (IBAction)LogoutButton:(UIButton *)sender {
    userDataSaving *data = [[userDataSaving alloc]init];
    [self appearLoginScreen];
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logOut];
    [data setCurrentUser:NULL];
    [data setCurrentPassword:NULL];
    [data setRememberMeState:false];
    [data setFacebookLogin:false];
    [self.facebookProfilePicture removeFromSuperview];
    
}

- (IBAction)rememberMeSwitch:(UISwitch *)sender {
    if(sender.on)
    {
        self.rememberMeState = true;
        NSLog(@"Remember me ON");
        
    }
    else
    {
        self.rememberMeState = false;
        NSLog(@"Remember me OFF");
    }
    
}

- (IBAction)LoginButton:(UIButton *)sender {
    
    dataBaseInteractions *database = [[dataBaseInteractions alloc]init];
    bool loginReturn = [database login: self.Username.text withPass:self.Password.text];
    if(loginReturn == true)
    {
        userDataSaving * data = [[userDataSaving alloc]init];
        [data setCurrentUser:self.Username.text];
        [data setCurrentPassword:self.Password.text];
        if(self.rememberMeState == true)
        {
            [data setRememberMeState:true];
        }
        
        [self appearLoggedInScreen];
        [self loaddata];
        
        
        
        //        LoggedViewController *mainViewController = (LoggedViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"LoggedViewController"];
        //        mainViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        //        [self presentViewController:mainViewController animated:YES completion:nil];
    }
    
    
    else
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login unsuccessful"
                                                        message:@"Username or/and password incorrect"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
}


- (IBAction)faceLogin:(UIButton *)sender {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:@[@"email", @"public_profile"] fromViewController:nil handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            // Process error
        } else if (result.isCancelled) {
            // Handle cancellations
        } else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if ([result.grantedPermissions containsObject:@"email"]) {
                // Do work
                NSLog(@"Profile - %@",[FBSDKProfile currentProfile].userID);
                NSLog(@"Profile - %@", [FBSDKAccessToken currentAccessToken].userID);
                //NSLog(@"name - %@", [FBSDKProfile currentProfile] );
                dataBaseInteractions *database = [[dataBaseInteractions alloc]init];
                bool loginReturn = [database login: [FBSDKAccessToken currentAccessToken].userID withPass:[FBSDKAccessToken currentAccessToken].userID];
                [self getUserDetails];
                [self appearLoggedInScreen];
                [self displayFacebookPicture];
                if(loginReturn == true)
                {
                    userDataSaving * data = [[userDataSaving alloc]init];
                    [data setCurrentUser:[FBSDKAccessToken currentAccessToken].userID];
                    [data setCurrentPassword:[FBSDKAccessToken currentAccessToken].userID];
                    //[data setFacebookLogin:true];
                }
                else
                {
                    dataBaseInteractions *database = [[dataBaseInteractions alloc]init];
                    NSString * resultString = [database registration:[FBSDKAccessToken currentAccessToken].userID withPass:[FBSDKAccessToken currentAccessToken].userID];
                    NSString * successfulString = [NSString stringWithFormat:@"User %@ created", [FBSDKAccessToken currentAccessToken].userID];
                    NSLog(@"Result string = %@", successfulString);
                    if([successfulString isEqualToString:resultString])
                    {
                        NSLog(@"Facebook user successfily registerd");
                        userDataSaving * data = [[userDataSaving alloc]init];
                        [data setCurrentUser:[FBSDKAccessToken currentAccessToken].userID];
                        [data setCurrentPassword:[FBSDKAccessToken currentAccessToken].userID];
                        [data setFacebookLogin:true];
                    }
                }
            }
        }
    }];
    NSLog(@"Facebook login successful");
}

- (void) getUserDetails
{
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name"}]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             self.FBuserid = [[FBSDKAccessToken currentAccessToken] userID];
             self.FBusername = [result valueForKey:@"name"];
             NSLog(@"Username got from getUserDetails = %@", self.FBusername);
             self.userName.text = self.FBusername;
             //NSString *email =  [result valueForKey:@"email"];
         }
         else{
             NSLog(@"%@",error.localizedDescription);
         }
     }];
}

- (void) displayFacebookPicture
{
    [FBSDKProfilePictureView class];
    [self getUserDetails];
    
    
    FBSDKProfilePictureView * profilePicture = [[FBSDKProfilePictureView alloc]initWithFrame:self.userIcon.frame];
    
    [profilePicture setProfileID:[FBSDKAccessToken currentAccessToken].userID];
    [profilePicture setPictureMode:FBSDKProfilePictureModeSquare];
    
    profilePicture.layer.cornerRadius = profilePicture.frame.size.width / 2;
    profilePicture.clipsToBounds = YES;
    
    profilePicture.layer.borderColor = [UIColor lightGrayColor].CGColor;
    profilePicture.layer.borderWidth = 1.0;
    
    self.facebookProfilePicture = profilePicture;
    self.facebookProfilePicture.tag = 8001;
    [self.view addSubview:self.facebookProfilePicture];
    
}

- (void) hideFacebookPicture
{
    [self.facebookProfilePicture removeFromSuperview];
    UIView * v = [self.view viewWithTag:8001];
    [v removeFromSuperview];

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.Password resignFirstResponder];
    [self.Username resignFirstResponder];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.Password) {
        [self.Password resignFirstResponder];
    }
    if (self.Username) {
        [self.Username resignFirstResponder];
    }
    return NO;
}
-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y - 170.0), self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}
-(void) textFieldDidEndEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y + 170.0), self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
}
- (void) appearLoginScreen
{
    for (UIView *subview in [self.view subviews]) {
        if (subview.tag == 8001) {
            [subview removeFromSuperview];
        }
    }
    
    self.userIcon.hidden = YES;
    self.userName.hidden = YES;
    self.pointsUsername.hidden = YES;
    self.shareYourResultLabel.hidden = YES;
    self.cameraButton.hidden = YES;
    self.cameraLabel.hidden = YES;
    self.shareFB.hidden = YES;
    self.shareTwitter.hidden = YES;
    self.navigationBarAcc.hidden = YES;
    self.lumisLabel.hidden = YES;
    
    self.Username.hidden = NO;
    self.Password.hidden = NO;
    self.rememberMeSwitch.hidden = NO;
    self.remLabel.hidden = NO;
    self.LoginButton.hidden = NO;
    self.RegisterButton.hidden = NO;
    self.faceLogin.hidden = NO;
    
    [self hideFacebookPicture];
    
    
    
   // NSLog(@"%lu", (unsigned long)self.view.subviews.count);
//    if(self.view.subviews.count > 0)
//    {
//        for(int i = 0 ; i < self.view.subviews.count ; i++)
//        {
//            UIView *v = [self.view.subviews objectAtIndex:i];
//            NSLog(@"%@", v);
//            if([v isKindOfClass:[FBSDKProfilePictureView class]])
//            {
//                [v removeFromSuperview];
//                [v setHidden:true];
//                NSLog(@"CHUSKIII");
//            }
//        }
//    }
//
//                UIView *v = [self.view.subviews objectAtIndex:6];
//                if([v isMemberOfClass:[FBSDKProfilePictureView class]]) [v removeFromSuperview];
    
    
//    
   
}
- (void) appearLoggedInScreen
{
    self.userIcon.hidden = NO;
    self.userName.hidden = NO;
    self.pointsUsername.hidden = NO;
    self.shareYourResultLabel.hidden = NO;
    self.cameraButton.hidden = NO;
    self.cameraLabel.hidden = NO;
    self.shareFB.hidden = NO;
    self.shareTwitter.hidden = NO;
    self.navigationBarAcc.hidden = NO;
    self.lumisLabel.hidden = NO;
    
    self.Username.hidden = YES;
    self.Password.hidden = YES;
    self.rememberMeSwitch.hidden = YES;
    self.remLabel.hidden = YES;
    self.LoginButton.hidden = YES;
    self.RegisterButton.hidden = YES;
    self.faceLogin.hidden = YES;

}
@end
