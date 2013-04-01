//
//  NSObject+Be.h
//
//  Created by Tyler Neylon on 6/15/09.
//  Copyright 2009 Bynomial.
//
//  Add the Be category to NSObject.
//  The following common pattern:
//
//    SomeObj *obj1 = [[[SomeObj alloc] initFn] autorelease];
//    AnotherObj *obj2 = [[[AnotherObj alloc] init] autorelease];
//
//  can be replaced with:
//
//    SomeObj *obj1 = [[SomeObj be] initFn];
//    AnotherObj *obj2 = [[AnotherObj beInit];
//
//  This pattern is safe to use for all objects, including
//  cases where an init method changes the value of self.
//

#import <UIKit/UIKit.h>

@interface NSObject (Be)

+ (id)be;
+ (id)beInit;
- (id)beCopy;

@end
