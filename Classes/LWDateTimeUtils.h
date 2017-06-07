//
//  LWDateTimeUtils.h
//  LocalWeather
//
//  Created by Anthony Arzola on 9/21/14.
//  Copyright (c) 2014 Anthony Arzola. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LWDateTimeUtils : NSObject

/*!
 @abstract Convert date to string using system defined format
 @param date Date object to convert
 @returns String object
 */
+ (NSString *)getDateUsingUserSettingsFormat:(NSDate *)date;

@end
