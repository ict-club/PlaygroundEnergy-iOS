//
//  ConnectViewController.h
//  lumi
//
//  Created by PETAR LAZAROV on 8/16/15.
//  Copyright © 2015 PETAR LAZAROV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dataBaseInteractions.h"
#import "userDataSaving.h"
#import "coreDataController.h"
#import "AccountViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <AVFoundation/AVFoundation.h>
@interface ConnectViewController : UIViewController
<
CBCentralManagerDelegate,
CBPeripheralDelegate,
AVCaptureMetadataOutputObjectsDelegate
>
- (IBAction)registerPoints:(UIButton *)sender;
- (IBAction)generatePoints:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *viewPreview;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *bbitemStart;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingToConnectActivityMonitor;

- (IBAction)startStopReading:(id)sender;

//#define SERVICE_UUID        @ "FFF0"
#define CHARACTERISTIC_UUID @ "2A19"
//#define SERVICE_UUID        @ "CE7E9D6C-6460-BD69-AECA-8CB88C9BBCAF"
//#define CHARACTERISTIC_UUID @ "A1E8F5B1-696B-4E4C-87C6-69DFE0B0093B"

@end


