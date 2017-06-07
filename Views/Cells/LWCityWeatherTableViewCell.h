//
//  CityWeatherTableViewCell.h
//  LocalWeather
//
//  Created by Anthony Arzola on 9/27/14.
//  Copyright (c) 2014 Anthony Arzola. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LWCityWeatherTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *cityName;
@property (nonatomic, weak) IBOutlet UILabel *temperature;
@property (nonatomic, weak) IBOutlet UIImageView *imageViewWeather;

-(void)setLabels:(NSString *)cityName temperature:(NSString *)temperature;

@end
