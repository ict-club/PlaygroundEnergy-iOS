//
//  UIDataDetectors.h
//  UIKit
//
//  Copyright (c) 2009-2014 Apple Inc. All rights reserved.
//

typedef NS_OPTIONS(NSUInteger, UIDataDetectorTypes) {
    UIDataDetectorTypePhoneNumber                              = 1 << 0,          // Phone number detection
    UIDataDetectorTypeLink                                     = 1 << 1,          // URL detection
    UIDataDetectorTypeAddress NS_ENUM_AVAILABLE_IOS(4_0)       = 1 << 2,          // Street address detection
    UIDataDetectorTypeCalendarEvent NS_ENUM_AVAILABLE_IOS(4_0) = 1 << 3,          // Event detection

    UIDataDetectorTypeNone          = 0,               // No detection at all
    UIDataDetectorTypeAll           = NSUIntegerMax    // All types
};
