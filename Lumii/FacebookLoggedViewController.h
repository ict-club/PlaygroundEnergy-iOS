//
//  FacebookLoggedViewController.h
//  Lumii
//
//  Created by Martin Kuvandzhiev on 8/18/15.
//  Copyright (c) 2015 PETAR LAZAROV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dataBaseInteractions.h"
#import "userDataSaving.h"
#import "AccountViewController.h"
#import <Social/Social.h>

@interface FacebookLoggedViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *points;
@property (weak, nonatomic) IBOutlet UIImageView *picture;
@property NSString* FBusername, *FBuserid;

- (IBAction)facebookLogoutButton:(UIButton *)sender;
- (IBAction)historyButton:(UIButton *)sender;
- (IBAction)shareViaFacebook:(UIButton *)sender;
- (IBAction)shareViaTwitter:(UIButton *)sender;



@end
