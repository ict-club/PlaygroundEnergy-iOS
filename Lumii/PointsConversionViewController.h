//
//  PointsConversionViewController.h
//  Lumi
//
//  Created by PETAR LAZAROV on 8/25/15.
//  Copyright (c) 2015 PETAR LAZAROV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PointsConversionViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{

    IBOutlet UISlider *slider;
    IBOutlet UILabel *label;
    IBOutlet UILabel *points;
    IBOutlet UILabel *username;
}
@property NSString* FBusername, *FBuserid;
- (IBAction) slider:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *convertedTo;

@end


