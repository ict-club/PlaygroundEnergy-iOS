//
//  PointsConversionViewController.m
//  Lumi
//
//  Created by PETAR LAZAROV on 8/25/15.
//  Copyright (c) 2015 PETAR LAZAROV. All rights reserved.
//

#import "PointsConversionViewController.h"
#import "dataBaseInteractions.h"
#import "coreDataController.h"
#import "userDataSaving.h"
#import "FacebookLoggedViewController.h"
#import "LoggedViewController.h"

@interface PointsConversionViewController ()

@end

@implementation PointsConversionViewController
NSInteger sliderValue;
NSInteger pointsValue;
dataBaseInteractions* interactions;
userDataSaving *data;
NSMutableArray * transactionCompanies;
NSNumber * changeRate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getUserDetails];
    dataBaseInteractions *database = [[dataBaseInteractions alloc]init];
    data = [[userDataSaving alloc]init];
    points.text = [NSString stringWithFormat:@"%d",[database getPoints:[data currentUser] withPass:[data currentPassword]]];
    pointsValue = [points.text intValue];
    interactions = [[dataBaseInteractions alloc] init];
    changeRate = [NSNumber numberWithInteger:0];
    username.text = [NSString stringWithFormat:@"%@",[data currentUser]];
    
    NSDictionary* company1 = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"Riot Games", @"Name", @"1.52", @"rate", nil];
    NSDictionary* company2 = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"TAO Games", @"Name", @"1.12", @"rate", nil];
    NSDictionary* company3 = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"Apple Inc", @"Name", @"5.12", @"rate", nil];
    NSDictionary* company4 = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"Blizzard Ent.", @"Name", @"2.314", @"rate", nil];
    NSDictionary* company5 = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"Steam Powered", @"Name", @"0.721", @"rate", nil];
    NSDictionary* company6 = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"Origin", @"Name", @"1.445", @"rate", nil];


    transactionCompanies = [NSMutableArray arrayWithObjects:company1,company2,company3, company4, company5, company6,nil];
    
    [self.tableView reloadData];
    NSInteger i;
    i = pointsValue/2;
    label.text = [NSString stringWithFormat:@"%ld", i];
    
}

- (IBAction)backToTB:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:nil];
}


- (IBAction) slider:(id)sender
{
    sliderValue = slider.value/10000 * pointsValue;
    label.text = [NSString stringWithFormat:@"%ld", sliderValue];
    self.convertedTo.text = [NSString stringWithFormat:@"%ld",(long)((float)sliderValue * [changeRate floatValue])];
    
}
- (IBAction)convertButton:(id)sender
{
    NSInteger pointsForTransaction;
    NSInteger pointAll;
    pointAll = [points.text intValue];
    pointsForTransaction = [label.text intValue];
    pointAll = pointAll - pointsForTransaction;
    NSLog(@"Change rate: %f", [changeRate floatValue]);
    if([changeRate floatValue] <= 0)
    {
        NSString* string = [NSString stringWithFormat:@"Must select company to send points"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error" message:string  delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [interactions pointsTransactionWithUserName:[data currentUser] withPass:[data currentPassword] withPoints:pointsForTransaction];
    
    
    
    
    
    NSString* string = [NSString stringWithFormat:@"You just converted %@ points", label.text];
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Announcement" message:string  delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    slider.value = 0;
    label.text = [NSString stringWithFormat:@"0"];
    self.convertedTo.text = [NSString stringWithFormat:@"0"];
    points.text = [NSString stringWithFormat:@"%ld", pointAll];
    dataBaseInteractions *database = [[dataBaseInteractions alloc]init];
    data = [[userDataSaving alloc]init];
    points.text = [NSString stringWithFormat:@"%d",[database getPoints:[data currentUser] withPass:[data currentPassword]]];
    pointsValue = [points.text intValue];
    
}

- (void) getUserDetails
{
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             self.FBuserid = [[FBSDKAccessToken currentAccessToken] userID];
             self.FBusername = [result valueForKey:@"name"];
             NSLog(@"Username got from getUserDetails = %@", self.FBusername);
             username.text = self.FBusername;
             // NSString *email =  [result valueForKey:@"email"];
         }
         else{
             NSLog(@"%@",error.localizedDescription);
         }
     }];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [transactionCompanies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:simpleTableIdentifier];
    }
    
    NSManagedObject *device = [transactionCompanies objectAtIndex:indexPath.row];
    
    //    [cell.textLabel setText:[pointsArray objectAtIndex:indexPath.row]];
    //    [cell.detailTextLabel setText:[dateArray objectAtIndex:indexPath.row]];
    
    [cell.textLabel setText:[NSString stringWithFormat:@"%@", [device valueForKey:@"Name"]]];
    //NSLocale* currentLocale = [NSLocale currentLocale];
    [cell.detailTextLabel setText:[device valueForKey:@"rate"]];
    
    //cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    changeRate = [NSNumber numberWithFloat:1/[[[transactionCompanies objectAtIndex:indexPath.row] valueForKey:@"rate"] floatValue]];
    self.convertedTo.text = [NSString stringWithFormat:@"%ld",(long)((float)sliderValue * [changeRate floatValue])];
}



@end
