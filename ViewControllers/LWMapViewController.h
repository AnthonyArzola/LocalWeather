//
//  WeatherMapViewController.h
//  LocalWeather
//
//  Created by Anthony Arzola on 10/28/14.
//  Copyright (c) 2014 Anthony Arzola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface LWMapViewController : UIViewController

@property (nonatomic, assign) CLLocationCoordinate2D currentLocation;
@property (nonatomic, strong) NSArray *cities;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
