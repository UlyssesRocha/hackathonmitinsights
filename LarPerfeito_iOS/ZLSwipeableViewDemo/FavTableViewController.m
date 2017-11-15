//
//  FavTableViewController.m
//  LarPerfeito
//
//  Created by Ulysses Rocha on 15/11/17.
//  Copyright © 2017 Zhixuan Lai. All rights reserved.
//

#import "FavTableViewController.h"
#import "FavTableViewCell.h"
#import "DetailsViewController.h"

@interface FavTableViewController ()
@property (nonatomic,strong) NSMutableArray *json;
@property int selectedIndex;

@end

@implementation FavTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


-(void)viewWillAppear:(BOOL)animated{
    NSError *error;
    NSString *url_string = [NSString stringWithFormat: @"https://mitinsightsbackend.herokuapp.com/api/ulysses/favorites/"];
    NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString:url_string]];
    _json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSLog(@"json: %@", _json);
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_json valueForKey:@"items"] count]
    ;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _selectedIndex = indexPath.row;
    [self performSegueWithIdentifier:@"euacredito" sender:NULL];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FavTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fav" forIndexPath:indexPath];
    
    NSLog(@"->>%@",[[[[_json valueForKey:@"items"][indexPath.row] valueForKey:@"immobile"] valueForKey:@"address"] valueForKey:@"neighborhood"]);
    
    cell.tam.text =[NSString stringWithFormat:@"%@ m²", [[[_json valueForKey:@"items"][indexPath.row]  valueForKey:@"immobile"] valueForKey:@"area"]];
    
   cell.bairro.text = [[[[_json valueForKey:@"items"][indexPath.row] valueForKey:@"immobile"] valueForKey:@"address"] valueForKey:@"neighborhood"];
    
    cell.dorms = [NSString stringWithFormat:@"%@ Quarto(s)", [[[_json valueForKey:@"items"][indexPath.row] valueForKey:@"immobile"] valueForKey:@"rooms"]];
                  
    cell.vaga.text = [NSString stringWithFormat:@"%@ Vagas(s)", [[[_json valueForKey:@"items"][indexPath.row]  valueForKey:@"immobile"]valueForKey:@"parkingSpaces"]];
    
    cell.preco.text = [NSString stringWithFormat:@"R$%@", [[[_json valueForKey:@"items"][indexPath.row] valueForKey:@"immobile"] valueForKey:@"price"]];
    
    
        return cell;
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier] isEqualToString:@"euacredito"]){
//        
//        UIView *topView = [self.swipeableView topView];
//        if (!topView) {
//            return;
//        }
        
        // Get reference to the destination view controller
        DetailsViewController *vc = [segue destinationViewController];
        
//        CardView *localView = topView;
        
        vc.images = [[[_json valueForKey:@"items"][_selectedIndex] valueForKey:@"immobile"] valueForKey:@"photos"];
        
        vc.textos = [[NSMutableArray alloc] init];
        
        vc.nb = [[[[_json valueForKey:@"items"][_selectedIndex] valueForKey:@"immobile"] valueForKey:@"address"] valueForKey:@"neighborhood"];
        
        vc.tm = [NSString stringWithFormat:@"%@ m²", [[[_json valueForKey:@"items"][_selectedIndex] valueForKey:@"immobile"]valueForKey:@"area"]];
        
        vc.drm =  [NSString stringWithFormat:@"%@ Quarto(s)", [[[_json valueForKey:@"items"][_selectedIndex] valueForKey:@"immobile"] valueForKey:@"rooms"]];
        
        vc.vgb = [NSString stringWithFormat:@"%@ Vaga(s)", [[[_json valueForKey:@"items"][_selectedIndex] valueForKey:@"immobile"] valueForKey:@"rooms"]];
        
        vc.dsc = [[[_json valueForKey:@"items"][_selectedIndex] valueForKey:@"immobile"] valueForKey:@"details"];
        
        
        if( (int) [[[_json valueForKey:@"items"][_selectedIndex] valueForKey:@"immobile"] valueForKey:@"fitness"] == 1){
            [vc.textos addObject:@"Academia"];
        }
        
        if( (int) [[[_json valueForKey:@"items"][_selectedIndex] valueForKey:@"immobile"] valueForKey:@"pools"] >= 1){
            [vc.textos addObject:@"Piscina"];
        }
        
        if( (int) [[[_json valueForKey:@"items"][_selectedIndex] valueForKey:@"immobile"] valueForKey:@"suites"] >= 1){
            [vc.textos addObject:@"Suite" ];
        }
        
        [vc.textos addObject: [NSString stringWithFormat:@"R$%@", [[[_json valueForKey:@"items"][_selectedIndex] valueForKey:@"immobile"] valueForKey:@"price"]]];
        
        NSLog(@"Terminei %d", [vc.textos count]);
    }
}

 
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
