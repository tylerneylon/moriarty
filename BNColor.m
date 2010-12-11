//
//  BNColor.m
//
//  Created by Tyler Neylon on 11/25/09.
//  Copyleft 2009 Bynomial.
//

#import "BNColor.h"

#define kRedKey @"r"
#define kGreenKey @"g"
#define kBlueKey @"b"

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

+ (BNColor *)redColor {
  return [BNColor colorWithRed:1 green:0 blue:0];
}

+ (BNColor *)orangeColor {
  return [BNColor colorWithRed:1 green:0.5 blue:0];
}

+ (BNColor *)yellowColor {
  return [BNColor colorWithRed:1 green:1 blue:0];
}

+ (BNColor *)greenColor {
  return [BNColor colorWithRed:0 green:1 blue:0];
}

+ (BNColor *)blueColor {
  return [BNColor colorWithRed:0 green:0 blue:1];
}

+ (BNColor *)purpleColor {
  return [BNColor colorWithRed:0.5 green:0 blue:0.5];
}

+ (BNColor *)magentaColor {
  return [BNColor colorWithRed:1 green:0 blue:1];
}

+ (BNColor *)cyanColor {
  return [BNColor colorWithRed:0 green:1 blue:1];
}

+ (BNColor *)brownColor {
  return [BNColor colorWithRed:0.6 green:0.4 blue:0.2];
}

+ (BNColor *)blackColor {
  return [BNColor colorWithRed:0 green:0 blue:0];
}

+ (BNColor *)darkGrayColor {
  return [BNColor colorWithRed:1.0/3.0 green:1.0/3.0 blue:1.0/3.0];
}

+ (BNColor *)lightGrayColor {
  return [BNColor colorWithRed:2.0/3.0 green:2.0/3.0 blue:2.0/3.0];
}

+ (BNColor *)whiteColor {
  return [BNColor colorWithRed:1 green:1 blue:1];
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
