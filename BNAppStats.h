//
//  BNAppStats.h
//  MadTiles
//
//  Created by Tyler Neylon on 10/18/10.
//  Copyright 2010 Bynomial.
//
//  A helper class to easily determine how
//  many times an app has been opened or initialized.
//
//  An "open" is any time anyone clicks on your
//  app's icon to start it.
//
//  An "init" is any time your app's icon is clicked,
//  _and_ it is not already present in memory.
//
//  We have #inits <= #opens, and it can be < due to
//  multitasking; specifically your app may only be
//  hidden and not closed between some sessions.
//

#import <Foundation/Foundation.h>


@interface BNAppStats : NSObject {

}

+ (int)numAppInits;
+ (int)numAppOpens;

@end
