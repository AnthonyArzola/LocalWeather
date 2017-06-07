//
//  CityWeatherTableViewCell.m
//  LocalWeather
//
//  Created by Anthony Arzola on 9/27/14.
//  Copyright (c) 2014 Anthony Arzola. All rights reserved.
//

#import "LWCityWeatherTableViewCell.h"

@implementation LWCityWeatherTableViewCell


#pragma mark - NSObject

- (void)awakeFromNib {
    
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // Initialization code
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

#pragma mark - Public Methods

- (void)setLabels:(NSString *)cityName temperature:(NSString *)temperature {
    
    self.cityName.text = cityName;
    self.temperature.text = temperature;
}

@end
