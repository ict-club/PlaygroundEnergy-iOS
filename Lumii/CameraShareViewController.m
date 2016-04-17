//
//  CameraShareViewController.m
//  Lumi
//
//  Created by PETAR LAZAROV on 8/26/15.
//  Copyright (c) 2015 PETAR LAZAROV. All rights reserved.
//

#import "CameraShareViewController.h"

@interface CameraShareViewController ()

@end

@implementation CameraShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textField.delegate = self;

    
    [self doUpload];
}

- (IBAction)backToTB:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:nil];
}
-(void)doUpload
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload a photo" message:nil delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:@"Take a photo", @"Choose existing", nil];
    
    alert.alertViewStyle = UIAlertActionStyleDefault;
    [alert show];
}

- (IBAction)cameraPressed:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload a photo" message:nil delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:@"Take a photo", @"Choose existing", nil];
    
    alert.alertViewStyle = UIAlertActionStyleDefault;
    [alert show];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self presentViewController:imagePicker animated:YES completion:NULL];
        }
    if (buttonIndex == 2) {
        UIImagePickerController * imagePicker2 = [[UIImagePickerController alloc] init];
        imagePicker2.delegate = self;
        [self presentViewController:imagePicker2 animated:YES completion:NULL];
    }
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.imageToShare = UIImageJPEGRepresentation(image, 1.0);
    [self.imageView setImage:image];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)shareClicked:(id)sender {
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        
        NSString* str = [[NSString alloc] init];
        str = [NSString stringWithFormat:@"%@",self.textField.text];
        
        [controller addURL:[NSURL URLWithString:@"http://www.playgroundenrgy.com"]];
        [controller addImage:[UIImage imageWithData:self.imageToShare]];
        [controller setInitialText:str];
        
        [self presentViewController:controller animated:YES completion:NULL];
        
    }
    
    
    
    
}




-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.textField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.textField) {
        [self.textField resignFirstResponder];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
