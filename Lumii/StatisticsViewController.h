//
//  StatisticsViewController.h
//  Lumii
//
//  Created by Martin Kuvandzhiev on 8/17/15.
//  Copyright (c) 2015 PETAR LAZAROV. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface StatisticsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property NSArray * dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *points;
@property NSString* FBusername, *FBuserid;


@end
