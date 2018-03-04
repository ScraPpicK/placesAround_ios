//
//  PlaceTableViewController.m
//  PlacesAround
//
//  Created by Patalakh Vadim on 3/2/18.
//  Copyright © 2018 Patalakh Vadim. All rights reserved.
//

#import "PlaceTableViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MapViewController.h"
#import "TableViewPlaceCell.h"
#import "DownloadManager.h"
#import "Place.h"

#define kNumberOfSections   1

@interface PlaceTableViewController () <DownloadManagerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (atomic, strong)      NSArray<Place *>    *places;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PlaceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"TableViewPlaceCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"TableViewPlaceCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.hidden = YES;
    
    DownloadManager *manager = [DownloadManager shared];
    manager.delegate = self;
    [manager downloadPlacesForLocation:self.locationString];
    
    self.navigationItem.hidesBackButton = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kNumberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.places.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewPlaceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewPlaceCell" forIndexPath:indexPath];
    
    // Configure the cell...
    Place *placeForCell = [self.places objectAtIndex:indexPath.row];
    cell.placeName.text = placeForCell.name;
    [cell.placeImageView sd_setImageWithURL:placeForCell.image];
    cell.placeAddress.text = placeForCell.address;
    cell.placeCoordinates.text = placeForCell.location;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Place *place = [self.places objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"ShowLocationAtMapSegue" sender:place];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Download manager delegate

- (void)didFinishLoadingPlaces:(NSArray *)places
{
    self.places = places;
    [self.tableView reloadData];
    self.tableView.hidden = NO;
}

- (void)couldNotDownloadPlaces:(NSInteger)error
{
    NSString *errorMessage = @"Oops, something went wrong.";
    switch (error) {
        case notValidUrl:
            errorMessage = @"Oops, we could find places for this location, check coordinates please.";
            break;
            
        case couldNotDownloadData:
            errorMessage = @"Oops, we could connect to the server, check your internet connection or try later.";
            
        case couldNotParseData:
            errorMessage = @"Oops, we couldn`t find places for you. Try another coordinates please.";
            
        default:
            break;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Go back" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Segue interaction

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowLocationAtMapSegue"])
    {
        MapViewController *mapController = segue.destinationViewController;
        mapController.location = ((Place *)sender).location;
        mapController.name = ((Place *)sender).name;
    }
}

@end
