//
//  LWUtils.h
//  LocalWeather
//
//  Created by Anthony Arzola on 9/21/14.
//  Copyright (c) 2014 Anthony Arzola. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@interface LWUtils : NSObject

/*!
 @abstract Show alert dialog
 @param text Message to display
 @param title Alert dialog's title
 @param viewController View Controller that will display message
 */
+ (void)showMessage:(NSString *)text
          withTitle:(NSString *)title
 fromViewController:(UIViewController *)viewController;

/*!
 @abstract Calculate distance between two CLLocation objects
 @param firstLocation First location
 @param secondLocation Second location
 @returns CLLocationDistance
 */
+ (CLLocationDistance)distanceBetweenLocation:(CLLocation *)firstLocation
                               secondLocation:(CLLocation *)secondLocation;

@end
