//
//  TabBarViewController.h
//  Lumi
//
//  Created by PETAR LAZAROV on 8/17/15.
//  Copyright (c) 2015 PETAR LAZAROV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabBarViewController : UIViewController


-(void) homeButton;
-(void) homeButtonClicked:(UIButton*)sender;
-(void) connectButton;
-(void) connectButtonClicked:(UIButton*)sender;
-(void) accountButton;
-(void) accountButtonClicked:(UIButton*)sender;
-(void) statsButton;
-(void) statsButtonClicked:(UIButton*)sender;
-(void) locationButton;
-(void) locationButtonClicked:(UIButton*)sender;

@end
