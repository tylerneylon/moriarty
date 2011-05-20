//
//  NSString+HMAC.h
//
//  Created by Tyler Neylon on 5/19/11.
//
//  Methods for sending authenticated messages; uses SHA256.
//  See here for an overview of the purpose of these methods:
//  http://en.wikipedia.org/wiki/HMAC
//
//  Sample usage:
//    NSString *msg = [self createMessage];
//    NSString *key = @"a9bk342nziAFD234";  // Private key.
//    NSString *hmac = [msg hmacWithKey:key];
//    NSString *urlStr = [NSString stringWithFormat:
//                        @"http://%@/%@?msg=%@&hmac=%@",
//                        domain, path, msg, hmac];
//  Now send a request to urlStr; if the server knows
//  the private key, it can recompute the HMAC string, and if they
//  match, have confidence that the message originated from someone
//  else who knows the private key as well.
//

#import <Foundation/Foundation.h>

@interface NSData (Hexit)

- (NSString *)hexString;

@end

@interface NSString (HMAC)

- (NSString *)hexString;
- (NSString *)hmacWithKey:(NSString *)key;

@end
