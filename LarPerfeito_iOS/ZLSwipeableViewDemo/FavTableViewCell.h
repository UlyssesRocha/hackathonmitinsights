//
//  FavTableViewCell.h
//  LarPerfeito
//
//  Created by Ulysses Rocha on 15/11/17.
//  Copyright © 2017 Zhixuan Lai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *bairro;
@property (weak, nonatomic) IBOutlet UILabel *preco;
@property (weak, nonatomic) IBOutlet UILabel *tam;
@property (weak, nonatomic) IBOutlet UILabel *dorms;
@property (weak, nonatomic) IBOutlet UILabel *vaga;
@end
