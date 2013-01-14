//
//  NSString+bath.m
//  BathCalc
//
//  Created by Greg Jaskiewicz on 14/01/2013.
//  Copyright (c) 2013 Greg Jaskiewicz. All rights reserved.
//

#import "NSString+bath.h"

@implementation NSString (bath)

- (BOOL) isAllDigits
{
  NSCharacterSet* nonNumbers = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
  NSRange r = [self rangeOfCharacterFromSet: nonNumbers];
  return r.location == NSNotFound;
}

@end
