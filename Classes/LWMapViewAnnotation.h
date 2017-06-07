//
//  LWMapViewAnnotation.h
//  LocalWeather
//
//  Created by Anthony Arzola on 10/28/14.
//  Copyright (c) 2014 Anthony Arzola. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface LWMapViewAnnotation : NSObject <MKAnnotation>

@property (nonatomic, strong) UIImage *image;

/*!
 @abstract Initialize LWMapViewAnnotation object
 @param annotationTitle Custom title for annotation
 @param annotationSubTitle Custom subtitle for annotation
 @param annotationCoordinates Annotation's coordinate
 @param annotationImage Custom image for annotation
 @returns LWMapViewAnnotation object
 */
- (id)initWithTitle:(NSString *)annotationTitle
           subTitle:(NSString *)annotationSubTitle
        coordinates:(CLLocationCoordinate2D)annotationCoordinates
              image:(UIImage *)annotationImage;

/*!
 @abstract Create MKAnnotation using LWMapAnnocation object's image
 @return MKAnnotation object
 */
- (MKAnnotationView *)createAnnotationView;

@end
