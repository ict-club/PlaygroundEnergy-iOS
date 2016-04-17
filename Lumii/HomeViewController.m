//
//  HomeViewController.m
//  lumi
//
//  Created by PETAR LAZAROV on 8/16/15.
//  Copyright © 2015 PETAR LAZAROV. All rights reserved.
//

#import "HomeViewController.h"
#import "dataBaseInteractions.h"
#import "userDataSaving.h"
#import "AccountViewController.h"
#import "ConnectViewController.h"
#import "TabBarViewController.h"
#import "PointsConversionViewController.h"
#import "CameraShareViewController.h"

@interface HomeViewController ()
@property UIButton* button1;
@property UIButton* button2;
@property UIButton* button3;
@property UIButton* button4;
@property UIButton* button5;
@property UIImageView* balloon1;
@property UIImageView* balloon2;
@property UIImageView* balloon3;
@property UIImageView* balloon4;
@property UIImageView* balloon5;
@property UIImageView* lumi;
@property UIImageView* cameraBalloon;
@property UILabel* myLabel;
@property UILabel* myLabel1;
@property UILabel* myLabel2;
@property UILabel* myLabel3;
@property UILabel* myLabel4;

@property (nonatomic) IBOutlet UIView *overlayView;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *delayedPhotoButton;
@property (nonatomic) NSMutableArray *capturedImages;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (nonatomic) UIImagePickerController *imagePickerController;

@end

@implementation HomeViewController
NSMutableURLRequest *request;
NSString* userName;
NSString* pass;
float screenWidthIndex;
float screenHeightIndex;
float screenHeightIndex22;
float screenWidthIndex11;
float screenWidthIndex22;
float screenWidthSharePic = 1;


NSInteger baseWidth = 375;
NSInteger baseHeight = 667;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.lumi =[[UIImageView alloc] initWithFrame:CGRectMake(0,15,35,35)];
    self.lumi.image=[UIImage imageNamed:@"lumi.png"];
    [self.view addSubview:self.lumi];
    
    [self myTimerTick:0];
    
    // Do any additional setup after loading the view, typically from a nib.
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(myTimerTick:) userInfo:nil repeats:YES];
    [NSThread detachNewThreadSelector:@selector(myTimerTick:) toTarget:self withObject:nil];
    
    self.capturedImages = [[NSMutableArray alloc] init];
    dataBaseInteractions *database = [[dataBaseInteractions alloc]init];
    userDataSaving *data = [[userDataSaving alloc]init];
    self.username.text = [data currentUser];
    self.points.text = [NSString stringWithFormat:@"%d",[database getPoints:[data currentUser] withPass:[data currentPassword]]];
    userName = [data currentUser];
    pass = [NSString stringWithFormat:@"%d",[database getPoints:[data currentUser] withPass:[data currentPassword]]];
    NSLog(@"%@%@", userName, pass);
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
    }
    [self sizeSettings];
    [self loaddata];
    
    if (self.view.frame.size.height == 1024) {
        screenWidthIndex = screenWidthIndex * 0.75;
        screenWidthSharePic = screenWidthSharePic*1.03;
        screenHeightIndex22 = screenHeightIndex*1.2;
        screenWidthIndex22 = screenWidthIndex*1.2;

    }
    
//    [self loadBalloons];
}
-(void)viewWillAppear:(BOOL)animated {
    [self loadBalloons];
}
-(void)viewWillDisappear:(BOOL)animated {
    [self.balloon1 removeFromSuperview];
    [self.balloon2 removeFromSuperview];
    [self.balloon3 removeFromSuperview];
    [self.balloon4 removeFromSuperview];
    [self.balloon5 removeFromSuperview];
}
- (void) sizeSettings
{
    screenWidthIndex = self.view.frame.size.width / baseWidth;
    screenWidthIndex11 = screenWidthIndex;
    screenWidthIndex22 = screenWidthIndex;
    screenHeightIndex = self.view.frame.size.height / baseHeight;
    screenHeightIndex22 = screenHeightIndex;
}

- (void) loaddata
{
    dataBaseInteractions *database = [[dataBaseInteractions alloc]init];
    userDataSaving *data = [[userDataSaving alloc]init];
    self.username.text = [data currentUser];
    self.myLabel2.text = [NSString stringWithFormat:@"%d",[database getPoints:[data currentUser] withPass:[data currentPassword]]];
}

- (IBAction)go:(id)sender
{
    ConnectViewController* acc = [[ConnectViewController alloc] init];
    [self presentViewController:acc animated:NO completion:nil];
}
- (void) loadBalloons {
    
    
    self.balloon1 =[[UIImageView alloc] initWithFrame:CGRectMake((140-20)*screenWidthIndex11,(150+80)*screenHeightIndex,(110*1.4)*screenWidthIndex22,(150*1.4)*screenHeightIndex22)];
    self.balloon1.image=[UIImage imageNamed:@"balloon_blue.png"];
//    [self.balloon1 setUserInteractionEnabled:YES];
//    UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ballon1Tap:)];
//    [singleTap setNumberOfTapsRequired:1];
//    [self.balloon1 addGestureRecognizer:singleTap];
    [self.view addSubview:self.balloon1];
    
    self.button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button1 addTarget:self action:@selector(actionButton1) forControlEvents:UIControlEventTouchUpInside];
    [self.button1 setTitle:@"" forState:UIControlStateNormal];
    self.button1.frame = CGRectMake((140-20)*screenWidthIndex11,(150+80)*screenHeightIndex,(110*1.4)*screenWidthIndex22,(150*1.4)*screenHeightIndex22);
    [self.view addSubview:self.button1];
    
    self.balloon2 =[[UIImageView alloc] initWithFrame:CGRectMake((30-8)*screenWidthIndex11,(280+80)*screenHeightIndex,(110*1.2)*screenWidthIndex22,(150*1.2)*screenHeightIndex22)];
    self.balloon2.image=[UIImage imageNamed:@"balloon_green.png"];
    self.balloon2.tag = 2;
//    [self.balloon2 setUserInteractionEnabled:YES];
//    UITapGestureRecognizer *singleTap1 =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ballon2Tap:)];
//    [singleTap1 setNumberOfTapsRequired:1];
//    [self.balloon2 addGestureRecognizer:singleTap1];
    [self.view addSubview:self.balloon2];
    
    self.button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button2 addTarget:self action:@selector(actionButton2) forControlEvents:UIControlEventTouchUpInside];
    [self.button2 setTitle:@"" forState:UIControlStateNormal];
    self.button2.frame = CGRectMake((30-8)*screenWidthIndex11,(280+80)*screenHeightIndex,(110*1.2)*screenWidthIndex22,(150*1.2)*screenHeightIndex22);
    [self.view addSubview:self.button2];
    
    self.balloon3 =[[UIImageView alloc] initWithFrame:CGRectMake((240-7)*screenWidthIndex11,(300+80)*screenHeightIndex,(110*1.2)*screenWidthIndex22,(150*1.2)*screenHeightIndex22)];
    self.balloon3.image=[UIImage imageNamed:@"balloon_red.png"];
//    [self.balloon3 setUserInteractionEnabled:YES];
//    UITapGestureRecognizer *singleTap2 =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ballon3Tap:)];
//    [singleTap2 setNumberOfTapsRequired:1];
//    [self.balloon3 addGestureRecognizer:singleTap2];
    [self.view addSubview:self.balloon3];
    
    self.button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button3 addTarget:self action:@selector(actionButton3) forControlEvents:UIControlEventTouchUpInside];
    [self.button3 setTitle:@"" forState:UIControlStateNormal];
    self.button3.frame = CGRectMake((240-7)*screenWidthIndex11,(300+80)*screenHeightIndex,(110*1.2)*screenWidthIndex22,(150*1.2)*screenHeightIndex22);
    [self.view addSubview:self.button3];
    
    self.balloon4 =[[UIImageView alloc] initWithFrame:CGRectMake((230-10)*screenWidthIndex11,(210-180+60)*screenHeightIndex,(110*1.2)*screenWidthIndex22,(150*1.2)*screenHeightIndex22)];
    self.balloon4.image=[UIImage imageNamed:@"balloon_yellow.png"];
//    [self.balloon4 setUserInteractionEnabled:YES];
//    UITapGestureRecognizer *singleTap4 =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ballon5Tap:)];
//    [singleTap2 setNumberOfTapsRequired:1];
//    [self.balloon4 addGestureRecognizer:singleTap4];
    [self.view addSubview:self.balloon4];
    
    self.button4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button4 addTarget:self action:@selector(actionButton5) forControlEvents:UIControlEventTouchUpInside];
    [self.button4 setTitle:@"" forState:UIControlStateNormal];
    self.button4.frame = CGRectMake((230-10)*screenWidthIndex11,(210-180+60)*screenHeightIndex,(110*1.2)*screenWidthIndex22,(150*1.2)*screenHeightIndex22);
    [self.view addSubview:self.button4];
    
    self.balloon5 =[[UIImageView alloc] initWithFrame:CGRectMake((50-20)*screenWidthIndex11,(200-160+80)*screenHeightIndex,(110*1.2)*screenWidthIndex22,(150*1.2)*screenHeightIndex22)];
    self.balloon5.image=[UIImage imageNamed:@"balloon_orange.png"];
//    [self.balloon5 setUserInteractionEnabled:YES];
//    UITapGestureRecognizer *singleTap3 =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ballon4Tap:)];
//    [singleTap2 setNumberOfTapsRequired:1];
//    [self.balloon5 addGestureRecognizer:singleTap3];
    [self.view addSubview:self.balloon5];
   
    self.button5 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button5 addTarget:self action:@selector(actionButton4) forControlEvents:UIControlEventTouchUpInside];
    [self.button5 setTitle:@"" forState:UIControlStateNormal];
    self.button5.frame = CGRectMake((50-20)*screenWidthIndex11,(200-160+80)*screenHeightIndex,(110*1.2)*screenWidthIndex22,(150*1.2)*screenHeightIndex22);
    [self.view addSubview:self.button5];
    
    self.cameraBalloon = [[UIImageView alloc] initWithFrame:CGRectMake(264*screenWidthIndex11,(210-110+60)*screenHeightIndex*1.03,40*screenWidthIndex22,40*screenHeightIndex22)];
    self.cameraBalloon.image = [UIImage imageNamed:@"cameraWhite.png"];
    
    [self.view addSubview:self.cameraBalloon];
    
    
    self.myLabel = [[UILabel alloc] initWithFrame:CGRectMake(59*screenWidthIndex11, 182*screenHeightIndex, 150*screenWidthIndex22, 50*screenHeightIndex22)];
    self.myLabel.text = @"Connect";
    [self.myLabel setFont:[UIFont fontWithName:@"Avenir" size:20.0]];
    [self.view addSubview:self.myLabel];
    self.myLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(245*screenWidthIndex11*screenWidthSharePic, 122*screenHeightIndex, 150*screenWidthIndex22, 50*screenHeightIndex22)];
    self.myLabel1.text = @"Share Pic";
    [self.myLabel1 setFont:[UIFont fontWithName:@"Avenir-Medium" size:20]];
    [self.view addSubview:self.myLabel1];
    self.myLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(172*screenWidthIndex11, 302*screenHeightIndex, 150*screenWidthIndex22, 50*screenHeightIndex22)];
    self.myLabel2.text = [NSString stringWithFormat:@"%@", pass];
    [self.myLabel2 setFont:[UIFont fontWithName:@"Avenir" size:20.0]];
    [self.view addSubview:self.myLabel2];
    self.myLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(58*screenWidthIndex11, 422*screenHeightIndex, 150*screenWidthIndex22, 50*screenHeightIndex22)];
    self.myLabel3.text = [NSString stringWithFormat:@"Stats"];
    [self.myLabel3 setFont:[UIFont fontWithName:@"Avenir" size:20.0]];
    [self.view addSubview:self.myLabel3];
    self.myLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(259*screenWidthIndex11, 436*screenHeightIndex, 150*screenWidthIndex22, 50*screenHeightIndex22)];
    self.myLabel4.text = [NSString stringWithFormat:@"Exchange"];
    [self.myLabel4 setFont:[UIFont fontWithName:@"Avenir" size:18.0]];
    [self.view addSubview:self.myLabel4];
    
    self.myLabel.textColor = [UIColor whiteColor];
    self.myLabel.font = [UIFont boldSystemFontOfSize:18.0f*screenHeightIndex];
    self.myLabel1.textColor = [UIColor whiteColor];
    self.myLabel1.font = [UIFont boldSystemFontOfSize:18.0f*screenHeightIndex];
    self.myLabel2.textColor = [UIColor whiteColor];
    self.myLabel2.font = [UIFont boldSystemFontOfSize:18.0f*screenHeightIndex];
    self.myLabel3.textColor = [UIColor whiteColor];
    self.myLabel3.font = [UIFont boldSystemFontOfSize:18.0f*screenHeightIndex];
    self.myLabel4.textColor = [UIColor whiteColor];
    self.myLabel4.font = [UIFont boldSystemFontOfSize:18.0f*screenHeightIndex];

}
-(void)actionButton1 {
    [self.tabBarController setSelectedIndex:2];
}
-(void)actionButton2 {
    [self.tabBarController setSelectedIndex:3];
}
-(void)actionButton3 {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PointsConversionViewController *sfvc = [storyboard instantiateViewControllerWithIdentifier:@"conversion"];
    [sfvc setModalPresentationStyle:UIModalPresentationFullScreen];
    [self presentViewController:sfvc animated:YES completion:nil];
}
-(void)actionButton4 {
    [self.tabBarController setSelectedIndex:1];
}
-(void)actionButton5 {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CameraShareViewController *sfvc = [storyboard instantiateViewControllerWithIdentifier:@"share"];
    [sfvc setModalPresentationStyle:UIModalPresentationFullScreen];
    [self presentViewController:sfvc animated:YES completion:nil];
}

//-(void)ballon1Tap:(UIGestureRecognizer *)recognizer
//{
//    [self.tabBarController setSelectedIndex:2];
//}
//-(void)ballon2Tap:(UIGestureRecognizer *)recognizer
//{
//    [self.tabBarController setSelectedIndex:3];
//}
//-(void)ballon3Tap:(UIGestureRecognizer *)recognizer
//{
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    PointsConversionViewController *sfvc = [storyboard instantiateViewControllerWithIdentifier:@"conversion"];
//    [sfvc setModalPresentationStyle:UIModalPresentationFullScreen];
//    [self presentViewController:sfvc animated:YES completion:nil];
//}
//
//-(void)ballon4Tap:(UIGestureRecognizer *)recognizer
//{
//    [self.tabBarController setSelectedIndex:1];
//}
//-(void)ballon5Tap:(UIGestureRecognizer *)recognizer
//{
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    CameraShareViewController *sfvc = [storyboard instantiateViewControllerWithIdentifier:@"share"];
//    [sfvc setModalPresentationStyle:UIModalPresentationFullScreen];
//    [self presentViewController:sfvc animated:YES completion:nil];
//}

-(void)myTimerTick:(NSTimer *)timer {
    [self moveBalloon1];
    [self moveBalloon2];
    [self moveBalloon3];
    [self moveBalloon4];
    [self moveBalloon5];
    
//    [self loaddata];
}
-(void) moveBalloon1 {
    [UIView animateWithDuration:2.5f
                     animations:^{
                         
                         self.balloon1.center = CGPointMake(self.balloon1.center.x - 5, self.balloon1.center.y + 40.0f);
                         
                     } completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:2.5f
                                          animations:^{
                                              
                                              self.balloon1.center = CGPointMake(self.balloon1.center.x + 5, self.balloon1.center.y - 40.0f);
                                              
                                          } completion:^(BOOL finished) {
                                              
                                          }];
                     }];
    [UIView animateWithDuration:2.5f
                     animations:^{
                         
                         self.myLabel2.center = CGPointMake(self.myLabel2.center.x - 5, self.myLabel2.center.y + 40.0f);
                         
                     } completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:2.5f
                                          animations:^{
                                              
                                              self.myLabel2.center = CGPointMake(self.myLabel2.center.x + 5, self.myLabel2.center.y - 40.0f);
                                              
                                          } completion:^(BOOL finished) {
                                              
                                          }];
                     }];
}

-(void) moveBalloon2 {
    [UIView animateWithDuration:2.5f
                     animations:^{
                         
                         self.balloon2.center = CGPointMake(self.balloon2.center.x + 3, self.balloon2.center.y + 40.0f);
                         
                     } completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:2.5f
                                          animations:^{
                                              
                                              self.balloon2.center = CGPointMake(self.balloon2.center.x - 3, self.balloon2.center.y - 40.0f);
                                              
                                          } completion:^(BOOL finished) {
                                              
                                          }];
                     }];
    [UIView animateWithDuration:2.5f
                     animations:^{
                         
                         self.myLabel3.center = CGPointMake(self.myLabel3.center.x + 3, self.myLabel3.center.y + 40.0f);
                         
                     } completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:2.5f
                                          animations:^{
                                              
                                              self.myLabel3.center = CGPointMake(self.myLabel3.center.x - 3, self.myLabel3.center.y - 40.0f);
                                              
                                          } completion:^(BOOL finished) {
                                              
                                          }];
                     }];
    
    
}
-(void) moveBalloon3 {
    [UIView animateWithDuration:2.4f
                     animations:^{
                         
                         self.balloon3.center = CGPointMake(self.balloon3.center.x - 2, self.balloon3.center.y + 40.0f);
                         
                     } completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:2.4f
                                          animations:^{
                                              
                                              self.balloon3.center = CGPointMake(self.balloon3.center.x + 2, self.balloon3.center.y - 40.0f);
                                              
                                          } completion:^(BOOL finished) {
                                              
                                          }];
                     }];
    [UIView animateWithDuration:2.5f
                     animations:^{
                         
                         self.myLabel4.center = CGPointMake(self.myLabel4.center.x - 2, self.myLabel4.center.y + 40.0f);
                         
                     } completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:2.4f
                                          animations:^{
                                              
                                              self.myLabel4.center = CGPointMake(self.myLabel4.center.x + 2, self.myLabel4.center.y - 40.0f);
                                              
                                          } completion:^(BOOL finished) {
                                              
                                          }];                     }];
}
-(void) moveBalloon4 {
    [UIView animateWithDuration:2.5f
                     animations:^{
                         
                         self.balloon4.center = CGPointMake(self.balloon4.center.x - 3, self.balloon4.center.y + 40.0f);
                         
                     } completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:2.5f
                                          animations:^{
                                              
                                              self.balloon4.center = CGPointMake(self.balloon4.center.x + 3, self.balloon4.center.y - 40.0f);
                                              
                                          } completion:^(BOOL finished) {
                                              
                                          }];
                     }];
    [UIView animateWithDuration:2.5f
                     animations:^{
                         
                         self.cameraBalloon.center = CGPointMake(self.cameraBalloon.center.x - 3, self.cameraBalloon.center.y + 40.0f);
                         
                     } completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:2.5f
                                          animations:^{
                                              
                                              self.cameraBalloon.center = CGPointMake(self.cameraBalloon.center.x + 3, self.cameraBalloon.center.y - 40.0f);
                                              
                                          } completion:^(BOOL finished) {
                                              
                                          }];
                     }];
    [UIView animateWithDuration:2.5f
                     animations:^{
                         
                         self.myLabel1.center = CGPointMake(self.myLabel1.center.x - 3, self.myLabel1.center.y + 40.0f);
                         
                     } completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:2.5f
                                          animations:^{
                                              
                                              self.myLabel1.center = CGPointMake(self.myLabel1.center.x + 3, self.myLabel1.center.y - 40.0f);
                                              
                                          } completion:^(BOOL finished) {
                                              
                                          }];
                     }];
}

-(void) moveBalloon5 {
    [UIView animateWithDuration:2.4f
                     animations:^{
                         
                         self.balloon5.center = CGPointMake(self.balloon5.center.x + 3, self.balloon5.center.y + 40.0f);
                         
                     } completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:2.4f
                                          animations:^{
                                              
                                              self.balloon5.center = CGPointMake(self.balloon5.center.x - 3, self.balloon5.center.y - 40.0f);
                                              
                                          } completion:^(BOOL finished) {
                                              
                                          }];
                     }];
    [UIView animateWithDuration:2.4f
                     animations:^{
                         
                         self.myLabel.center = CGPointMake(self.myLabel.center.x + 3, self.myLabel.center.y + 40.0f);
                         
                     } completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:2.4f
                                          animations:^{
                                              
                                              self.myLabel.center = CGPointMake(self.myLabel.center.x - 3, self.myLabel.center.y - 40.0f);
                                              
                                          } completion:^(BOOL finished) {
                                              
                                          }];
                     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
