//
//  StatisticsViewController.m
//  Lumii
//
//  Created by Martin Kuvandzhiev on 8/17/15.
//  Copyright (c) 2015 PETAR LAZAROV. All rights reserved.
//

#import "StatisticsViewController.h"
#import "coreDataController.h"
#import "userDataSaving.h"
#import "FacebookLoggedViewController.h"
#import "LoggedViewController.h"
#import "PointsConversionViewController.h"


@interface StatisticsViewController ()

@end

@implementation StatisticsViewController
NSMutableArray * dateArray;
NSMutableArray * pointsArray;
NSMutableArray * userPointsArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    //coreDataController * coreData = [[coreDataController alloc]init];
    
    
    self.dataArray = [NSArray alloc];
    dateArray = [[NSMutableArray alloc]init];
    pointsArray = [[NSMutableArray alloc]init];
    
    
    [self getUserDetails];
    dataBaseInteractions *database = [[dataBaseInteractions alloc]init];
    userDataSaving *data = [[userDataSaving alloc]init];
    self.points.text = [NSString stringWithFormat:@"%d",[database getPoints:[data currentUser] withPass:[data currentPassword]]];
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    userDataSaving * data = [[userDataSaving alloc]init];
    // Fetch the devices from persistent data store
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Lumi"];
    pointsArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSMutableIndexSet *indexesToDelete = [NSMutableIndexSet indexSet];
    for(int i = 0; i < [pointsArray count]; i++)
    {
        NSManagedObject *dateObject = [pointsArray objectAtIndex:i];
        if(![[dateObject valueForKey:@"user"] isEqualToString:data.currentUser])
        {
            [indexesToDelete addIndex:i];
        }
    }
    [pointsArray removeObjectsAtIndexes:indexesToDelete];
    [self.tableView reloadData];
    [self loaddata];
}

- (void) loaddata
{
    dataBaseInteractions *database = [[dataBaseInteractions alloc]init];
    userDataSaving *data = [[userDataSaving alloc]init];
    self.points.text = [NSString stringWithFormat:@"%d",[database getPoints:[data currentUser] withPass:[data currentPassword]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}
- (void) getUserDetails
{
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             self.FBuserid = [[FBSDKAccessToken currentAccessToken] userID];
             self.FBusername = [result valueForKey:@"name"];
             NSLog(@"Username got from getUserDetails = %@", self.FBusername);
             self.username.text = self.FBusername;
             // NSString *email =  [result valueForKey:@"email"];
         }
         else{
             NSLog(@"%@",error.localizedDescription);
         }
     }];
}
//- (void)setFetchedResultsController:(NSFetchedResultsController*)fetchedResultsController
//{
//    _fetchedResultsController = fetchedResultsController;
//    fetchedResultsController.delegate = self;
//    [fetchedResultsController performFetch:NULL];
//}


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
    
    return [pointsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   
    
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    NSManagedObject *device = [pointsArray objectAtIndex:[pointsArray count] - (indexPath.row + 1)];
    
    if ([[device valueForKey:@"points"] isEqualToString:@"0"]) {
       
    }else {
    [cell.textLabel setText:[NSString stringWithFormat:@"%@ Points Earned", [device valueForKey:@"points"]]];
    //NSLocale* currentLocale = [NSLocale currentLocale];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:[device valueForKey:@"date"]]]];
    
    //cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    }
    return cell;
}



- (IBAction)backButton:(UIBarButtonItem *)sender {
    userDataSaving *data = [[userDataSaving alloc]init];
    if(data.facebookLogin == false)
    {
        LoggedViewController *mainViewController = (LoggedViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"LoggedViewController"];
        mainViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:mainViewController animated:YES completion:nil];
        
        
    }
    else{
        FacebookLoggedViewController *mainViewController = (FacebookLoggedViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"FacebookLoggedViewController"];
        mainViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:mainViewController animated:YES completion:nil];
    }
}
@end
