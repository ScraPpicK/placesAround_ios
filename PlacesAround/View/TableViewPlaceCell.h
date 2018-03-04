//
//  TableViewPlaceCell.h
//  PlacesAround
//
//  Created by Patalakh Vadim on 3/2/18.
//  Copyright © 2018 Patalakh Vadim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewPlaceCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *placeImageView;
@property (weak, nonatomic) IBOutlet UILabel *placeName;
@property (weak, nonatomic) IBOutlet UILabel *placeAddress;
@property (weak, nonatomic) IBOutlet UILabel *placeCoordinates;

@end
