//
//  UIPrintPageRenderer.h
//  UIKit
//
//  Copyright 2010-2012 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKitDefines.h>

NS_ASSUME_NONNULL_BEGIN

@class UIPrintFormatter;

NS_CLASS_AVAILABLE_IOS(4_2) @interface UIPrintPageRenderer : NSObject

@property(nonatomic) CGFloat   headerHeight;   // top of contentRect from printableRect
@property(nonatomic) CGFloat   footerHeight;   // bottom of contentRect from printableRect

@property(nonatomic,readonly) CGRect paperRect;      // complete paper rect. origin is (0,0)
@property(nonatomic,readonly) CGRect printableRect;  // imageable area inside paper rect

@property(nullable,nonatomic,copy) NSArray<UIPrintFormatter *> *printFormatters;
- (nullable NSArray<UIPrintFormatter *> *)printFormattersForPageAtIndex:(NSInteger)pageIndex;
- (void)addPrintFormatter:(UIPrintFormatter *)formatter startingAtPageAtIndex:(NSInteger)pageIndex;

- (NSInteger)numberOfPages;                        // override point. called to get page count. default returns maximum page count needed for all formatters or 0
- (void)prepareForDrawingPages:(NSRange)range;     // override point. default does nothing. called before requesting a set of pages to draw

- (void)drawPageAtIndex:(NSInteger)pageIndex inRect:(CGRect)printableRect;                         // override point. may be called from non-main thread.  calls the various draw methods below.
- (void)drawPrintFormatter:(UIPrintFormatter *)printFormatter forPageAtIndex:(NSInteger)pageIndex; // override point. calls each formatter to draw for that page. subclassers must call super.
- (void)drawHeaderForPageAtIndex:(NSInteger)pageIndex  inRect:(CGRect)headerRect;                  // override point. default does nothing
- (void)drawContentForPageAtIndex:(NSInteger)pageIndex inRect:(CGRect)contentRect;                 // override point. default does nothing
- (void)drawFooterForPageAtIndex:(NSInteger)pageIndex  inRect:(CGRect)footerRect;                  // override point. default does nothing

@end

NS_ASSUME_NONNULL_END
