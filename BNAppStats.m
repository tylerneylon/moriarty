//
//  BNAppStats.m
//  MadTiles
//
//  Created by Tyler Neylon on 10/18/10.
//  Copyright 2010 Bynomial.
//

#import "BNAppStats.h"

#define kFilename @"bn_app_stats"


static BOOL pendingOpenNote = NO;

@interface BNAppStats ()

+ (int)loadIntWithIndex:(int)index;
+ (void)saveWithInits:(int)inits opens:(int)opens;
+ (NSString *)saveFile;
+ (void)appBecameActive:(NSNotification *)note;

@end


@implementation BNAppStats

+ (int)numAppInits {
  return [self loadIntWithIndex:0];
}

+ (int)numAppOpens {
  return [self loadIntWithIndex:1];
}

+ (void)load {
  pendingOpenNote = YES;
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(appBecameActive:)
                                               name:UIApplicationDidBecomeActiveNotification
                                             object:nil];
}

#pragma mark internal methods

+ (int)loadIntWithIndex:(int)index {
  NSString *path = [self saveFile];
  int offset = (pendingOpenNote ? 1 : 0);
  if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
    return offset;
  }
  NSStringEncoding enc;
  NSString *fileContents = [NSString stringWithContentsOfFile:path usedEncoding:&enc error:NULL];
  int ints[2];
  sscanf([fileContents UTF8String], "%d %d", ints + 0, ints + 1);
  return ints[index] + offset;
}

+ (void)saveWithInits:(int)inits opens:(int)opens {
  NSString *fileContents = [NSString stringWithFormat:@"%d %d", inits, opens];
  [fileContents writeToFile:[self saveFile] atomically:YES encoding:NSUTF8StringEncoding error:NULL];
}

+ (NSString *)saveFile {
	static NSString* path = nil;
	if (path) return path;
#if TARGET_IPHONE_SIMULATOR
	path = @"/tmp/" kFilename;
#else
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                       NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	path = [[documentsDirectory stringByAppendingPathComponent:kFilename] retain];
#endif
	return path;
}
   
+ (void)appBecameActive:(NSNotification *)note {
  int inits = [self loadIntWithIndex:0];
  int opens = [self loadIntWithIndex:1];
  if (!pendingOpenNote) opens++;
  pendingOpenNote = NO;
  [self saveWithInits:inits opens:opens];
}

@end
