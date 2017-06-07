//
//  CityWeatherTableViewController.h
//  LocalWeather
//
//  Created by Anthony Arzola on 9/27/14.
//  Copyright (c) 2014 Anthony Arzola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface LWCityTableViewController : UITableViewController
                <CLLocationManagerDelegate, UIViewControllerPreviewingDelegate>

@property (nonatomic, assign) BOOL loadMap;

@end
