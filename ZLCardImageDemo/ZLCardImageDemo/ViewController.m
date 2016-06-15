//
//  ViewController.m
//  ZLCardImageDemo
//
//  Created by liuchao on 16/6/15.
//  Copyright © 2016年 LiuChao. All rights reserved.
//

#import "ViewController.h"
#import "ZLCardScrollView.h"
#import "ZLSwipeableView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ViewController ()<ZLSwipeableViewDataSource, ZLSwipeableViewDelegate>

@property (weak, nonatomic) IBOutlet ZLSwipeableView *swipeableView;

@property (nonatomic, strong) NSMutableArray *swipeableArray;

@property (nonatomic) NSUInteger flagIndex;
@property (nonatomic) NSUInteger swipeableIndex;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor greenColor];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 15*2;
    CGFloat height = width*3/4.0;
    
    ZLCardScrollView *zlCardScrollView  = [[ZLCardScrollView alloc] initWithFrame:CGRectMake(15, 30, width, height)];
    zlCardScrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:zlCardScrollView];
    
    NSMutableArray *zlCardImages = [NSMutableArray arrayWithCapacity:0];
    [zlCardImages addObject:@"http://pic1.nipic.com/2008-12-25/2008122510134038_2.jpg"];
    [zlCardImages addObject:@"http://img1.3lian.com/2015/w7/98/d/22.jpg"];
    [zlCardImages addObject:@"http://pic9.nipic.com/20100904/4845745_195609329636_2.jpg"];
    [zlCardImages addObject:@"http://pic1.nipic.com/2008-12-09/200812910493588_2.jpg"];
    [zlCardImages addObject:@"http://img.61gequ.com/allimg/2011-4/201142614314278502.jpg"];
    [zlCardScrollView setZlCardImageArray:zlCardImages];
    
    
    [self.swipeableView setNeedsLayout];
    [self.swipeableView layoutIfNeeded];
    
    self.swipeableView.dataSource = self;
    self.swipeableView.delegate = self;
    
    self.flagIndex = 0;
    self.swipeableIndex = 0;
    self.swipeableArray = [NSMutableArray arrayWithArray:zlCardImages];
    [self.swipeableView discardAllSwipeableViews];
    [self.swipeableView loadNextSwipeableViewsIfNeeded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark ZLSwipeableViewDelegate

- (void)swipeableView: (ZLSwipeableView *)swipeableView didSwipeLeft:(UIView *)view {
    self.flagIndex--;
    if (self.flagIndex < 1) {
        self.swipeableIndex = 0;
        [self.swipeableView discardAllSwipeableViews];
        [self.swipeableView loadNextSwipeableViewsIfNeeded];
    }
}
- (void)swipeableView: (ZLSwipeableView *)swipeableView didSwipeRight:(UIView *)view {
    self.flagIndex--;
    if (self.flagIndex < 1 ) {
        self.swipeableIndex = 0;
        [self.swipeableView discardAllSwipeableViews];
        [self.swipeableView loadNextSwipeableViewsIfNeeded];
    }
}

#pragma mark -
#pragma mark ZLSwipeableViewDataSource

- (UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView {
    if (self.swipeableIndex < self.swipeableArray.count) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width-16-20, (width-16)*3/4-20)];
        
        UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:view.frame];
        [bgImageView setImage:[UIImage imageNamed:@"baby_bg_image"]];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 7, bgImageView.frame.size.width-16, bgImageView.frame.size.height-17)];
        [imageView setBackgroundColor:[UIColor blackColor]];
        NSURL *imageUrl = [NSURL URLWithString:self.swipeableArray[self.swipeableIndex]];
        [imageView sd_setImageWithURL:imageUrl];
//        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        
        [bgImageView addSubview:imageView];
        
        [view addSubview:bgImageView];
        
        self.swipeableIndex++;
        self.flagIndex++;
        
        return view;
    }
    return nil;
}

@end
