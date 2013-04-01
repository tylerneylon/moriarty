//
//  NSObject+Be.m
//
//  Created by Tyler Neylon on 6/15/09.
//  Copyright 2009 Bynomial.
//

#import "NSObject+Be.h"

@interface BeProxy : NSProxy {
  id target;
}

+ (BeProxy *)beProxyForClass:(Class)class;

- (void)forwardInvocation:(NSInvocation *)anInvocation;
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector;

@end

@implementation BeProxy

+ (BeProxy *)beProxyForClass:(Class)class {
  BeProxy *beProxy = [BeProxy alloc];
  beProxy->target = [class alloc];
  return beProxy;
}

// We assume the method called is an init method.  The return value
// may be a new value for self.
- (void)forwardInvocation:(NSInvocation *)anInvocation {
  [anInvocation setTarget:target];
  [anInvocation invoke];
  id object;
  [anInvocation getReturnValue:(void *)&object];
  [object autorelease];
  [self release];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
  return [target methodSignatureForSelector:aSelector];
}

@end




@implementation NSObject (Be)

+ (id)be {
  return [BeProxy beProxyForClass:[self class]];
}

+ (id)beInit {
  return [[[self class] new] autorelease];
}

- (id)beCopy {
  return [[self copy] autorelease];
}

@end
