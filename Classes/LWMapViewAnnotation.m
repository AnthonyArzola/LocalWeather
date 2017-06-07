//
//  LWMapViewAnnotation.m
//  LocalWeather
//
//  Created by Anthony Arzola on 10/28/14.
//  Copyright (c) 2014 Anthony Arzola. All rights reserved.
//

#import "LWMapViewAnnotation.h"

@implementation LWMapViewAnnotation

// Following 3 properties are defined in MKAnnotation protocol
@synthesize title;
@synthesize subtitle;
@synthesize coordinate;

@synthesize image;

#pragma mark - Public methods

- (id)initWithTitle:(NSString *)annotationTitle
           subTitle:(NSString *)annotationSubTitle
        coordinates:(CLLocationCoordinate2D)annotationCoordinates
              image:(UIImage *)annotationImage {
    
   if (self = [super init]) {
       
       title = annotationTitle;
       subtitle = annotationSubTitle;
       coordinate = annotationCoordinates;
       image = annotationImage;
   }
    
    return self;
}

- (MKAnnotationView *)createAnnotationView {
    
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self
                                                                    reuseIdentifier:@"customAnnotation"];
    
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    
    CGRect rect = CGRectMake(0,0,48,48);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    annotationView.alpha = 1.0;
    annotationView.image = newImage;
    
    return annotationView;
}

@end
