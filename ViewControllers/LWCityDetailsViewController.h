//
//  CityWeatherDetailsViewController.h
//  LocalWeather
//
//  Created by Anthony Arzola on 9/27/14.
//  Copyright (c) 2014 Anthony Arzola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@class LWMapViewAnnotation;
@class LWKCity;

@interface LWCityDetailsViewController : UIViewController

@property (nonatomic, assign) CLLocationCoordinate2D currentLocation;
@property (nonatomic, weak) LWKCity *city;

@property (weak, nonatomic) IBOutlet UILabel *labelTemperature;
@property (weak, nonatomic) IBOutlet UILabel *labelDescription;
@property (weak, nonatomic) IBOutlet UILabel *labelHumidity;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewWeather;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
