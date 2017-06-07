//
//  CityWeatherTableViewController.m
//  LocalWeather
//
//  Created by Anthony Arzola on 9/27/14.
//  Copyright (c) 2014 Anthony Arzola. All rights reserved.
//

#import "LWCityTableViewController.h"

#import "LWCityWeatherTableViewCell.h"
#import "LWCityDetailsViewController.h"
#import "LWMapViewController.h"
#import "LWDateTimeUtils.h"
#import "LWConstants.h"
#import "LWUtils.h"

#import "LWKManager.h"
#import "LWKCities.h"
#import "LWKCity.h"
#import "MBProgressHUD.h"

@interface LWCityTableViewController ()
{
	CLLocationManager *locationManager;
	CLLocation *currentLocation;
	CLLocation *lastLocation;

	NSArray *cities;

	MBProgressHUD *hud;

	BOOL isDataLoading;
}
@end

@implementation LWCityTableViewController

@synthesize loadMap;

#pragma mark - UIViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        isDataLoading = YES;
		loadMap = NO;
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController setNavigationBarHidden:NO];
	
	if (loadMap)
	{
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
			CLLocationCoordinate2D coordinate;
			coordinate.latitude = currentLocation.coordinate.latitude;
			coordinate.longitude = currentLocation.coordinate.longitude;
			
			LWMapViewController *viewController = (LWMapViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"mapViewController"];
			viewController.currentLocation = coordinate;
			viewController.cities = [cities copy];
			
			[self.navigationController pushViewController:viewController animated:YES];
			
			loadMap = NO;
		});
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.clearsSelectionOnViewWillAppear = NO;
    
    // Pull-down refresh
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor blackColor];
    [refreshControl addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
    
    self.tableView.refreshControl = refreshControl;
    //[self.tableView addSubview:refreshControl];
    self.tableView.separatorColor = [UIColor clearColor];
    
    // Configure HUD
    hud = [[MBProgressHUD alloc] init];
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:.5f];
    hud.square = YES;
    hud.bezelView.color = [UIColor whiteColor];
    hud.label.text = NSLocalizedString(@"Loading local weather...", @"Loading local weather");
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	
	// Check if force touch is available
	if(self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable)
	{
		[self registerForPreviewingWithDelegate:self sourceView:self.tableView];
	}
	
    [self refreshData:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(!isDataLoading)
    {
        return [cities count];
    }
    else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(cities.count == 0)
    {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        if(!isDataLoading)
        {
            cell.textLabel.text = NSLocalizedString(@"Unable to load local weather!", @"Unable to load local weather.");
        }
        
        return cell;
    }
    
    LWCityWeatherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cityWeatheCell" forIndexPath:indexPath];
    if(cell == nil)
    {
        cell = [[LWCityWeatherTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cityWeatheCell"];
    }
    
    // Configure the cell...
    LWKCity *city = [cities objectAtIndex:indexPath.row];
    NSString *forecastTime = [LWDateTimeUtils getDateUsingUserSettingsFormat:city.currentWeather.forecastDate];
    
    [cell setLabels:city.name temperature:[NSString stringWithFormat:@"%@ @ %@", [city.currentWeather currentTemperatureToFahrenheitFormatted], forecastTime]];
    cell.imageViewWeather.image = [UIImage imageNamed:city.currentWeather.icon];

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

#pragma mark - CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"🛰 -- NewLocation %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    
    [locationManager stopUpdatingLocation];
	currentLocation = newLocation;
    lastLocation = oldLocation;
    
    if(isDataLoading)
    {
        [[LWKManager sharedInstance] getCurrentWeatherByCoordinatesWithLatitude:newLocation.coordinate.latitude
                                                                      longitude:newLocation.coordinate.longitude
                                                              expectedCityCount:15
                                                                         apiKey:KEY_ID
                                                                    withSuccess:^(id responseObject)
        {
            self.tableView.hidden = NO;
            
            LWKCities *result = (LWKCities *)responseObject;
            cities = result.list;
            
            [self.tableView reloadData];
            self.tableView.separatorColor = [UIColor lightGrayColor];
            
        } withFailure:^(NSError *error) {
            
            [LWUtils showMessage:NSLocalizedString(@"Unable to load weather data. Please try again.", @"Unable to load weather alert view message.")
                       withTitle:NSLocalizedString(@"Oops!", @"Unable to load weather attempt-to-be-witty title")
              fromViewController:self];
        }];
        
        isDataLoading = NO;
        [hud hideAnimated:YES];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        [self refreshData:nil];
    }
    else if (status == kCLAuthorizationStatusDenied)
    {
        [hud hideAnimated:YES];
        
        UIAlertController *alertController =
        [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Permission Needed", @"Pemission needed alert view title")
                                            message:NSLocalizedString(@"Local Weather needs to know your location in order to provide location based weather.", @"Local Weather needs to know your location.")
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *defaultAction =
        [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"Alert view Cancel option")
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action) {
                                   // NOP
                               }];
        
        UIAlertAction *settingsAction =
        [UIAlertAction actionWithTitle:NSLocalizedString(@"Show Settings", @"Alert view App Settings option")
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * _Nonnull action) {
                                   NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                   [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                               }];
        
        [alertController addAction:defaultAction];
        [alertController addAction:settingsAction];
        
        [self presentViewController:alertController
                                     animated:YES
                                   completion:nil];
    }
}

#pragma mark - UIViewControllerPreviewingDelegate methods

- (UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
	NSLog(@"👀 - Peek/Creep CityWeatherDetailsViewController");
	
	NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
	LWKCity *city = [cities objectAtIndex:indexPath.row];
	
	if (city)
	{
		LWCityWeatherTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
		
		if (cell)
		{
			previewingContext.sourceRect = cell.frame;
			
			LWCityDetailsViewController *viewController = (LWCityDetailsViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"cityDetailsViewController"];
			viewController.city = city;
			return viewController;
		}
	}
	
	return nil;
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
{
	NSLog(@"💣 - Pop CityWeatherDetailsViewController");
	[self.navigationController pushViewController:viewControllerToCommit animated:NO];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"toCityWeatherDetails"])
    {
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        LWKCity *city = [cities objectAtIndex:indexPath.row];
        
        LWCityDetailsViewController *viewController = (LWCityDetailsViewController *)segue.destinationViewController;
        viewController.city = city;
    }
    else
    {
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = currentLocation.coordinate.latitude;
        coordinate.longitude = currentLocation.coordinate.longitude;
        
        LWMapViewController *viewController = (LWMapViewController *)segue.destinationViewController;
        viewController.currentLocation = coordinate;
        viewController.cities = [cities copy];
    }
}

#pragma mark - Private methods

- (void)refreshData:(UIRefreshControl *)refreshControl
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if (status == kCLAuthorizationStatusNotDetermined)
    {
        // Request access
        [locationManager requestWhenInUseAuthorization];
    }
    else if (status == kCLAuthorizationStatusDenied)
    {
        // User has explicitly denied access to the location services
        [hud hideAnimated:YES];
    }
    else if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways)
    {
        [hud showAnimated:YES];
        isDataLoading = YES;
        [locationManager startUpdatingLocation];
    }
    
    if(refreshControl != nil)
        [refreshControl endRefreshing];
}

@end
