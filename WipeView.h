//
//  WipeView.h
//  WipeView
//
//  Created by Tyler Neylon on 3/30/11.
//
//  An image view that can animate out via a wipe.
//  For example, a left-to-right wipe out animation
//  (corresponding to direction (-1,0) = left), would
//  look like this over time:
//
//  1.  /----\
//      |----|
//      \----/
//  2.    ---\
//        ---|
//        ---/
//  3.      -\
//          -|
//          -/
//  4.
//
//
//  Things are much more efficient without transparency,
//  so the current code does not support any transparency
//  along the disappearing edge -- it's a hard cut-off.
//
//  You can leave the delegate as nil if you don't care
//  about when the animation finishes.
//


#import <Foundation/Foundation.h>


@protocol WipeViewDelegate

- (void)wipeDidStop;

@end



@interface WipeView : UIView {
 @private
  // strong
  UIImage *image;
  
  // weak
  UIView *contentView;
  id<WipeViewDelegate> delegate;
  NSTimeInterval duration;
}

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, assign) id<WipeViewDelegate> delegate;
@property (nonatomic) NSTimeInterval duration;

- (void)wipeOutInDirection:(CGPoint)direction;

@end
