//
//  WelcomeViewController.m
//  LocalWeather
//
//  Created by Anthony Arzola on 10/31/14.
//  Copyright (c) 2014 Anthony Arzola. All rights reserved.
//

#import "LWWelcomeViewController.h"

#import "LWCityTableViewController.h"

@interface LWWelcomeViewController ()
@end

@implementation LWWelcomeViewController

#pragma mark - UIViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.currentWeatherImageView.alpha = 0.0; //Hide Sun
    
    [UIView animateWithDuration:1.0f
                     animations:^
    {
        self.currentWeatherImageView.alpha = 0.25;  //Start showing the Sun
        self.hazeImageView.alpha = 0.75;
        
     } completion:^(BOOL finished) {
         [UIView animateWithDuration:1.0f
                          animations:^
          {
              self.currentWeatherImageView.alpha = 0.50;
              self.hazeImageView.alpha = 0.50;
              
          } completion:^(BOOL finished)
          {
              [UIView animateWithDuration:1.0f
                               animations:^
               {
                   self.currentWeatherImageView.alpha = 0.75;
                   self.hazeImageView.alpha = 0.25;
                   
               } completion:^(BOOL finished)
               {
                   [UIView animateWithDuration:1.0f animations:^
                   {
                       self.currentWeatherImageView.alpha = 1.0; //Sun in full view
                       self.hazeImageView.alpha = 0.0;
                       
                       [UIView animateWithDuration:0.5f animations:^
                       {
                           UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                           LWCityTableViewController *viewController = [storyboard  instantiateViewControllerWithIdentifier:@"cityTableViewController"];
                           [self.navigationController pushViewController:viewController animated:YES];
                       }];
                   }];
               }];
          }];
     }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
