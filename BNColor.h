//
//  BNColor.h
//
//  Created by Tyler Neylon on 11/25/09.
//  Copyright 2009 Bynomial.
//
//  BNColor is a Bynomial Color class, meant to make
//  it easier to deal interchangably with both
//  RGB and HSV color models.
//

#import <Foundation/Foundation.h>


@interface BNColor : NSObject <NSCopying, NSCoding> {
  float red;
  float green;
  float blue;
}

// All of these values are in the range [0,1].

@property (nonatomic) float red;
@property (nonatomic) float green;
@property (nonatomic) float blue;

@property (nonatomic) float hue;
@property (nonatomic) float saturation;
@property (nonatomic) float value;

@property (nonatomic, readonly) float lightness;

@property (nonatomic, readonly) UIColor *UIColor;

+ (BNColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;
+ (BNColor *)colorFromRGBHexString:(NSString *)rgbString;

- (void)setWithHue:(float)h saturation:(float)s value:(float)v;

- (void)setFill;
- (void)setStroke;
- (UIColor *)colorFromBNColor __attribute__((deprecated));  // Use the UIColor method instead; more traditional name.
- (UIColor *)UIColor;

- (NSString *)hexCode;
- (NSString *)decString;
- (NSString *)percentString;

// Named colors, for convenience.
+ (BNColor *)redColor;
+ (BNColor *)orangeColor;
+ (BNColor *)yellowColor;
+ (BNColor *)greenColor;
+ (BNColor *)blueColor;
+ (BNColor *)purpleColor;

+ (BNColor *)magentaColor;
+ (BNColor *)cyanColor;
+ (BNColor *)brownColor;

+ (BNColor *)blackColor;
+ (BNColor *)darkGrayColor;
+ (BNColor *)lightGrayColor;
+ (BNColor *)whiteColor;

// Picks hue randomly, sat = 1.0, value = 1.0
+ (BNColor *)randomBrightColor;

@end
