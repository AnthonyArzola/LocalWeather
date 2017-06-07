//
//  LWDateTimeUtils.m
//  LocalWeather
//
//  Created by Anthony Arzola on 9/21/14.
//  Copyright (c) 2014 Anthony Arzola. All rights reserved.
//

#import "LWDateTimeUtils.h"

@implementation LWDateTimeUtils

+ (NSString *)getDateUsingUserSettingsFormat:(NSDate *)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    return [dateFormatter stringFromDate:date];
}

@end
