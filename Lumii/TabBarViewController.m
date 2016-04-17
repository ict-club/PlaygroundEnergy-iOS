//
//  TabBarViewController.m
//  Lumi
//
//  Created by PETAR LAZAROV on 8/17/15.
//  Copyright (c) 2015 PETAR LAZAROV. All rights reserved.
//

#import "TabBarViewController.h"
#import "AccountViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


-(void) showButtons
{
    [self homeButton];
    [self connectButton];
    [self accountButton];
    [self statsButton];
    [self locationButton];
    
}


-(void) homeButton
{
    NSLog(@"Home button touched");
    AccountViewController* acc = [[AccountViewController alloc] init];
    [self presentViewController:acc animated:YES completion:nil];

//    UIButton *but= [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [but addTarget:self action:@selector(homeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [but setFrame:CGRectMake(132, 252, 215, 40)];
//    [but setTitle:@"Login" forState:UIControlStateNormal];
//    [but setExclusiveTouch:YES];
//    
//    // if you like to add backgroundImage else no need
//    [but setBackgroundImage:[UIImage imageNamed:@"40home.png"] forState:UIControlStateNormal];
//    
//    [self.view addSubview:but];

}

-(void) homeButtonClicked:(UIButton*)sender
{
    NSLog(@"Home button touched");
}

-(void) connectButton
{
    UIButton *but= [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [but addTarget:self action:@selector(connectButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [but setFrame:CGRectMake(112, 252, 215, 40)];
    [but setTitle:@"Login" forState:UIControlStateNormal];
    [but setExclusiveTouch:YES];
    
    // if you like to add backgroundImage else no need
    [but setBackgroundImage:[UIImage imageNamed:@"40home.png"] forState:UIControlStateNormal];
    
    [self.view addSubview:but];
}

-(void) connectButtonClicked:(UIButton*)sender
{
    NSLog(@"Connect button touched");
}

-(void) accountButton
{
    UIButton *but= [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [but addTarget:self action:@selector(accountButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [but setFrame:CGRectMake(92, 252, 215, 40)];
    [but setTitle:@"Login" forState:UIControlStateNormal];
    [but setExclusiveTouch:YES];
    
    // if you like to add backgroundImage else no need
    [but setBackgroundImage:[UIImage imageNamed:@"40home.png"] forState:UIControlStateNormal];
    
    [self.view addSubview:but];
}

-(void) accountButtonClicked:(UIButton*)sender
{
    NSLog(@"Account button touched");
}

-(void) statsButton
{
    UIButton *but= [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [but addTarget:self action:@selector(statsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [but setFrame:CGRectMake(72, 252, 215, 40)];
    [but setTitle:@"Login" forState:UIControlStateNormal];
    [but setExclusiveTouch:YES];
    
    // if you like to add backgroundImage else no need
    [but setBackgroundImage:[UIImage imageNamed:@"40home.png"] forState:UIControlStateNormal];
    
    [self.view addSubview:but];
}

-(void) statsButtonClicked:(UIButton*)sender
{
    NSLog(@"Stats button touched");
}

-(void) locationButton
{
    UIButton *but= [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [but addTarget:self action:@selector(locationButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [but setFrame:CGRectMake(52, 252, 215, 40)];
    [but setTitle:@"Login" forState:UIControlStateNormal];
    [but setExclusiveTouch:YES];
    
    // if you like to add backgroundImage else no need
    [but setBackgroundImage:[UIImage imageNamed:@"40home.png"] forState:UIControlStateNormal];
    
    [self.view addSubview:but];
}

-(void) locationButtonClicked:(UIButton*)sender
{
    NSLog(@"Location button touched");
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
