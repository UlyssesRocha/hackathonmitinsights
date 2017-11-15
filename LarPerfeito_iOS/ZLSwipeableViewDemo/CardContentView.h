//
//  CardContentView.h
//  ZLSwipeableViewDemo
//
//  Created by Ulysses Rocha on 15/11/17.
//  Copyright © 2017 Zhixuan Lai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardContentView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *bedroomsLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkingLabel;
@property (strong, nonatomic) NSArray *images;


@end
