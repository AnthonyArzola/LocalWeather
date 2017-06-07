//
//  LWUtils.m
//  LocalWeather
//
//  Created by Anthony Arzola on 9/21/14.
//  Copyright (c) 2014 Anthony Arzola. All rights reserved.
//

#import "LWUtils.h"

@implementation LWUtils

#pragma mark - UI

+ (void)showMessage:(NSString *)text
          withTitle:(NSString *)title
 fromViewController:(UIViewController *)viewController {
    
    if ([viewController isViewLoaded] &&
        viewController.view.window &&
        viewController.navigationController.topViewController == viewController) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                                 message:text
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction *action) {
                                                                  // NOP
                                                              }];
        
        [alertController addAction:defaultAction];
        
        [viewController presentViewController:alertController
                                     animated:YES
                                   completion:nil];
    }
}

#pragma mark - Math

+ (CLLocationDistance)distanceBetweenLocation:(CLLocation *)firstLocation
                               secondLocation:(CLLocation *)secondLocation {
    
    return [firstLocation distanceFromLocation:secondLocation] * 0.000621371;
}

@end
