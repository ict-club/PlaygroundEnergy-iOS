//
//  Register.h
//  Lumii
//
//  Created by Martin Kuvandzhiev on 8/16/15.
//  Copyright (c) 2015 PETAR LAZAROV. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *Username;
@property (weak, nonatomic) IBOutlet UITextField *Password;
@property (weak, nonatomic) IBOutlet UITextField *PasswordAgain;
@property (weak, nonatomic) IBOutlet UITextField *Email;
- (IBAction)registerButton:(UIButton *)sender;
- (BOOL)IsValidEmail:(NSString *)string;

@end
