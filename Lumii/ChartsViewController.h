//
//  ChartsViewController.h
//  Lumi
//
//  Created by PETAR LAZAROV on 8/25/15.
//  Copyright (c) 2015 PETAR LAZAROV. All rights reserved.
//

#import "ViewController.h"
#import "dataBaseInteractions.h"
#import "coreDataController.h"
#import "userDataSaving.h"
#import "FacebookLoggedViewController.h"
#import "LoggedViewController.h"

@interface ChartsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *myPositionLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;

-(void) jsonArrayToArray: (NSData *) data;
- (IBAction)ScrollToPosition:(UIButton *)sender;


@end
