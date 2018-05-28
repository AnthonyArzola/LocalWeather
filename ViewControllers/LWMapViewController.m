//
//  WeatherMapViewController.m
//  LocalWeather
//
//  Created by Anthony Arzola on 10/28/14.
//  Copyright (c) 2014 Anthony Arzola. All rights reserved.
//

#import "LWMapViewController.h"

#import "LWDateTimeUtils.h"
#import "LWKCity.h"
#import "LWMapViewAnnotation.h"

@interface LWMapViewController ()
@end

@implementation LWMapViewController

@synthesize currentLocation;
@synthesize cities;

#pragma mark - UIViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.mapView.showsUserLocation = YES;
    
    // Zoom mapView
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(currentLocation.latitude, currentLocation.longitude);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:MKCoordinateRegionMakeWithDistance(coordinate, 6500, 6500)];
    [self.mapView setRegion:adjustedRegion animated:YES];
    
    // Display custom annotations
    [self.mapView addAnnotations:[self createAnnotations]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods

- (NSMutableArray *)createAnnotations
{
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    LWKCity *city;
    
    for(int index=0; index < cities.count; index++)
    {
        city = [cities objectAtIndex:index];
        
        CLLocationCoordinate2D coordinates;
        coordinates.latitude = city.coordinate.latitude + 0.005;
        coordinates.longitude = city.coordinate.longitude;
        
        NSString *annotationTitle = [city.currentWeather currentTemperatureToFahrenheitFormatted];
        NSString *forecastTime = [NSString stringWithFormat:@"@ %@", [LWDateTimeUtils getDateUsingUserSettingsFormat:city.currentWeather.forecastDate]];
        
        LWMapViewAnnotation *annotation = [[LWMapViewAnnotation alloc] initWithTitle:annotationTitle
                                                                            subTitle:forecastTime
                                                                         coordinates:coordinates
                                                                               image:[UIImage imageNamed:city.currentWeather.icon]];
        [annotations addObject:annotation];
    }
    
    return annotations;
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    // If annotation represents user's location, just return nil
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // Handle custom annotation
    if ([annotation isKindOfClass:[LWMapViewAnnotation class]])
    {
        // Attempt to dequeue first
        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"customAnnotation"];
        
        if(annotationView == nil)
        {
            // Create annotation view and init with custom annotation
            annotationView = ((LWMapViewAnnotation*)annotation).createAnnotationView;
        }
        
        annotationView.annotation = annotation;
        
        return annotationView;
    }
    
    return nil;
}

@end
