//
//  LZImageBrowserTranslation.m
//  LZImageDetail
//
//  Created by shenzhenshihua on 2018/7/16.
//  Copyright © 2018年 shenzhenshihua. All rights reserved.
//

#import "LZImageBrowserTranslation.h"
#import "LZImageBrowserMainView.h"
#import "LZImageBrowserModel.h"

@interface LZImageBrowserTranslation ()

@end

@implementation LZImageBrowserTranslation
/* 自定义转场动画 */
//动画时间
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}
//转场动画
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    NSMutableArray * dataM = [self.mainBrowserMainView dataSource];
    NSInteger currentIndex = [self.mainBrowserMainView selectPage];

    LZImageBrowserModel * currentModel = [dataM objectAtIndex:currentIndex];
    
    //转场过程中显示的view，所有动画控件都应该加在这上面
    UIView * containerView = [transitionContext containerView];
    //转场去往的控制器
    UIViewController * toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if (_isBrowserMainView) {
        //是进入
        [containerView addSubview:toViewController.view];
        
        CGRect frame = [currentModel smallImageViewframeOriginWindow];
        UIImage * image = [currentModel getCurrentImage];
        UIImageView * imageView = [self addShadowImageViewWithFrame:frame image:image];
        //隐藏子组件
        [self.mainBrowserMainView subViewHidden:YES];
        self.browserControllerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            imageView.frame = [currentModel imageViewframeShowWindow];
            self.browserControllerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1.0];
        } completion:^(BOOL finished) {
            if ([transitionContext transitionWasCancelled]) {
                [transitionContext completeTransition:NO];
            } else {
                [transitionContext completeTransition:YES];
                
                [self.mainBrowserMainView subViewHidden:NO];
                [imageView removeFromSuperview];
            }
        }];
    } else {
        //是离开
        CGRect frame = [currentModel bigImageViewFrameOnScrollView];
        UIImage * image = [currentModel getCurrentImage];
        UIImageView * imageView = [self addShadowImageViewWithFrame:frame image:image];
        
        [self.mainBrowserMainView subViewHidden:YES];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            imageView.frame = [currentModel smallImageViewframeOriginWindow];
            self.browserControllerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        } completion:^(BOOL finished) {
            if ([transitionContext transitionWasCancelled]) {
                [transitionContext completeTransition:NO];
            } else {
                [transitionContext completeTransition:YES];
                [imageView removeFromSuperview];
            }
        }];
    }
}

- (UIImageView *)addShadowImageViewWithFrame:(CGRect)frame image:(UIImage *)image {
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.image = image;
    [self.browserControllerView addSubview:imageView];
    return imageView;
}

@end
