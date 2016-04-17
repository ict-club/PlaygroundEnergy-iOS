//
//  LoggedViewController.h
//  Lumii
//
//  Created by Martin Kuvandzhiev on 8/17/15.
//  Copyright (c) 2015 PETAR LAZAROV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoggedViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *points;
- (IBAction)LogoutButton:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;

@end
