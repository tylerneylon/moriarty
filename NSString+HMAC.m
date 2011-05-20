//
//  NSString+HMAC.m
//
//  Created by Tyler Neylon on 5/19/11.
//

#import "NSString+HMAC.h"

#import <CommonCrypto/CommonHMAC.h>

@implementation NSData (Hexit)

- (NSString *)hexString {
  NSMutableString *str = [NSMutableString stringWithCapacity:[self length]];
  const unsigned char *byte = [self bytes];
  const unsigned char *endByte = byte + [self length];
  for (; byte != endByte; ++byte) [str appendFormat:@"%02x", *byte];
  return str;
}

@end

@implementation NSString (HMAC)

- (NSString *)hexString {
  const char *cStr = [self UTF8String];
  return [[NSData dataWithBytes:cStr length:strlen(cStr)] hexString];
}

- (NSString *)hmacWithKey:(NSString *)key {
  const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
  const char *cData = [self cStringUsingEncoding:NSASCIIStringEncoding];
  unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
  CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
  return [[NSData dataWithBytes:cHMAC length:sizeof(cHMAC)] hexString];
}

@end
