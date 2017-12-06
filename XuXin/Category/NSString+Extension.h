//
//  NSString+Extension.h
//  GTODashboard
//
//  Created by Benjamin on 6/4/13.
//  Copyright (c) 2013 ActiveMobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface NSString (Extension)

+ (NSString *)createUUID;

- (NSString *)trimmingString;

- (NSString *)MD5Hash;

- (NSString *)SHA1;

- (NSNumber *)stringToNSNumber;

- (NSString *)reverse;

- (BOOL)stringContainsSubString:(NSString *)subString;

/**
 nil, @"", @"  ", @"\n" will Returns NO; otherwise Returns YES.
 */
- (BOOL)isNotBlank;

- (CGSize)sizeOfTextWithFont:(UIFont *)font;

+ (BOOL)validateEmailWithString:(NSString*)email;

@end
