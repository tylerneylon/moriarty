//
//  LineView.m
//  MadTiles
//
//  Created by Tyler Neylon on 4/5/11.
//  Copyright 2011 Bynomial. All rights reserved.
//

#import "LineView.h"

#import "NSObject+Be.h"
#import "UIView+Position.h"

#define kPadding 10

static float min(float a, float b) {
  return (a < b ? a : b);
}

static float max(float a, float b) {
  return (a < b ? b : a);
}


@interface LineView ()

@property (nonatomic, retain) UIColor *shadowColor;

- (void)drawWithOffset:(CGPoint)offset;

@end



@implementation LineView

@synthesize color, lineWidth, a, b;
@synthesize shadowMultiplicity;

- (id)initFromPoint:(CGPoint)a_ toPoint:(CGPoint)b_ {
  CGRect frame = CGRectMake(min(a_.x, b_.x) - kPadding, min(a_.y, b_.y) - kPadding,
                            max(a_.x, b_.x) + 2 * kPadding, max(a_.y, b_.y) + 2 * kPadding);
  if (![super initWithFrame:frame]) return nil;
  
  a = a_;
  b = b_;
  self.color = [UIColor blackColor];
  self.backgroundColor = [UIColor clearColor];
  self.userInteractionEnabled = NO;
  lineWidth = 2;
  
  shadowMultiplicity = 1;
  
  return self;
}

- (void)dealloc {
  self.color = nil;
  self.shadowColor = nil;
  [super dealloc];
}

+ (LineView *)lineFromPoint:(CGPoint)a toPoint:(CGPoint)b {
  return [[LineView be] initFromPoint:a toPoint:b];
}

- (UIImage *)getImage {
  CGSize imageSize = CGSizeMake(self.frameRight, self.frameBottom);
  UIGraphicsBeginImageContext(imageSize);
  [self drawWithOffset:CGPointZero];
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return image;
}

- (void)setShadowOffset:(CGSize)offset blurRadius:(CGFloat)blurRadius color:(UIColor *)color_ {
  drawShadow = YES;
  shadowOffset = offset;
  shadowBlurRadius = blurRadius;
  self.shadowColor = color_;
  [self setNeedsDisplay];
}

- (void)setColor:(UIColor *)newColor {
  if (color == newColor) return;
  [color release];
  color = [newColor retain];
  [self setNeedsDisplay];
}

- (void)setLineWidth:(CGFloat)newLineWidth {
  if (lineWidth == newLineWidth) return;
  lineWidth = newLineWidth;
  [self setNeedsDisplay];
}

- (void)setShadowMultiplicity:(int)newShadowMultiplicity {
  if (shadowMultiplicity == newShadowMultiplicity) return;
  shadowMultiplicity = newShadowMultiplicity;
  [self setNeedsDisplay];
}

#pragma mark UIView methods

- (void)drawRect:(CGRect)rect {
  [self drawWithOffset:self.frameOrigin];
  if (drawShadow && shadowMultiplicity > 1) {
    for (int i = 1; i < shadowMultiplicity; ++i) {
      [self drawWithOffset:self.frameOrigin];
    }
  }
}

#pragma mark private methods

@synthesize shadowColor;

- (void)drawWithOffset:(CGPoint)offset {
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  
  if (drawShadow) {
    CGContextSetShadowWithColor(ctx, shadowOffset, shadowBlurRadius, shadowColor.CGColor);
  }
  
  CGContextSetLineWidth(ctx, lineWidth);
  [color setStroke];
  
  CGContextBeginPath(ctx);
  CGContextMoveToPoint(ctx, a.x - offset.x, a.y - offset.y);
  CGContextAddLineToPoint(ctx, b.x - offset.x, b.y - offset.y);
  CGContextStrokePath(ctx);
}

@end
