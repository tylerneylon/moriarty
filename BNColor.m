//
//  BNColor.m
//
//  Created by Tyler Neylon on 11/25/09.
//  Copyright 2009 Bynomial.
//

#import "BNColor.h"

#import "NSObject+Be.h"

#define kRedKey @"r"
#define kGreenKey @"g"
#define kBlueKey @"b"

#define IMPL_NAMED_COLOR(name, r, g, b) \
+ (BNColor *)name { \
  return [BNColor colorWithRed:r green:g blue:b]; \
}

@interface BNColor ()

- (void)findMin:(float *)min max:(float *)max;

@end



@implementation BNColor

@synthesize red, green, blue;

+ (BNColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue {
  BNColor *color = [BNColor beInit];
  color.red = red;
  color.green = green;
  color.blue = blue;
  return color;
}

+ (BNColor *)colorFromRGBHexString:(NSString *)rgbString {  
  int component[3];
  for (int i = 0; i < 3; ++i) {
    sscanf([[rgbString substringWithRange:NSMakeRange(i * 2, 2)] UTF8String], "%X", component + i);
  }
  
  BNColor *color = [BNColor beInit];
  color.red = (component[0] / 255.0);
  color.green = (component[1] / 255.0);
  color.blue = (component[2] / 255.0);
  
  return color;
}

- (float)hue {
  float hue, min, max;
  [self findMin:&min max:&max];
  if (min == max) return 0;
  if (red >= green && red >= blue) {
    hue = 1.0 / 6.0 * (green - blue) / (max - min);
  } else if (green >= red && green >= blue) {
    hue = 1.0 / 6.0 * (blue - red) / (max - min) + 1.0 / 3.0;
  } else {
    hue = 1.0 / 6.0 * (red - green) / (max - min) + 2.0 / 3.0;
  }
  if (hue < 0.0) hue += 1.0;
  return hue;
}

- (void)setHue:(float)h {
  float s = self.saturation;
  float v = self.value;
  [self setWithHue:h saturation:s value:v];
}

- (float)saturation {
  float min, max;
  [self findMin:&min max:&max];
  return (max == 0 ? 0 : (max - min) / max);
}

- (void)setSaturation:(float)s {
  float h = self.hue;
  float v = self.value;
  [self setWithHue:h saturation:s value:v];
}

- (float)value {
  float min, max;
  [self findMin:&min max:&max];
  return max;
}

- (void)setValue:(float)v {
  float h = self.hue;
  float s = self.saturation;
  [self setWithHue:h saturation:s value:v];
}

- (float)lightness {
  float min, max;
  [self findMin:&min max:&max];
  return (min + max) / 2.0;
}

- (void)setWithHue:(float)h saturation:(float)s value:(float)v {
  int interval = h * 5.9999;  // Keep it in [0,6).
  float f = h * 5.9999 - interval;
  float p = v * (1 - s);
  float q = v * (1 - f * s);
  float t = v * (1 - (1 - f) * s);
  switch (interval) {
    case 0:
      red = v;
      green = t;
      blue = p;
      break;
    case 1:
      red = q;
      green = v;
      blue = p;
      break;
    case 2:
      red = p;
      green = v;
      blue = t;
      break;
    case 3:
      red = p;
      green = q;
      blue = v;
      break;
    case 4:
      red = t;
      green = p;
      blue = v;
      break;
    case 5:
      red = v;
      green = p;
      blue = q;
      break;
  }
}

- (void)setFill {
  CGContextSetRGBFillColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
}

- (void)setStroke {
  CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(),
                             red, green, blue, 1.0);
}

- (UIColor *)colorFromBNColor {
  return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

- (UIColor *)UIColor {
  return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

- (NSString *)hexCode {
  return [NSString stringWithFormat:@"#%02X%02X%02X",
          (int)round(self.red * 255), (int)round(self.green * 255), (int)round(self.blue * 255)];
}

- (NSString *)decString {
  return [NSString stringWithFormat:@"(%d, %d, %d)",
          (int)round(self.red * 255), (int)round(self.green * 255), (int)round(self.blue * 255)];
}

- (NSString *)percentString {
  return [NSString stringWithFormat:@"%0.2f, %0.2f, %0.2f",
          self.red, self.green, self.blue];
}

- (NSString *)description {
  return [NSString stringWithFormat:@"%@ <%p> RGB = (%.2f, %.2f, %.2f) HSV = (%.2f, %.2f, %.2f)",
          [self class], self, red, green, blue, self.hue, self.saturation, self.value];
}

#pragma mark named colors

IMPL_NAMED_COLOR(redColor, 1, 0, 0)
IMPL_NAMED_COLOR(orangeColor, 1, 0.5, 0)
IMPL_NAMED_COLOR(yellowColor, 1, 1, 0)
IMPL_NAMED_COLOR(greenColor, 0, 1, 0)
IMPL_NAMED_COLOR(blueColor, 0, 0, 1)
IMPL_NAMED_COLOR(purpleColor, 0.5, 0, 0.5)
IMPL_NAMED_COLOR(magentaColor, 1, 0, 1)
IMPL_NAMED_COLOR(cyanColor, 0, 1, 1)
IMPL_NAMED_COLOR(brownColor, 0.6, 0.4, 0.2)
IMPL_NAMED_COLOR(blackColor, 0, 0, 0)
IMPL_NAMED_COLOR(darkGrayColor, 1.0/3.0, 1.0/3.0, 1.0/3.0)
IMPL_NAMED_COLOR(lightGrayColor, 2.0/3.0, 2.0/3.0, 2.0/3.0)
IMPL_NAMED_COLOR(whiteColor, 1, 1, 1)

+ (BNColor *)randomBrightColor {
  BNColor *color = [BNColor beInit];
  float hue = (float)rand() / RAND_MAX;
  [color setWithHue:hue saturation:1 value:1];
  return color;
}

#pragma mark NSCopying methods

- (id)copyWithZone:(NSZone *)zone {
  BNColor *colorCopy = [[BNColor allocWithZone:zone] init];
  colorCopy.red = red;
  colorCopy.green = green;
  colorCopy.blue = blue;
  return colorCopy;
}

#pragma mark NSCoding methods

- (id)initWithCoder:(NSCoder *)decoder {
  if (![super init]) return nil;
  red = [decoder decodeFloatForKey:kRedKey];
  green = [decoder decodeFloatForKey:kGreenKey];
  blue = [decoder decodeFloatForKey:kBlueKey];
  return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
  [encoder encodeFloat:red forKey:kRedKey];
  [encoder encodeFloat:green forKey:kGreenKey];
  [encoder encodeFloat:blue forKey:kBlueKey];
}

#pragma mark internal methods

- (void)findMin:(float *)min max:(float *)max {
  *min = (red > green ? (blue > green ? green : blue) : (red > blue ? blue : red));
  *max = (red > green ? (red > blue ? red : blue) : (green > blue ? green : blue));
}

@end
