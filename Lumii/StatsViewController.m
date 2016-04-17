//
//  StatsViewController.m
//  lumi
//
//  Created by PETAR LAZAROV on 8/16/15.
//  Copyright © 2015 PETAR LAZAROV. All rights reserved.
//

#import "StatsViewController.h"

@interface StatsViewController ()
@property UIImageView* lumi;

@end

@implementation StatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lumi =[[UIImageView alloc] initWithFrame:CGRectMake(0,15,35,35)];
    self.lumi.image=[UIImage imageNamed:@"lumi.png"];
    [self.view addSubview:self.lumi];}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    self.lumi =[[UIImageView alloc] initWithFrame:CGRectMake(0,15,35,35)];
    self.lumi.image=[UIImage imageNamed:@"lumi.png"];
    [self.view addSubview:self.lumi];
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
