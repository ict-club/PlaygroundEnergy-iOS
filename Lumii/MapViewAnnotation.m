//
//  MapViewAnnotation.m
//  Lumi
//
//  Created by PETAR LAZAROV on 8/20/15.
//  Copyright (c) 2015 PETAR LAZAROV. All rights reserved.
//

#import "MapViewAnnotation.h"

@implementation MapViewAnnotation

@synthesize coordinate=_coordinate;

@synthesize title=_title;

-(id) initWithTitle:(NSString *) title AndCoordinate:(CLLocationCoordinate2D)coordinate

{
    
    self = [super init];
    
    _title = title;
    
    _coordinate = coordinate;
    
    return self;
    
}

@end