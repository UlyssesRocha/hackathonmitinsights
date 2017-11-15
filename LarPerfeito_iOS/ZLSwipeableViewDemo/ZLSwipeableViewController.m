//
//  ViewController.m
//  ZLSwipeableViewDemo
//
//  Created by Zhixuan Lai on 11/1/14.
//  Copyright (c) 2014 Zhixuan Lai. All rights reserved.
//

#import "ZLSwipeableViewController.h"
#import "UIColor+FlatColors.h"
#import "CardView.h"
#import "CardContentView.h"
#import "DetailsViewController.h"
#import "KIImagePager.h"

@interface ZLSwipeableViewController () <KIImagePagerDelegate, KIImagePagerDataSource>


@property (nonatomic, strong) NSArray *colors;
@property (nonatomic) NSUInteger colorIndex;

@property (nonatomic) BOOL loadCardFromXib;

@property (nonatomic, strong) UIBarButtonItem *reloadBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *leftBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *upBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *rightBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *downBarButtonItem;
@property (nonatomic,strong) NSMutableArray *json;
@end

@implementation ZLSwipeableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.toolbarHidden = YES;
    self.view.clipsToBounds = YES;
    self.view.backgroundColor = [UIColor whiteColor];

    // Do any additional setup after loading the view, typically from a nib.
    self.colorIndex = 0;
    self.colors = @[
        @"Turquoise",
        @"Green Sea",
        @"Emerald",
        @"Nephritis",
        @"Peter River",
        @"Belize Hole",
        @"Amethyst",
        @"Wisteria",
        @"Wet Asphalt",
        @"Midnight Blue",
        @"Sun Flower",
        @"Orange",
        @"Carrot",
        @"Pumpkin",
        @"Alizarin",
        @"Pomegranate",
        @"Clouds",
        @"Silver",
        @"Concrete",
        @"Asbestos"
    ];


//
//    // Required Data Source
    self.swipeableView.dataSource = self;
//
//    // Optional Delegate
    self.swipeableView.delegate = self;
//
    self.swipeableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSError *error;
    NSString *url_string = [NSString stringWithFormat: @"https://mitinsightsbackend.herokuapp.com/api/ulysses/immobile/"];
    NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString:url_string]];
    _json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSLog(@"json: %@", _json);
}

- (void)viewDidLayoutSubviews {
    [self.swipeableView loadViewsIfNeeded];
}
#pragma mark - Action

- (void)handleLeft:(UIBarButtonItem *)sender {
    [self.swipeableView swipeTopViewToLeft];
}

- (void)handleRight:(UIBarButtonItem *)sender {
    [self.swipeableView swipeTopViewToRight];
}

- (void)handleUp:(UIBarButtonItem *)sender {
    [self.swipeableView swipeTopViewToUp];
}

- (void)handleDown:(UIBarButtonItem *)sender {
    [self.swipeableView swipeTopViewToDown];
}

- (void)handleReload:(UIBarButtonItem *)sender {
    UIActionSheet *actionSheet =
        [[UIActionSheet alloc] initWithTitle:@"Load Cards"
                                    delegate:self
                           cancelButtonTitle:@"Cancel"
                      destructiveButtonTitle:nil
                           otherButtonTitles:@"Programmatically", @"From Xib", nil];
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    self.loadCardFromXib = buttonIndex == 1;
    self.colorIndex = 0;
    [self.swipeableView discardAllViews];
    [self.swipeableView loadViewsIfNeeded];
}

#pragma mark - ZLSwipeableViewDelegate

- (void)swipeableView:(ZLSwipeableView *)swipeableView
         didSwipeView:(UIView *)view
          inDirection:(ZLSwipeableViewDirection)direction {
    
    CardView *localView = view;
    NSLog(@"did swipe in direction: %zd -- %d", direction, localView.k);
    
    NSString *idHouse = [[_json valueForKey:@"items"][localView.k] valueForKey:@"_id"];
    
    [self sendingAnHTTPPOSTRequestOniOSWithHouse:idHouse withEvaluation:direction == 2 ? 1 : -1];
}

-(void)sendingAnHTTPPOSTRequestOniOSWithHouse: (NSString *)houseId withEvaluation: (int)evaluation{
    //Init the NSURLSession with a configuration
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    //Create an URLRequest
    NSURL *url = [NSURL URLWithString:@"https://mitinsightsbackend.herokuapp.com/api/ulysses/reaction"];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    //Create POST Params and add it to HTTPBody
    NSString *params = [NSString stringWithFormat:@"immobile=%@&evaluation=%d",houseId,evaluation];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    //Create task
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //Handle your response here
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",responseDict);
    }];
    [dataTask resume];
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView didCancelSwipe:(UIView *)view {
    view.backgroundColor = [UIColor darkGrayColor];

    NSLog(@"did cancel swipe");
}
- (IBAction)didPressSwipeRight:(id)sender {
    [self.swipeableView swipeTopViewToRight];

}
- (IBAction)didPressSwipeLeft:(id)sender {
    [self.swipeableView swipeTopViewToLeft];
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
  didStartSwipingView:(UIView *)view
           atLocation:(CGPoint)location {
    NSLog(@"did start swiping at location: x %f, y %f", location.x, location.y);
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
          swipingView:(UIView *)view
           atLocation:(CGPoint)location
          translation:(CGPoint)translation {
    NSLog(@"swiping at location: x %f, y %f, translation: x %f, y %f", location.x, location.y,
          translation.x, translation.y);
    if( translation.x > 0)
        view.backgroundColor = [UIColor greenColor];
    else
        view.backgroundColor = [UIColor redColor];

}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
    didEndSwipingView:(UIView *)view
           atLocation:(CGPoint)location {
    
    NSLog(@"did end swiping at location: x %f, y %f", location.x, location.y);
}
- (IBAction)didPressToViewDetail:(id)sender {
    
    UIView *topView = [self.swipeableView topView];
    if (!topView) {
        return;
    }
    [self performSegueWithIdentifier:@"details" sender:NULL];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier] isEqualToString:@"details"]){

        UIView *topView = [self.swipeableView topView];
        if (!topView) {
            return;
        }
        
        // Get reference to the destination view controller
        DetailsViewController *vc = [segue destinationViewController];
        
        CardView *localView = topView;

        vc.images = [[_json valueForKey:@"items"][localView.k] valueForKey:@"photos"];
        vc.textos = [[NSMutableArray alloc] init];
        
        vc.nb = [[[_json valueForKey:@"items"][self.colorIndex] valueForKey:@"address"] valueForKey:@"neighborhood"];
        vc.tm = [NSString stringWithFormat:@"%@ m²", [[_json valueForKey:@"items"][self.colorIndex] valueForKey:@"area"]];
        vc.drm =  [NSString stringWithFormat:@"%@ Quarto(s)", [[_json valueForKey:@"items"][self.colorIndex] valueForKey:@"rooms"]];
        
        vc.vgb = [NSString stringWithFormat:@"%@ Vaga(s)", [[_json valueForKey:@"items"][self.colorIndex] valueForKey:@"parkingSpaces"]];
        
        vc.dsc = [[_json valueForKey:@"items"][self.colorIndex] valueForKey:@"details"];
        
        
        if( (int) [[_json valueForKey:@"items"][localView.k] valueForKey:@"fitness"] == 1){
            [vc.textos addObject:@"Academia"];
        }
        
        if( (int) [[_json valueForKey:@"items"][localView.k] valueForKey:@"pools"] >= 1){
            [vc.textos addObject:@"Piscina"];
        }
        
        if( (int) [[_json valueForKey:@"items"][localView.k] valueForKey:@"suites"] >= 1){
            [vc.textos addObject:@"Suite" ];
        }
        
        [vc.textos addObject: [NSString stringWithFormat:@"R$%@", [[_json valueForKey:@"items"][localView.k] valueForKey:@"price"]]];
        NSLog(@"Terminei %d", [vc.textos count]);

    }
}
- (IBAction)didPressToGetInfo:(id)sender {
    UIView *topView = [self.swipeableView topView];
    if (!topView) {
        return;
    }
    [self performSegueWithIdentifier:@"details" sender:NULL];

}

#pragma mark - ZLSwipeableViewDataSource

- (UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView {
    if (_json == NULL || self.colorIndex >= (int) [[_json valueForKey:@"items"] count] ) {
        return NULL;
    }

    CardView *view = [[CardView alloc] initWithFrame:swipeableView.bounds];
    view.backgroundColor = [UIColor darkGrayColor];
    
    view.k = self.colorIndex;
    
    NSLog(@"%d", self.colorIndex);
    
    
//    if (self.loadCardFromXib) {
        CardContentView *contentView =
            [[NSBundle mainBundle] loadNibNamed:@"CardContentView" owner:self options:nil][0];
        contentView.translatesAutoresizingMaskIntoConstraints = NO;
        [view addSubview:contentView];
    
    contentView.addressLabel.text = [[[_json valueForKey:@"items"][self.colorIndex] valueForKey:@"address"] valueForKey:@"neighborhood"];
    
    contentView.sizeLabel.text = [NSString stringWithFormat:@"%@ m²", [[_json valueForKey:@"items"][self.colorIndex] valueForKey:@"area"]];
    
    
    contentView.bedroomsLabel.text = [NSString stringWithFormat:@"%@", [[_json valueForKey:@"items"][self.colorIndex] valueForKey:@"rooms"]];

    
    contentView.parkingLabel.text = [NSString stringWithFormat:@"%@", [[_json valueForKey:@"items"][self.colorIndex] valueForKey:@"rooms"]];
    
    contentView.priceLabel.text = [NSString stringWithFormat:@"R$%@", [[_json valueForKey:@"items"][self.colorIndex] valueForKey:@"price"]];

    contentView.images = [[_json valueForKey:@"items"][self.colorIndex] valueForKey:@"photos"];
    
        // This is important:
        // https://github.com/zhxnlai/ZLSwipeableView/issues/9
        NSDictionary *metrics =
            @{ @"height" : @(view.bounds.size.height),
               @"width" : @(view.bounds.size.width) };
        NSDictionary *views = NSDictionaryOfVariableBindings(contentView);
        [view addConstraints:[NSLayoutConstraint
                                 constraintsWithVisualFormat:@"H:|[contentView(width)]"
                                                     options:0
                                                     metrics:metrics
                                                       views:views]];
        [view addConstraints:[NSLayoutConstraint
                                 constraintsWithVisualFormat:@"V:|[contentView(height)]"
                                                     options:0
                                                     metrics:metrics
                                                       views:views]];
//    }
    self.colorIndex++;

    return view;
}

#pragma mark - ()

- (UIColor *)colorForName:(NSString *)name {
    NSString *sanitizedName = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *selectorString = [NSString stringWithFormat:@"flat%@Color", sanitizedName];
    Class colorClass = [UIColor class];
    return [colorClass performSelector:NSSelectorFromString(selectorString)];
}

@end
