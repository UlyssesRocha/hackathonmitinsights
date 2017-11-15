//
//  CardContentView.m
//  ZLSwipeableViewDemo
//
//  Created by Ulysses Rocha on 15/11/17.
//  Copyright © 2017 Zhixuan Lai. All rights reserved.
//

#import "CardContentView.h"
#import "KIImagePager.h"

@interface CardContentView() <KIImagePagerDelegate, KIImagePagerDataSource>
@property (weak, nonatomic) IBOutlet KIImagePager *imagePager;

@end
@implementation CardContentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    [super awakeFromNib];
    _imagePager.captionBackgroundColor = [UIColor clearColor];
    _imagePager.pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
    _imagePager.pageControl.pageIndicatorTintColor = [UIColor blackColor];
    _imagePager.slideshowTimeInterval = 4.5f;
    _imagePager.slideshowShouldCallScrollToDelegate = YES;
    
}

#pragma mark - KIImagePager DataSource
- (NSArray *) arrayWithImages:(KIImagePager*)pager
{
    return _images;
}

- (UIViewContentMode) contentModeForImage:(NSUInteger)image inPager:(KIImagePager *)pager
{
    return UIViewContentModeScaleAspectFill;
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
