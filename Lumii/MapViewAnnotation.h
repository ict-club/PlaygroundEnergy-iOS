//
//  MapViewAnnotation.h
//  Lumi
//
//  Created by PETAR LAZAROV on 8/20/15.
//  Copyright (c) 2015 PETAR LAZAROV. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MapKit/MapKit.h>

@interface MapViewAnnotation : NSObject <MKAnnotation>

@property (nonatomic,copy) NSString *title;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

-(id) initWithTitle:(NSString *) title AndCoordinate:(CLLocationCoordinate2D)coordinate;

@end