//
//  DetailsViewController.h
//  ZLSwipeableViewDemo
//
//  Created by Ulysses Rocha on 15/11/17.
//  Copyright © 2017 Zhixuan Lai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KIImagePager.h"

@interface DetailsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *details;
@property (nonatomic) NSString* pre;
@property (strong, nonatomic) NSArray *images;
@property NSMutableArray *textos;

@property NSString *nb;
@property NSString *tm;
@property NSString *drm;
@property NSString *vgb;
@property NSString *dsc;


@property (weak, nonatomic) IBOutlet UILabel *nmebairro;
@property (weak, nonatomic) IBOutlet UILabel *tamanho;
@property (weak, nonatomic) IBOutlet UILabel *dorms;
@property (weak, nonatomic) IBOutlet UILabel *vagas;
@property (weak, nonatomic) IBOutlet UITextView *descricao;



@end
