//
//  MapViewController.m
//  PlacesAround
//
//  Created by Patalakh Vadim on 3/3/18.
//  Copyright © 2018 Patalakh Vadim. All rights reserved.
//

#import "MapViewController.h"
#import "MapKit/MapKit.h"

@interface MapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.mapView setAlpha:0.f];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSArray *coordinates = [self.location componentsSeparatedByString:@","];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(
                                                                   ((NSString *)coordinates[0]).doubleValue,
                                                                   ((NSString*)coordinates[1]).doubleValue);
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:coordinate];
    [annotation setTitle:self.name];
    [self.mapView addAnnotation:annotation];
    
    MKCoordinateSpan zoom;
    zoom.latitudeDelta = .1f;
    zoom.longitudeDelta = .1f;
    
    MKCoordinateRegion myRegion;
    myRegion.center = coordinate;
    myRegion.span = zoom;
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.mapView setAlpha:1.f];
    } completion:^(BOOL finished) {
        [self.mapView setRegion:myRegion animated:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
