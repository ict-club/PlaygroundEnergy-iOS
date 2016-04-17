//
//  Register.m
//  Lumii
//
//  Created by Martin Kuvandzhiev on 8/16/15.
//  Copyright (c) 2015 PETAR LAZAROV. All rights reserved.
//

#import "RegisterViewController.h"
#import "AccountViewController.h"
#import "dataBaseInteractions.h"

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.Password.secureTextEntry = true;
    self.PasswordAgain.secureTextEntry = true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backToTB:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:nil];
}
- (IBAction)registerButton:(UIButton *)sender {
    if([self.Password.text isEqualToString:self.PasswordAgain.text] == false)
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration unsuccessful"
                                                        message:@"Passwords doesn't match"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else if(self.Username.text.length < 5)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration unsuccessful"
                                                        message:@"Username must consist of 6 or more characters"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else if(self.Password.text.length < 5)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration unsuccessful"
                                                        message:@"Password must consist of 6 or more characters"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        
    }
        else
    {
      
        
        /*
         * Registration request
         */
        
        dataBaseInteractions *database = [[dataBaseInteractions alloc]init];
        NSString * resultString = [database registration:self.Username.text withPass:self.Password.text];
        NSString * successfulString = [NSString stringWithFormat:@"User %@ created", self.Username.text];
        if([resultString isEqualToString:successfulString])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration successful"
                                                            message:@"Thanks for registring to Lumi. You can now enter with your account"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
           // [self.presentingViewController dismissViewControllerAnimated:YES
            //                                                  completion:nil];
        }
        else
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration unsuccessful"
                                                            message:@"Username is used by another user. Please try with different username"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
        
        
    }
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.Username resignFirstResponder];
    [self.Password resignFirstResponder];
    [self.PasswordAgain resignFirstResponder];
    [self.Email resignFirstResponder];

    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.Username) {
        [self.Username resignFirstResponder];
    }
    if (self.Password) {
        [self.Password resignFirstResponder];
    }
    if (self.PasswordAgain) {
        [self.PasswordAgain resignFirstResponder];
    }
    if (self.Email) {
        [self.Email resignFirstResponder];
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

-(BOOL) IsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}


@end
