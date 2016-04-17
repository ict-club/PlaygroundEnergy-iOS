//
//  ConnectViewController.m
//  lumi
//
//  Created by PETAR LAZAROV on 8/16/15.
//  Copyright © 2015 PETAR LAZAROV. All rights reserved.
//

#import "ConnectViewController.h"
#import "userDataSaving.h"
#import "coreDataController.h"
#import "dataBaseInteractions.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"


@interface ConnectViewController ()
@property (weak, nonatomic) IBOutlet UILabel *testLabel;

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic) BOOL isReading;

@property(nonatomic, strong) NSString *currentTime;
@property(nonatomic, strong) NSString *startTime;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatior;

-(BOOL)startReading;
-(void)stopReading;
-(void)loadBeepSound;

@property (nonatomic, strong) NSString *charUUID;


@property UIImageView* balloon;
@property UIImageView* lumi;


@property (strong, nonatomic) CBCentralManager *centralManager;
@property (strong, nonatomic) CBPeripheral *discoveredPeripheral;
@property BOOL bluetoothOn;
@property UIImageView* dot1;
@property UILabel* myLabel;
@property (weak, nonatomic) IBOutlet UILabel *labelWithData;
@property (weak, nonatomic) IBOutlet UISegmentedControl *verbositySelector;
@end
CBPeripheral * desiredPeripheral;
CBCharacteristic * characteristic;
@implementation ConnectViewController
NSInteger sum;
NSInteger AllSum;
NSInteger print;
NSInteger aaa = 2;
NSInteger newnum;
NSInteger score;
NSDateFormatter* formatter;
NSString* username;
NSString* password;
NSInteger baseWidth1 = 375;
NSInteger baseHeight1 = 667;
float screenWidthIndex1;
float screenHeightIndex1;
BOOL isLoading = NO;
NSInteger isLoadingIndex = 0;

@synthesize loadingToConnectActivityMonitor;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    characteristic = [CBCharacteristic alloc];
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    self.currentTime = [formatter stringFromDate:[NSDate date]];
    self.startTime = self.currentTime;
    self.charUUID = self.lblStatus.text;
    
    //[self startStopReading:nil];
    self.lblStatus.hidden = YES;
    // Initially make the captureSession object nil.
    _captureSession = nil;
    
    // Set the initial value of the flag to NO.
    _isReading = NO;
    
    // Begin loading the sound effect so to have it ready for playback when it's needed.
    [self loadBeepSound];
    
    self.lumi =[[UIImageView alloc] initWithFrame:CGRectMake(0,15,35,35)];
    self.lumi.image=[UIImage imageNamed:@"lumi.png"];
    [self.view addSubview:self.lumi];
    
    
    
    [self tLog:@"Bluetooth LE Device Scanner\r\n\r\nProgramming the Internet of Things for iOS"];
    self.bluetoothOn = NO;
    
    userDataSaving *data = [[userDataSaving alloc]init];
    username = [data currentUser];
    password = [data currentPassword];
    [self sizeSettings];
    
    
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:@{CBCentralManagerOptionRestoreIdentifierKey :@"GeneratorCentral"}];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(myTimerTick:) userInfo:nil repeats:YES];
    [NSThread detachNewThreadSelector:@selector(myTimerTick:) toTarget:self withObject:nil];
    self.startTime = self.currentTime;
    [self checkForNetworkReachability];
    [self loadBaloon];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void) loadBaloon {
    self.balloon =[[UIImageView alloc] initWithFrame:CGRectMake(63*screenWidthIndex1,160*screenHeightIndex1,240*screenWidthIndex1,355*screenHeightIndex1)];
    self.balloon.image=[UIImage imageNamed:@"balloon_blue.png"];
    [self.view addSubview:self.balloon];
    self.balloon.hidden = YES;
    [self myTimerTick:0];
    
    self.verbositySelector.selectedSegmentIndex = 1;
    
    self.myLabel = [[UILabel alloc] initWithFrame:CGRectMake(149*screenWidthIndex1, 292*screenHeightIndex1, 350*screenWidthIndex1, 50*screenHeightIndex1)];
    self.myLabel.textColor = [UIColor whiteColor];
    self.myLabel.hidden = YES;
}
-(void)viewWillAppear:(BOOL)animated {
    [self checkForNetworkReachability];
}
- (void) sizeSettings
{
    screenWidthIndex1 = self.view.frame.size.width / baseWidth1;
    screenHeightIndex1 = self.view.frame.size.height / baseHeight1;
}
#pragma mark Network Reachability
-(void)checkForNetworkReachability {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There is no internet connection");
        [self showErrorMessage];
    } else {
        NSLog(@"There is internet connection");
    }
}
-(void)showErrorMessage{
    //    [self.pending dismissViewControllerAnimated:YES completion:nil];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"No network connection" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self.tabBarController setSelectedIndex:0];
    }];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)exitButton:(id)sender {
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:@{CBCentralManagerOptionRestoreIdentifierKey :@"GeneratorCentral"}];
    
    [self.centralManager cancelPeripheralConnection:self.connectedPeripheral];
    self.connectedPeripheral = nil;
    
    self.viewPreview.hidden = YES;
    self.lumi.hidden = YES;
    self.balloon.hidden = YES;
    self.myLabel.hidden = YES;
    //[self startStopReading:nil];
    
    // Initially make the captureSession object nil.
    _captureSession = nil;
    
    // Set the initial value of the flag to NO.
    _isReading = NO;
    [self loadBeepSound];
    [self getR];
}

- (void) loadingToConnect
{
    isLoading = YES;
    loadingToConnectActivityMonitor.hidden = NO;
    
    if (isLoadingIndex < 5) {
        [loadingToConnectActivityMonitor startAnimating];
    }else {
        [loadingToConnectActivityMonitor stopAnimating];
        loadingToConnectActivityMonitor.hidden = YES;
        self.balloon.hidden = NO;
        self.myLabel.hidden = NO;
    }
}

- (IBAction)connectDevice:(id)sender {
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:@{CBCentralManagerOptionRestoreIdentifierKey :@"GeneratorCentral"}];
    
    
    self.viewPreview.hidden = YES;
    self.lumi.hidden = YES;
    self.balloon.hidden = YES;
    self.myLabel.hidden = YES;
    [self startStopReading:nil];
    
    // Initially make the captureSession object nil.
    _captureSession = nil;
    
    // Set the initial value of the flag to NO.
    _isReading = NO;
    [self loadBeepSound];
    [self getR];

    
}

-(void) getR {
    //    NSString* userName = self.userNameTextField.text;
    //    NSString* password = self.passwordTextField.text;
    
    NSString* req = [NSString stringWithFormat:@"{\"username\":\"%@\",\"appliance\":\"1\", \"time_from\": \"%@\",\"time_to\": \"%@\", \"velocity\":\"5\", \"reward_points\":\"%@\"}",username, self.startTime, self.currentTime, self.myLabel.text];
    NSString* req1 = [NSString stringWithFormat:@"{\"username\":\"%@\",\"password\":\"%@\"}",username, password];
    //    NSString* hide = [NSString stringWithFormat:@"User %@ created", userName];
    //    self.labelUser1.text = userName;
    //    self.userName = userName;
    NSLog(@"%@",req);
    
    NSString *post = [NSString stringWithFormat:@""];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSMutableURLRequest *request;
    request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://www.rapiddevcrew.com/Lumi/postTransaction"]];
    
    
    
    [request setHTTPMethod:@"POST"];
    [request setValue:req1 forHTTPHeaderField:@"Credentials"];
    [request setValue:req forHTTPHeaderField:@"Data"];
    [request setHTTPBody:postData];
    
    
    //    NSURLResponse *requestResponse;
    
    NSURLResponse *requestResponse;
    NSData *requestHandler = [NSURLConnection sendSynchronousRequest:request returningResponse:&requestResponse error:nil];
    
    NSString *requestReply = [[NSString alloc] initWithBytes:[requestHandler bytes] length:[requestHandler length] encoding:NSASCIIStringEncoding];
    NSLog(@"requestReply: %@", requestReply);
    
    coreDataController * coreData = [[coreDataController alloc] init];
    [coreData addData:[NSString stringWithFormat:@"%ld",AllSum] atDate:[NSDate date] forUser:username];
    
    AllSum = 0;
    self.startTime = self.currentTime;
    
    
}



-(void)myTimerTick:(NSTimer *)timer {
    
    //#define SERVICE_UUID        @ ""
    //#define CHARACTERISTIC_UUID @ ""
    
    if (isLoading == YES) {
        if (isLoadingIndex > 5) {
            isLoadingIndex = 10;
        } else {
            isLoadingIndex++;
        }
        [self loadingToConnect];
    }
    
    
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    self.currentTime = [formatter stringFromDate:[NSDate date]];
    
    AllSum += sum;
    NSLog(@"%@",self.charUUID);
    
    
    self.testLabel.text = [NSString stringWithFormat:@"%ld", AllSum];
    
    if ([self.lblStatus.text isEqualToString:@"Scanning for QR Code..."]) {
        NSLog(@"wait for it");
    }else{
        if ([self.lblStatus.text isEqualToString:@"haha"]) {
            NSLog(@"do nothing");
        } else {
            NSLog(@"action");
            self.charUUID = self.lblStatus.text;
            self.viewPreview.hidden = YES;
            self.lumi.hidden = NO;
            
            [self startbutt];
            self.lblStatus.text = [NSString stringWithFormat:@"haha"];
            
            [self loadingToConnect];
            
            
        }
    }
    
    [UIView animateWithDuration:0.5f
                     animations:^{
                         
                         self.balloon.center = CGPointMake(self.balloon.center.x , self.balloon.center.y + aaa);
                         
                     } completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:0.5f
                                          animations:^{
                                              
                                              self.balloon.center = CGPointMake(self.balloon.center.x , self.balloon.center.y - aaa);
                                              
                                          } completion:^(BOOL finished) {
                                              
                                          }];
                     }];
    
    
    self.labelWithData.text = currentMessage;
    
    
    [self.myLabel setFont:[UIFont fontWithName:@"Avenir" size:40.0]];
    [self.view addSubview:self.myLabel];
    
    
    
    currentMessage = [NSString stringWithFormat:@""];
    
    
    [UILabel animateWithDuration:0.5f
                      animations:^{
                          
                          self.myLabel.center = CGPointMake(self.myLabel.center.x , self.myLabel.center.y + aaa);
                          
                      } completion:^(BOOL finished) {
                          
                          [UIView animateWithDuration:0.5f
                                           animations:^{
                                               
                                               self.myLabel.center = CGPointMake(self.myLabel.center.x, self.myLabel.center.y - aaa);
                                               
                                           } completion:^(BOOL finished) {
                                               
                                           }];
                      }];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





NSString * currentMessage;


NSMutableArray* dataArray;
-(bool)verboseMode
{
    return (self.verbositySelector.selectedSegmentIndex != 0);
}

-(void)tLog:(NSString *)msg
{
    //    self.outputTextView.text = [@"\r\n\r\n" stringByAppendingString:self.outputTextView.text];
    //    self.outputTextView.text = [msg stringByAppendingString:self.outputTextView.text];
    
}


-(void) startbutt {
    
    NSLog(@"pusni go!!");
    if (!self.bluetoothOn)
    {
        [self tLog:@"Bluetooth is OFF"];
        return;
    }
    
    [self.centralManager scanForPeripheralsWithServices:nil
                                                options:@{CBCentralManagerScanOptionAllowDuplicatesKey: @NO}];
}


- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary *)state
{
    //    NSArray *scanServices = state[CBCentralManagerRestoredStateScanServicesKey];
    //    NSArray *scanOptions = state[CBCentralManagerRestoredStateScanOptionsKey];
    
    NSArray*peripherals = state[CBCentralManagerRestoredStatePeripheralsKey];
    
    
}

-(void) centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI
{
    NSLog(@"Discovered %@", peripheral.identifier.UUIDString);
    NSLog(@"NAME %@", peripheral.name);
    if([peripheral.name isEqualToString:@"Lumi Connect"])    {
        [self.centralManager connectPeripheral:peripheral options:nil];
        desiredPeripheral = peripheral;
    }
}

- (void) centralManager:(CBCentralManager *)central
didFailToConnectPeripheral:(CBPeripheral *)peripheral
                  error:(NSError *)error
{
    [self tLog:@"Failed to connect"];
}

-(void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    peripheral.delegate = self;
    [peripheral discoverServices:nil];
    self.connectedPeripheral = peripheral;
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if(error)
    {
        [self tLog:[error description]];
        return;
    }
    
    for(CBService *service in peripheral.services)
    {
        [self tLog:[NSString stringWithFormat:@"Discovered service: %@", [service description]]];
        [peripheral discoverCharacteristics:nil forService:service];
    }
}


-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (error)
    {
        [self tLog:[error description]];
        return;
    }
    
    for(CBCharacteristic *characteristic in service.characteristics)
    {
        [self tLog:[NSString stringWithFormat:@"Characteristic found: %@", [characteristic description]]];
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:CHARACTERISTIC_UUID]])
        {
            [peripheral setNotifyValue:YES
                     forCharacteristic:characteristic];
        }
    }
    
}

- (void) peripheral:(CBPeripheral *)peripheral
didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic
              error:(NSError *)error
{
    if (error)
    {
        [self tLog:[error description]];
        return;
    }
    NSString *stringFromData = [[NSString alloc] initWithData:characteristic.value
                                                     encoding:NSUTF8StringEncoding];
    NSInteger num = [stringFromData integerValue];
    
    
    
    currentMessage = [NSString stringWithFormat:@"%@%ld",currentMessage, num];
    NSLog(@"%@", stringFromData);
    
    
    unichar ch = [stringFromData characterAtIndex:0]; // assume the 1st character
    int code = (int)ch;
    sum = code;
    self.myLabel.text = [NSString stringWithFormat:@"%ld", (AllSum/10)];
    
}



-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state != CBCentralManagerStatePoweredOn)
    {
        [self tLog:@"Bluetooth OFF"];
        self.bluetoothOn = NO;
    }
    else
    {
        [self tLog:@"Bluetooth ON"];
        self.bluetoothOn = YES;
    }
    
}
#pragma mark - IBAction method implementation

- (IBAction)startStopReading:(id)sender {
    
    [self.centralManager scanForPeripheralsWithServices:nil options:nil];
    [_lblStatus setText:@"action"];
    return;
    if (!_isReading) {
        // This is the case where the app should read a QR code when the start button is tapped.
        if ([self startReading]) {
            // If the startReading methods returns YES and the capture session is successfully
            // running, then change the start button title and the status message.
            //[_bbitemStart setTitle:@"Stop"];
            [_lblStatus setText:@"Scanning for QR Code..."];
        }
    }
    else{
        // In this case the app is currently reading a QR code and it should stop doing so.
        [self stopReading];
        // The bar button item's title should change again.
        [_bbitemStart setTitle:@"Start!"];
    }
    
    // Set to the flag the exact opposite value of the one that currently has.
    _isReading = !_isReading;
}


#pragma mark - Private method implementation

- (BOOL)startReading {
    NSError *error;
    [self.centralManager scanForPeripheralsWithServices:nil options:nil];
    [_lblStatus setText:@"action"];
    
    return YES;
    // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
    // as the media type parameter.
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Get an instance of the AVCaptureDeviceInput class using the previous device object.
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input) {
        // If any error occurs, simply log the description of it and don't continue any more.
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    // Initialize the captureSession object.
    _captureSession = [[AVCaptureSession alloc] init];
    // Set the input device on the capture session.
    [_captureSession addInput:input];
    
    
    // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    // Create a new serial dispatch queue.
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
    [_viewPreview.layer addSublayer:_videoPreviewLayer];
    
    
    // Start video capture.
    [_captureSession startRunning];
    
    return YES;
}


-(void)stopReading{
    // Stop video capture and make the capture session object nil.
    [_captureSession stopRunning];
    _captureSession = nil;
    
    // Remove the video preview layer from the viewPreview view's layer.
    [_videoPreviewLayer removeFromSuperlayer];
}


-(void)loadBeepSound{
    // Get the path to the beep.mp3 file and convert it to a NSURL object.
    NSString *beepFilePath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"mp3"];
    NSURL *beepURL = [NSURL URLWithString:beepFilePath];
    
    NSError *error;
    
    // Initialize the audio player object using the NSURL object previously set.
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:beepURL error:&error];
    if (error) {
        // If the audio player cannot be initialized then log a message.
        NSLog(@"Could not play beep file.");
        NSLog(@"%@", [error localizedDescription]);
    }
    else{
        // If the audio player was successfully initialized then load it in memory.
        [_audioPlayer prepareToPlay];
    }
}


#pragma mark - AVCaptureMetadataOutputObjectsDelegate method implementation

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    // Check if the metadataObjects array is not nil and it contains at least one object.
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        // Get the metadata object.
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            // If the found metadata is equal to the QR code metadata then update the status label's text,
            // stop reading and change the bar button item's title and the flag's value.
            // Everything is done on the main thread.
            [_lblStatus performSelectorOnMainThread:@selector(setText:) withObject:[metadataObj stringValue] waitUntilDone:NO];
            
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
            [_bbitemStart performSelectorOnMainThread:@selector(setTitle:) withObject:@"Start!" waitUntilDone:NO];
            
            _isReading = NO;
            
            // If the audio player is not nil, then play the sound effect.
            if (_audioPlayer) {
                [_audioPlayer play];
            }
        }
    }
    
    
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)registerPoints:(UIButton *)sender {
    userDataSaving *data = [[userDataSaving alloc]init];
    coreDataController * coreData = [[coreDataController alloc] init];
    dataBaseInteractions * database = [[dataBaseInteractions alloc]init];
    NSDateFormatter* formatter;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    [database postTransaction:100 forUser:[data currentUser] withPass:[data currentPassword] fromTime:[formatter stringFromDate:[NSDate date]] toTime:[formatter stringFromDate:[NSDate date]] atApplience:@"3" withVelocity:@"5"];
    [coreData addData:@"100" atDate:[NSDate date] forUser:[data currentUser]];
    [coreData getData];
}

- (IBAction)generatePoints:(id)sender {
    userDataSaving *data = [[userDataSaving alloc]init];
    coreDataController * coreData = [[coreDataController alloc] init];
    dataBaseInteractions * database = [[dataBaseInteractions alloc]init];
    NSDateFormatter* formatter;
    int points = arc4random_uniform(1000);
    int appliance = arc4random_uniform(5);
    int speed = arc4random_uniform(5);
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    [database postTransaction:points forUser:[data currentUser] withPass:[data currentPassword] fromTime:[formatter stringFromDate:[NSDate date]] toTime:[formatter stringFromDate:[NSDate date]] atApplience:[NSString stringWithFormat:@"%d", appliance] withVelocity:[NSString stringWithFormat:@"%d", speed]];
    [coreData addData:[NSString stringWithFormat:@"%d", points] atDate:[NSDate date] forUser:[data currentUser]];
    [coreData getData];
    
}
@end
