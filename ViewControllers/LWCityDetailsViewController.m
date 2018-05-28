//
//  CityWeatherDetailsViewController.m
//  LocalWeather
//
//  Created by Anthony Arzola on 9/27/14.
//  Copyright (c) 2014 Anthony Arzola. All rights reserved.
//

#import "LWCityDetailsViewController.h"
#import "LWMapViewAnnotation.h"
#import "LWKCity.h"

#import "LWDateTimeUtils.h"
#import "LWUtils.h"

@interface LWCityDetailsViewController ()
@end

@implementation LWCityDetailsViewController

@synthesize currentLocation;
@synthesize city;

#pragma mark - UIViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@ %@", city.name, [city.currentWeather currentTemperatureToFahrenheitFormatted]];
    
    NSString *minTemperature = [NSString stringWithFormat:@"%.f%@", roundf([city.currentWeather temperatureToFahrenheit:city.currentWeather.minTemperature]), @"\u00B0"];
    NSString *maxTemperature = [NSString stringWithFormat:@"%.f%@", roundf([city.currentWeather temperatureToFahrenheit:city.currentWeather.maxTemperature]), @"\u00B0"];
    NSString *minAndMax = [NSString stringWithFormat:@"%@F | %@F", minTemperature, maxTemperature];
    
    self.labelTemperature.text = minAndMax;
    self.labelDescription.text = city.currentWeather.description;
    self.labelHumidity.text = [NSString stringWithFormat:@"%.f%%", city.currentWeather.humidity];
    
    self.imageViewWeather.alpha = 0.0;
    self.imageViewWeather.image = [UIImage imageNamed:city.currentWeather.icon];

    //Animate Weather image
    [UIView animateWithDuration:2.0f
                     animations:^
                    {
                        self.imageViewWeather.alpha = 1.0;
                    } completion:nil];
    
    self.mapView.alpha = 1.0;
    self.mapView.showsUserLocation = YES;
    
    // Zoom mapView
    CLLocation *clCurrent = [[CLLocation alloc] initWithLatitude:currentLocation.latitude longitude:currentLocation.longitude];
    CLLocation *clCity = [[CLLocation alloc] initWithLatitude:city.coordinate.latitude longitude:city.coordinate.longitude];
    
    double latMeters = 7000.0;
    double longMeters = 7000.0;
    
    CLLocationDistance distance = [LWUtils distanceBetweenLocation:clCurrent secondLocation:clCity];
    if (distance > 1.0 && distance < 4.0)
    {
        latMeters = latMeters + (distance * 2000.0);
        longMeters = longMeters + (distance * 2000.0);
    }
    else if (distance >= 4.0)
    {
        latMeters = latMeters + (distance * 3000.0);
        longMeters = longMeters + (distance * 3000.0);
    }
    
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:MKCoordinateRegionMakeWithDistance(currentLocation, latMeters, longMeters)];
    [self.mapView setRegion:adjustedRegion animated:YES];
    
    // Animate map
    __block CGRect mapFrame = [self.mapView frame];
    [UIView animateWithDuration:0.3f
                     animations:^
    {
        //mapFrame.origin.y = 1000;
        [self.mapView setFrame:mapFrame];
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0f
                          animations:^
         {
             //mapFrame.origin.y = 321;
             self.mapView.alpha = 1.0;
             [self.mapView setFrame:mapFrame];
             [self.view setNeedsLayout];
             [self.mapView layoutIfNeeded];
         } completion:nil];
     
    }];
    
    CLLocationCoordinate2D coord;
    coord.latitude = city.coordinate.latitude + 0.0125;
    coord.longitude = city.coordinate.longitude;

    // Draw Circle
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:coord radius:2000];
    [self.mapView addOverlay:circle];
    
    // Add custom annotations to map
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
    
    CLLocationCoordinate2D coordinates;
    coordinates.latitude = city.coordinate.latitude + 0.0125;
    coordinates.longitude = city.coordinate.longitude;
    
    NSString *annotationTitle = [city.currentWeather currentTemperatureToFahrenheitFormatted];
    NSString *forecastTime = [NSString stringWithFormat:@"@ %@", [LWDateTimeUtils getDateUsingUserSettingsFormat:city.currentWeather.forecastDate]];
    
    LWMapViewAnnotation *annotation = [[LWMapViewAnnotation alloc] initWithTitle:annotationTitle
                                                                        subTitle:forecastTime
                                                                     coordinates:coordinates
                                                                           image:[UIImage imageNamed:city.currentWeather.icon]];
    [annotations addObject:annotation];
    
    return annotations;
}

#pragma mark - MKMapViewDelegate

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView viewForOverlay:(id)overlay
{
    MKCircleRenderer *circleView = [[MKCircleRenderer alloc] initWithOverlay:overlay];
    circleView.strokeColor = [UIColor blueColor];
    circleView.lineWidth = 0.5;
    
    return circleView;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    static NSString *reuseId = @"reuseid";
    
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
    if (annotationView == nil)
    {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 164, 32)];
        label.backgroundColor = [UIColor blackColor];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.alpha = 0.6;
        label.tag = 42;
        // border radius
        [label.layer setCornerRadius:5.0f];
        // border
        [label.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [label.layer setBorderWidth:1.0f];
        label.layer.masksToBounds = YES;
        
        [annotationView addSubview:label];
        
        annotationView.frame = label.frame;
    }
    else
    {
        annotationView.annotation = annotation;
    }
    
    UILabel *label = (UILabel *)[annotationView viewWithTag:42];
    label.text = annotation.title;
    
    return annotationView;
}

#pragma mark - Preview Support

- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
	
	UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"Regular Action"
														  style:UIPreviewActionStyleDefault
														handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
		
															NSLog(@"Regular action selected.");
	}];
	
	UIPreviewAction *action2 = [UIPreviewAction actionWithTitle:@"Destructive Action"
														  style:UIPreviewActionStyleDestructive
														handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
															
															NSLog(@"Destructive action selected.");
	}];
	
	return @[action1, action2];
}

@end
