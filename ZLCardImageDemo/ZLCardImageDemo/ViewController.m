//
//  ViewController.m
//  ZLCardImageDemo
//
//  Created by liuchao on 16/6/15.
//  Copyright © 2016年 LiuChao. All rights reserved.
//

#import "ViewController.h"
#import "ZLCardScrollView.h"

@interface ViewController ()

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
