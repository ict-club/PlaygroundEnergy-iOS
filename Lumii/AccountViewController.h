//
//  AccountViewController.h
//  lumi
//
//  Created by PETAR LAZAROV on 8/16/15.
//  Copyright © 2015 PETAR LAZAROV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface AccountViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *Username;
@property (weak, nonatomic) IBOutlet UITextField *Password;

@property (weak, nonatomic) IBOutlet UISwitch *rememberMeSwitch;
@property bool rememberMeState;
- (IBAction)rememberMeSwitch:(UISwitch *)sender;
- (IBAction)LoginButton:(UIButton *)sender;
- (IBAction)faceLogin:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *remLabel;
@property (weak, nonatomic) IBOutlet UIButton *RegisterButton;
@property (weak, nonatomic) IBOutlet UIButton *LoginButton;
@property (weak, nonatomic) IBOutlet UIButton *faceLogin;
@property (weak, nonatomic) IBOutlet UILabel *lumisLabel;


@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *pointsUsername;
@property (weak, nonatomic) IBOutlet UILabel *shareYourResultLabel;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UILabel *cameraLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareFB;
@property (weak, nonatomic) IBOutlet UIButton *shareTwitter;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBarAcc;
@property NSString* FBusername, *FBuserid;
@property (nonatomic, weak) UIView * facebookProfilePicture;




@end
