//
//  ZLCardView.m
//  Cicada
//
//  Created by liuchao on 16/6/14.
//  Copyright © 2016年 thinkjoy. All rights reserved.
//

#import "ZLCardView.h"

@implementation ZLCardView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //设置圆角、边框及背景色
        self.layer.cornerRadius = 2;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = [UIColor colorWithRed:155/255.0 green:155/255.0 blue:155/255.0 alpha:1].CGColor;
        self.layer.borderWidth = 0.5;        
        self.backgroundColor = [UIColor whiteColor];
        
        self.zlImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, frame.size.width-5*2, frame.size.height-5*2)];
        self.zlImageView.backgroundColor = [UIColor blackColor];
//        self.zlImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.zlImageView];
    }
    
    return self;
}

@end
