//
//  LineView.h
//
//  Created by Tyler Neylon on 4/5/11.
//
//  View to draw a single line.
//
//  Sample usage:
//
//    CGPoint a = CGPointMake(10, 10);
//    CGPoint b = CGPointMake(50, 100);
//    LineView *lineView = [LineView lineFromPoint:a toPoint:b];
//    lineView.color = [UIColor blueColor];
//    [self.view addSubview:lineView];
//

#import <Foundation/Foundation.h>


@interface LineView : UIView {
 @private
  // strong
  UIColor *color;
  UIColor *shadowColor;
  
  CGFloat lineWidth;
  CGPoint a;
  CGPoint b;
  
  BOOL drawShadow;
  CGSize shadowOffset;
  CGFloat shadowBlurRadius;
  // This defaults to 1; increase for heavier shadowing.
  int shadowMultiplicity;
}

@property (nonatomic, retain) UIColor *color;
@property (nonatomic) CGFloat lineWidth;
@property (nonatomic, readonly) CGPoint a;
@property (nonatomic, readonly) CGPoint b;
@property (nonatomic) int shadowMultiplicity;

+ (LineView *)lineFromPoint:(CGPoint)a toPoint:(CGPoint)b;

// The image will be transparent except for the line, and
// have padding around the line.  It will be sized so that,
// when placed with frameOrigin = (0,0), the line will have
// the coordinates given in the constructor.
- (UIImage *)getImage;

- (void)setShadowOffset:(CGSize)offset blurRadius:(CGFloat)blurRadius color:(UIColor *)color;

@end
