//
//  ChartsViewController.m
//  Lumi
//
//  Created by PETAR LAZAROV on 8/25/15.
//  Copyright (c) 2015 PETAR LAZAROV. All rights reserved.
//

#import "ChartsViewController.h"


@interface ChartsViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControlUsersPlaygrounds;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControlForPeriodOfTime;
@property dataBaseInteractions* interactions;

@end

@implementation ChartsViewController
NSInteger day = 1;
NSInteger week = 7;
NSInteger month = 30;
NSInteger allTime = 365;
NSData * responseData;
NSMutableArray * arrayWithData;
int chartTypeSelected = 0;
int myPosition = 0;


- (void)viewDidLoad
{
    [super viewDidLoad];
    chartTypeSelected = 0;
    self.interactions = [[dataBaseInteractions alloc] init];
    responseData = [[self.interactions usersChartForTime:day] dataUsingEncoding:NSUTF8StringEncoding];
    [self jsonArrayToArray: responseData];
    [self.tableView reloadData];
}


- (IBAction)segmentUsersOrPlaygrounds:(UISegmentedControl *)sender
{
    [self callSegmentControlTransactions];
}
- (IBAction)segmentForPeriodOfTime:(UISegmentedControl *)sender
{
    [self callSegmentControlTransactions];
}
- (IBAction)backToTB:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:nil];
}
- (void) callSegmentControlTransactions
{
    //selected users
    chartTypeSelected = (int)self.segmentControlUsersPlaygrounds.selectedSegmentIndex;
    if (self.segmentControlUsersPlaygrounds.selectedSegmentIndex == 0)
    {
        self.myPositionLabel.hidden = false;
        self.positionLabel.hidden = false;
        self.positionLabel.text = @"---";
        switch (self.segmentControlForPeriodOfTime.selectedSegmentIndex)
        {
                
            case 0:
                responseData = [[self.interactions usersChartForTime:day] dataUsingEncoding:NSUTF8StringEncoding];
                [self jsonArrayToArray: responseData];
                break;
            case 1:
                responseData = [[self.interactions usersChartForTime:week] dataUsingEncoding:NSUTF8StringEncoding];
                [self jsonArrayToArray: responseData];

                break;
            case 2:
                responseData = [[self.interactions usersChartForTime:month] dataUsingEncoding:NSUTF8StringEncoding];
                [self jsonArrayToArray: responseData];

                break;
            case 3:
                responseData = [[self.interactions usersChartForTime:allTime] dataUsingEncoding:NSUTF8StringEncoding];
                [self jsonArrayToArray: responseData];

                break;
            default:
                break;
        }
    }
    if (self.segmentControlUsersPlaygrounds.selectedSegmentIndex == 1)
    {
        //selected playgrounds
         self.myPositionLabel.hidden = true;
        self.positionLabel.hidden = true;
        switch (self.segmentControlForPeriodOfTime.selectedSegmentIndex)
        {
               
            case 0:
                responseData = [[self.interactions playgroundChartForTime:day] dataUsingEncoding:NSUTF8StringEncoding];
                [self jsonArrayToArray: responseData];

                break;
            case 1:
                responseData = [[self.interactions playgroundChartForTime:week] dataUsingEncoding:NSUTF8StringEncoding];
                [self jsonArrayToArray: responseData];

                break;
            case 2:
                responseData = [[self.interactions playgroundChartForTime:month] dataUsingEncoding:NSUTF8StringEncoding];
                [self jsonArrayToArray: responseData];

                break;
            case 3:
                responseData = [[self.interactions playgroundChartForTime:allTime] dataUsingEncoding:NSUTF8StringEncoding];
                [self jsonArrayToArray: responseData];

                break;
            default:
                break;
        }
    }
}




- (void)didReceiveMemoryWarning
{
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

- (void) jsonArrayToArray: (NSData *) data
{
    NSError *e;
    NSMutableArray *jsonList = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&e];
    arrayWithData = jsonList;
    
        for(int i=0;i<[arrayWithData count];i++)
    {
        NSLog(@"%@",[jsonList objectAtIndex:i]);
        //NSLog(@"%@",[[jsonList objectAtIndex:i]objectForKey:@"reward_points"]);
    }
    [self.tableView reloadData];
}

- (IBAction)ScrollToPosition:(UIButton *)sender {
    [self.tableView reloadData];
    NSIndexPath *indexPat = [NSIndexPath indexPathForRow:myPosition-1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPat atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [arrayWithData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:simpleTableIdentifier];
    }
    
    NSManagedObject *device = [arrayWithData objectAtIndex:indexPath.row];
    
    //    [cell.detailTextLabel setText:[dateArray objectAtIndex:indexPath.row]];
    userDataSaving * data = [[userDataSaving alloc]init];
    if([[device valueForKey:@"user_email"] caseInsensitiveCompare:data.currentUser] == NSOrderedSame)
    {
        myPosition = (int)indexPath.row+1;
        self.positionLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
        [cell.textLabel setTextColor:[UIColor blueColor]];
    }
    else
    {
        [cell.textLabel setTextColor:[UIColor blackColor]];
    }
    
    if(chartTypeSelected == 0)
    [cell.textLabel setText:[NSString stringWithFormat:@"%ld. %@",indexPath.row + 1, [device valueForKey:@"user_email"]]];
    else
        
    {
        [cell.textLabel setText:[NSString stringWithFormat:@"Playground ID : %@", [device valueForKey:@"id"]]];
        cell.textLabel.textColor = [UIColor blackColor];
    }
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@ points", [device valueForKey:@"reward_points"]]];
    return cell;
}



@end
