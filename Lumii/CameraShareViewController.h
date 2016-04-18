//
//  CameraShareViewController.h
//  Lumi
//
//  Created by PETAR LAZAROV on 8/26/15.
//  Copyright (c) 2015 PETAR LAZAROV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>

@interface CameraShareViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIAlertViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *textField;


@property(strong, nonatomic) SLComposeServiceViewController* slComposeViewController;
@property(strong, nonatomic) NSData* imageToShare;


@end
