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
  
  CGFloat lineWidth;
  CGPoint a;
  CGPoint b;
}

@property (nonatomic, retain) UIColor *color;
@property (nonatomic) CGFloat lineWidth;

+ (LineView *)lineFromPoint:(CGPoint)a toPoint:(CGPoint)b;

// The image will be transparent except for the line, and
// have padding around the line.  It will be sized so that,
// when placed with frameOrigin = (0,0), the line will have
// the coordinates given in the constructor.
- (UIImage *)getImage;

@end
