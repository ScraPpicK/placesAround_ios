//
//  CoordinatesViewController.m
//  PlacesAround
//
//  Created by Patalakh Vadim on 3/4/18.
//  Copyright © 2018 Patalakh Vadim. All rights reserved.
//

#import "CoordinatesViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "PlaceTableViewController.h"

@interface CoordinatesViewController () <CLLocationManagerDelegate, UITextFieldDelegate>

@property (nonatomic, strong)   CLLocationManager   *locationManager;

@property (weak, nonatomic) IBOutlet UITextField *coordinatesTextField;
- (IBAction)searchForNearPlaces:(id)sender;

@end

@implementation CoordinatesViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.locationManager.delegate = self;
    self.coordinatesTextField.delegate = self;
    self.coordinatesTextField.placeholder = @"52.531,13.3843";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)searchForNearPlaces:(id)sender
{
    [self enableLocationService];
}

- (void)enableLocationService
{
    switch ([CLLocationManager authorizationStatus])
    {
        case kCLAuthorizationStatusNotDetermined:
            [self.locationManager requestWhenInUseAuthorization];
            break;
            
        case kCLAuthorizationStatusDenied:
            [self showLocationDeniedMessage];
            break;
            
        case kCLAuthorizationStatusRestricted:
            [self showLocationDeniedMessage];
            break;
            
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [self.locationManager startUpdatingLocation];
            break;
            
        case kCLAuthorizationStatusAuthorizedAlways:
            [self.locationManager startUpdatingLocation];
            break;
            
        default:
            break;
    }
}

- (void)showLocationDeniedMessage
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"To proceed we need to know your location." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Location manager delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location = [locations lastObject];
    double x = (double)location.coordinate.latitude;
    double y = (double)location.coordinate.longitude;
    NSString *locationString = [NSString stringWithFormat:@"%f,%f", x, y];
    [self.locationManager stopUpdatingLocation];
    [self performSegueWithIdentifier:@"FindPlacesSegue" sender:locationString];
}

#pragma mark - Text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *locationString = textField.text;
    [self performSegueWithIdentifier:@"FindPlacesSegue" sender:locationString];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"FindPlacesSegue"])
    {
        PlaceTableViewController *placeController = [segue destinationViewController];
        placeController.locationString = (NSString *)sender;
    }
}

@end
