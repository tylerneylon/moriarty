//
//  WipeView.m
//  WipeView
//
//  Created by Tyler Neylon on 3/30/11.
//

#import "WipeView.h"

#import "NSObject+Be.h"
#import "UIView+Position.h"

#import <QuartzCore/QuartzCore.h>

@implementation WipeView

@synthesize image, delegate, duration;

- (id)initWithFrame:(CGRect)frame {
  if (![super initWithFrame:frame]) return nil;
  duration = 1.0;  // Default animation time.
  contentView = [UIView beInit];
  [self addSubview:contentView];
  [self setFrame:frame];
  return self;
}

- (void)setFrame:(CGRect)frame {
  [super setFrame:frame];
  contentView.frame = self.bounds;
}

- (void)wipeOutInDirection:(CGPoint)direction {
  CGRect endingContentsRect = CGRectMake(0, 0, 1 - abs(direction.x), 1 - abs(direction.y));
  if (direction.x < 0) endingContentsRect.origin.x = 1;
  if (direction.y < 0) endingContentsRect.origin.y = 1;
  
  BOOL useLowerRight = (direction.x + direction.y < 0);
  if (useLowerRight) {
    contentView.layer.anchorPoint = CGPointMake(1, 1);
    contentView.layer.position = CGPointMake(self.bounds.size.width, self.bounds.size.height);
  } else {
    contentView.layer.anchorPoint = CGPointZero;
    contentView.layer.position = CGPointZero;
  }  
  
  CGAffineTransform t = CGAffineTransformMakeScale(self.bounds.size.width, self.bounds.size.height);
  CGRect endingBounds = CGRectApplyAffineTransform(endingContentsRect, t);
  
  CABasicAnimation *contentsRectAnim = [CABasicAnimation animationWithKeyPath:@"contentsRect"];
  contentsRectAnim.fromValue = [NSValue valueWithCGRect:contentView.layer.contentsRect];
  contentsRectAnim.toValue = [NSValue valueWithCGRect:endingContentsRect];
  
  CABasicAnimation *boundsAnim = [CABasicAnimation animationWithKeyPath:@"bounds"];
  boundsAnim.fromValue = [NSValue valueWithCGRect:contentView.layer.bounds];
  boundsAnim.toValue = [NSValue valueWithCGRect:endingBounds];
  
  CAAnimationGroup *animations = [CAAnimationGroup animation];
  animations.delegate = self;
  animations.duration = duration;
  animations.animations = [NSArray arrayWithObjects:contentsRectAnim, boundsAnim, nil];
  
  [contentView.layer addAnimation:animations forKey:@"wipeOut"];
  
  contentView.layer.contentsRect = endingContentsRect;
  contentView.layer.bounds = endingBounds;
}

- (void)setImage:(UIImage *)newImage {
  [newImage retain];
  [image release];
  image = newImage;
  
  self.frameSize = image.size;
  contentView.frame = self.bounds;
  contentView.layer.contents = (id)image.CGImage;
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
  [delegate wipeDidStop];
}

@end
