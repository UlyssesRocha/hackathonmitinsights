//
//  DetailsViewController.m
//  ZLSwipeableViewDemo
//
//  Created by Ulysses Rocha on 15/11/17.
//  Copyright © 2017 Zhixuan Lai. All rights reserved.
//

#import "DetailsViewController.h"
#import "KIImagePager.h"


@interface DetailsViewController () <KIImagePagerDelegate, KIImagePagerDataSource, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet KIImagePager *imagePager;
@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _table.delegate = self;
    _table.dataSource = self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.nmebairro.text = _nb;
    self.tamanho.text = _tm;
    self.dorms.text = _drm;
    self.vagas.text = _vgb;
    self.descricao.text = _dsc;
    
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    _imagePager.captionBackgroundColor = [UIColor clearColor];
    _imagePager.pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
    _imagePager.pageControl.pageIndicatorTintColor = [UIColor blackColor];
    _imagePager.slideshowTimeInterval = 10.5f;
    _imagePager.slideshowShouldCallScrollToDelegate = YES;
    [_table reloadData];

//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.details setText:_pre];
//        self.details.text = _pre;
//        NSLog(@"%@",_pre);
//    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)didPressToReturn:(id)sender {
    [self dismissViewControllerAnimated:true completion:NULL];
}

#pragma mark - DELEGATE
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"Contador -> %d",[_textos count]);
    return [self.textos count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SimpleTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.textLabel.text = _textos[indexPath.row];
    
    return cell;
}


#pragma mark - KIImagePager DataSource
- (NSArray *) arrayWithImages:(KIImagePager*)pager
{
    return _images;
}

- (UIViewContentMode) contentModeForImage:(NSUInteger)image inPager:(KIImagePager *)pager
{
    return UIViewContentModeScaleAspectFit;
}

- (NSString *) captionForImageAtIndex:(NSInteger)index inPager:(KIImagePager *)pager
{
    return @[
             @"",
             @"",
             @""
             ][index];
}

#pragma mark - KIImagePager Delegate
- (void) imagePager:(KIImagePager *)imagePager didScrollToIndex:(NSUInteger)index
{
    NSLog(@"%s %lu", __PRETTY_FUNCTION__, (unsigned long)index);
}

- (void) imagePager:(KIImagePager *)imagePager didSelectImageAtIndex:(NSUInteger)index
{
    NSLog(@"%s %lu", __PRETTY_FUNCTION__, (unsigned long)index);
}


@end
