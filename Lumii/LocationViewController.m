//
//  LocationViewController.m
//  lumi
//
//  Created by PETAR LAZAROV on 8/16/15.
//  Copyright © 2015 PETAR LAZAROV. All rights reserved.
//

#import "LocationViewController.h"
#import "MapViewAnnotation.h"
#import "JFMapAnnotation.h"

@interface LocationViewController ()
@property UIImageView* lumi;

@end
NSString * address;

@implementation LocationViewController
#define METERS_PER_MILE 1609.344
NSString* addrr;
@synthesize mapView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar.delegate = self;
    self.mapView.delegate = self;
    [self.mapView setShowsUserLocation:YES];
    
    [self.mapView addAnnotations:[self createAnnotaions]];
    [self loadPins];
    
    [self.mapView setShowsUserLocation:YES];
    
}




- (void) loadPins
{
    __block NSArray *annoations;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        annoations = [self parseJSONCities];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            
            [self.mapView addAnnotations:annoations];
            
        });
    });
    
    
}
- (void)addPinToMap:(UIGestureRecognizer *)gestureRecognizer
{
    
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    JFMapAnnotation *toAdd = [[JFMapAnnotation alloc]init];
    
    toAdd.coordinate = touchMapCoordinate;
    toAdd.subtitle = @"Subtitle";
    toAdd.title = @"Title";
    
    [self.mapView addAnnotation:toAdd];
    
}

- (NSMutableArray *)parseJSONCities{
    
    NSMutableArray *retval = [[NSMutableArray alloc]init];
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"capitals"
                                                         ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    NSError *error = nil;
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data
                                                    options:kNilOptions
                                                      error:&error];
    
    for (JFMapAnnotation *record in json) {
        
        NSLog(@"hahahh");

        
        
        JFMapAnnotation *temp = [[JFMapAnnotation alloc]init];
        [temp setTitle:[record valueForKey:@"Capital"]];
        [temp setSubtitle:[record valueForKey:@"address"]];
        [temp setCoordinate:CLLocationCoordinate2DMake([[record valueForKey:@"Latitude"]floatValue], [[record valueForKey:@"Longitude"]floatValue])];
        
        [retval addObject:temp];
        
        address = temp.title;
        addrr = temp.subtitle;
    }
    
    return retval;
}



-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:self.searchBar.text completionHandler:^(NSArray *placemarks, NSError *error) {
        
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        
        MKCoordinateRegion region;
        CLLocationCoordinate2D newLocation = [placemark.location coordinate];
        region.center = [(CLCircularRegion *)placemark.region center];
        
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        [annotation setCoordinate:newLocation];
        [annotation setTitle:self.searchBar.text];
        [self.mapView addAnnotation:annotation];
        
        MKMapRect mr = [self.mapView visibleMapRect];
        MKMapPoint pt = MKMapPointForCoordinate([annotation coordinate]);
        mr.origin.x = pt.x - mr.size.width * 0.5;
        mr.origin.y = pt.y - mr.size.height * 0.25;
        [self.mapView setVisibleMapRect:mr animated:YES];
        
        NSLog(@"Location found from Map: %f, %f",newLocation.latitude,newLocation.longitude);
        
    }];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    CLLocationCoordinate2D myLocation = [userLocation coordinate];
    
    MKCoordinateRegion zoomRegion = MKCoordinateRegionMakeWithDistance(myLocation, 2500, 2500);
    
    [self.mapView setRegion:zoomRegion animated:YES];
}

-(NSMutableArray*)createAnnotaions
{
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    
    //Read locations details from plist
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"locations" ofType:@"plist"];
    
    NSArray *locations = [NSArray arrayWithContentsOfFile:path];
    
    for (NSDictionary *row in locations) {
        
        NSNumber *latitude = [row objectForKey:@"latitude"];
        
        NSNumber *longitude = [row objectForKey:@"longitude"];
        
        NSString *title = [row objectForKey:@"title"];
        address = [NSString stringWithString:[row objectForKey:@"address"]];

        //Create coordinates from the latitude and longitude values
        
        CLLocationCoordinate2D coord;
        
        coord.latitude = latitude.doubleValue;
        
        coord.longitude = longitude.doubleValue;
        
        MapViewAnnotation *annotation = [[MapViewAnnotation alloc] initWithTitle:title AndCoordinate:coord];
        
        [annotations addObject:annotation];
        
    }
    
    return annotations;
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapview viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    static NSString* AnnotationIdentifier = @"AnnotationIdentifier";
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
    if(annotationView)
        return annotationView;
    else
    {
        MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                        reuseIdentifier:AnnotationIdentifier];
        annotationView.canShowCallout = YES;
        annotationView.image = [UIImage imageNamed:@"50.png"];
//        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//        [rightButton addTarget:self action:@selector(infobutton:) forControlEvents:UIControlEventTouchUpInside];
//        [rightButton setTitle:annotation.title forState:UIControlStateNormal];
//        annotationView.rightCalloutAccessoryView = rightButton;
        annotationView.canShowCallout = YES;
        annotationView.draggable = YES;
        return annotationView;
    }
    return nil;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.searchBar resignFirstResponder];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.searchBar) {
        [self.searchBar resignFirstResponder];
    }
    
    return NO;
}
-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y - 170.0), self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}
-(void) textFieldDidEndEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y + 170.0), self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
}

- (IBAction)infobutton:(id)sender
{
    NSLog(@"%@",address);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:address
                                                    message:addrr
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];

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
