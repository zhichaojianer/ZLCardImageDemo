//
//  ZLCardScrollView.m
//  Cicada
//
//  Created by liuchao on 16/6/14.
//  Copyright © 2016年 thinkjoy. All rights reserved.
//

#import "ZLCardScrollView.h"
#import "UIView+Common.h"
#import "ZLCardView.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define zlCardMaxCount      3     //卡片数量
#define zlHorizontalSpacing 20.0f //左右间距
#define zlVerticalSpacting  20.0f //上下间距
#define zlCardSpacting      20.0    //卡片距离

#define zlCGAffineTransformMakeScale(i) CGAffineTransformMakeScale(1-(i > zlCardMaxCount?zlCardMaxCount:i)*0.05, 1-(i > zlCardMaxCount?zlCardMaxCount:i)*0.05)
#define zlCGAffineTransformTranslate(i) CGAffineTransformTranslate(zlCardView.transform, 0, (i > zlCardMaxCount?zlCardMaxCount:i)*zlCardSpacting)

@interface ZLCardScrollView()

@property (assign, nonatomic) NSInteger zlCardCount;
@property (assign, nonatomic) NSInteger zlLastCardIndex;

@property (strong, nonatomic) NSMutableArray *zlCardViewArray;

@end


@implementation ZLCardScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentSize = CGSizeMake(self.width, self.height);
        
        //左滑手势
        UISwipeGestureRecognizer *zlSwipLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(zlMoveCardSwip:)];
        [zlSwipLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
        [self addGestureRecognizer:zlSwipLeft];
        
        //右滑手势
        UISwipeGestureRecognizer *zlSwipRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(zlMoveCardSwip:)];
        [zlSwipRight setDirection:UISwipeGestureRecognizerDirectionRight];
        [self addGestureRecognizer:zlSwipRight];
    }
    return self;
}

- (void)setZlCardImageArray:(NSMutableArray *)zlCardImageArray
{
    _zlCardImageArray = zlCardImageArray;
    
    self.zlLastCardIndex = 0;
    
    if (self.zlCardViewArray == nil) {
        
        self.zlCardViewArray = [[NSMutableArray alloc] initWithCapacity:3];
        NSInteger cardCount = self.zlCardImageArray.count>zlCardMaxCount?zlCardMaxCount:self.zlCardImageArray.count;
        self.zlCardCount = cardCount;
        
        for (int i = 0; i < cardCount; i++) {
            CGFloat zlCardViewX = (self.width - (self.width - zlHorizontalSpacing * 2))/2;
            CGFloat zlCardViewY = (self.height - (self.height - zlVerticalSpacting * 2))/2 - zlCardSpacting/self.zlCardCount;
            CGFloat zlCardViewWidth = (self.width - zlHorizontalSpacing * 2);
            CGFloat zlCardViewHeight = (self.height - zlVerticalSpacting * 2);

            ZLCardView *zlCardView = [[ZLCardView alloc] initWithFrame:CGRectMake(zlCardViewX, zlCardViewY, zlCardViewWidth, zlCardViewHeight)];
            [self insertSubview:zlCardView atIndex:0];
            
            zlCardView.transform = zlCGAffineTransformMakeScale(i);
            zlCardView.transform = zlCGAffineTransformTranslate(i);
            
            [self.zlCardViewArray addObject:zlCardView];
        }
    }
    
    for (int i = 0; i < self.zlCardViewArray.count; i++) {
        self.zlLastCardIndex = i;
        ZLCardView *zlCardView = self.zlCardViewArray[i];
        NSString *imageUrlStr = [NSString stringWithFormat:@"%@",zlCardImageArray[i]];
        [zlCardView.zlImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlStr]];
        [zlCardView setNeedsLayout];
    }
}

- (void)zlMoveCardSwip:(UISwipeGestureRecognizer *) swip {
    
    if (self.zlCardImageArray.count == 1) {
        return;
    }
    
    if (swip.direction == UISwipeGestureRecognizerDirectionLeft) {
        CGPoint endPoint = CGPointMake(-20, 0);
        [self resetCurrentCardView:endPoint];
    }else if (swip.direction == UISwipeGestureRecognizerDirectionRight) {
        CGPoint endPoint = CGPointMake(20, 0);
        [self resetCurrentCardView:endPoint];
    }
}

//将当前卡片调整到末尾
- (void)resetCurrentCardView:(CGPoint) endPoint {
    __weak __typeof(&*self)weakSelf_SC = self;
    [self resetCurrentCardView:(endPoint.x>0?self.width:-self.width) completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.3 animations:^{
            [weakSelf_SC changeFirstCard:^(BOOL finished) {
                [weakSelf_SC setLasetCardView];
            }];
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (void)resetCurrentCardView:(float)left completion:(void (^ __nullable)(BOOL finished))completion
{
    ZLCardView *zlCardView = self.zlCardViewArray[0];
    
    __weak __typeof(&*self)weakSelf_SC = self;
    [UIView animateWithDuration:0.3 animations:^{
        zlCardView.left = left;
    } completion:^(BOOL finished) {
        zlCardView.alpha = 0;
        zlCardView.left = (self.width - (self.width - zlHorizontalSpacing * 2))/2;
        [weakSelf_SC.zlCardViewArray removeObject:zlCardView];
        [weakSelf_SC.zlCardViewArray addObject:zlCardView];
        [zlCardView removeFromSuperview];
        [weakSelf_SC insertSubview:zlCardView atIndex:0];
        completion(finished);
    }];
    
    //设置最后一张卡片的数据
    self.zlLastCardIndex = (self.zlCardImageArray.count-1) > self.zlLastCardIndex ? self.zlLastCardIndex+1 : 0;
    NSString *imageUrlStr = [NSString stringWithFormat:@"%@",self.zlCardImageArray[self.zlLastCardIndex]];
    [zlCardView.zlImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlStr]];
    [zlCardView setNeedsLayout];
}

//设置最后一张卡片的属性
-(void)setLasetCardView {
    UIView *zlCardView = [self.zlCardViewArray lastObject];
    [UIView animateWithDuration:0.3 animations:^{
        zlCardView.alpha = 1;
    }];
}

//变更第一张卡片
- (void)changeFirstCard:(void (^ __nullable)(BOOL finished))completion {
    for (int i = 0; i < self.zlCardViewArray.count; i++) {
        UIView *zlCardView = self.zlCardViewArray[i];
        if (zlCardView) {
            [UIView animateWithDuration:0.3 animations:^{
                zlCardView.transform = zlCGAffineTransformMakeScale(i);
                zlCardView.transform = zlCGAffineTransformTranslate(i);
            } completion:completion];
        }
    }
}

@end
