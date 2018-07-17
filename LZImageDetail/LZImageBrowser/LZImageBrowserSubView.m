//
//  LZImageBrowserSubView.m
//  LZImageDetail
//
//  Created by shenzhenshihua on 2018/4/28.
//  Copyright © 2018年 shenzhenshihua. All rights reserved.
//

#import "LZImageBrowserSubView.h"
#import "LZImageBrowserModel.h"
#import "LZImageBrowserHeader.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface LZImageBrowserSubView ()<UIScrollViewDelegate>
@property(nonatomic,strong)LZImageBrowserModel * imageBrowserModel;
@property(nonatomic,strong)UIScrollView * subScrollView;
@property(nonatomic,strong)UIImageView * subImageView;
@property(nonatomic,assign)NSInteger touchFingerNumber;

@end

@implementation LZImageBrowserSubView

- (id)initWithFrame:(CGRect)frame ImageBrowserModel:(LZImageBrowserModel *)imageBrowserModel {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageBrowserModel = imageBrowserModel;
        [self initView];
    }
    return self;
}
- (void)initView {
    [self addSubview:self.subScrollView];
    [self.subScrollView addSubview:self.subImageView];
    //加入 点击事件 单击 与 双击
    UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
    [self addGestureRecognizer:singleTap];
    UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
    doubleTap.numberOfTapsRequired = 2;
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [self addGestureRecognizer:doubleTap];
    
    _imageBrowserModel.bigScrollView = self.subScrollView;
    _imageBrowserModel.bigImageView = self.subImageView;
    __weak typeof (self)ws = self;
    [self.subImageView sd_setImageWithURL:[NSURL URLWithString:_imageBrowserModel.urlStr] placeholderImage:_imageBrowserModel.smallImageView.image completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (!error) {
            [ws updateSubScrollViewSubImageView];
        }
    }];
    [self updateSubScrollViewSubImageView];
}

//单击 退出
- (void)singleTapAction:(UITapGestureRecognizer *)singleTap {
    if ([self.delegate respondsToSelector:@selector(imageBrowserSubViewSingleTapWithModel:)]) {
        [self.delegate imageBrowserSubViewSingleTapWithModel:_imageBrowserModel];
    }
}

//双击 局部放大 或者 变成正常大小
- (void)doubleTapAction:(UITapGestureRecognizer *)doubleTap {
    if (self.subScrollView.zoomScale > 1.0) {
        //已经放大过了 就变成正常大小
        [self.subScrollView setZoomScale:1.0 animated:YES];
    } else {
        //如果是正常大小 就 局部放大
        CGPoint touchPoint = [doubleTap locationInView:self.subImageView];
        CGFloat maxZoomScale = self.subScrollView.maximumZoomScale;
        CGFloat width = self.frame.size.width / maxZoomScale;
        CGFloat height = self.frame.size.height / maxZoomScale;
        [self.subScrollView zoomToRect:CGRectMake(touchPoint.x - width/2, touchPoint.y = height/2, width, height) animated:YES];
    }
}


- (void)updateSubScrollViewSubImageView {
    [self.subScrollView setZoomScale:1.0 animated:NO];
    
    CGFloat imageW = _imageBrowserModel.bigImageSize.width;
    CGFloat imageH = _imageBrowserModel.bigImageSize.height;
    CGFloat height =  Screen_Width * imageH/imageW;

    if (imageH/imageW > Screen_Height/Screen_Width) {
        //长图
        self.subImageView.frame =CGRectMake(0, 0, Screen_Width, height);
    } else {
        self.subImageView.frame =CGRectMake(0, Screen_Height/2 - height/2, Screen_Width, height);
    }
    self.subScrollView.contentSize = CGSizeMake(Screen_Width, height);
}

#pragma mark -scrollView delegate
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.subImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.frame.size.width > scrollView.contentSize.width) ? (scrollView.frame.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.frame.size.height > scrollView.contentSize.height) ? (scrollView.frame.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.subImageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    UIPanGestureRecognizer * subScrollViewPan = [scrollView panGestureRecognizer];
    _touchFingerNumber = subScrollViewPan.numberOfTouches;
    _subScrollView.clipsToBounds = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    //只有是一根手指事件才做出响应。
    if (contentOffsetY < 0 && _touchFingerNumber == 1) {
        [self changeSizeCenterY:contentOffsetY];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    if ((contentOffsetY<0 && _touchFingerNumber==1) && (velocity.y<0 && fabs(velocity.y)>fabs(velocity.x))) {
        //如果是向下滑动才触发消失的操作。
        if ([self.delegate respondsToSelector:@selector(imageBrowserSubViewSingleTapWithModel:)]) {
            [self.delegate imageBrowserSubViewSingleTapWithModel:_imageBrowserModel];
        }
    } else {
        [self changeSizeCenterY:0.0];
        CGFloat offsetX = (scrollView.frame.size.width > scrollView.contentSize.width) ? (scrollView.frame.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
        CGFloat offsetY = (scrollView.frame.size.height > scrollView.contentSize.height) ? (scrollView.frame.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
        self.subImageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
    }
    _touchFingerNumber = 0;
    self.subScrollView.clipsToBounds = YES;
}

- (void)changeSizeCenterY:(CGFloat)contentOffsetY {
    //contentOffsetY 为负值
    CGFloat multiple = (Screen_Height + contentOffsetY*1.75)/Screen_Height;
    if ([self.delegate respondsToSelector:@selector(imageBrowserSubViewTouchMoveChangeMainViewAlpha:)]) {
        [self.delegate imageBrowserSubViewTouchMoveChangeMainViewAlpha:multiple];
    }
    multiple = multiple>0.4?multiple:0.4;
    self.subScrollView.transform = CGAffineTransformMakeScale(multiple, multiple);
    self.subScrollView.center = CGPointMake(Screen_Width/2, Screen_Height/2 - contentOffsetY*0.5);
}

#pragma mark -lazy
- (UIScrollView *)subScrollView {
    if (_subScrollView == nil) {
        _subScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
        _subScrollView.delegate = self;
        _subScrollView.bouncesZoom = YES;
        _subScrollView.maximumZoomScale = 2.5;//最大放大倍数
        _subScrollView.minimumZoomScale = 1.0;//最小缩小倍数
        _subScrollView.multipleTouchEnabled = YES;
        _subScrollView.scrollsToTop = NO;
        _subScrollView.contentSize = CGSizeMake(Screen_Width, Screen_Height);
        _subScrollView.userInteractionEnabled = YES;
        _subScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _subScrollView.delaysContentTouches = NO;//默认yes  设置NO则无论手指移动的多么快，始终都会将触摸事件传递给内部控件；
        _subScrollView.canCancelContentTouches = NO; // 默认是yes
        _subScrollView.alwaysBounceVertical = YES;//设置上下回弹
        _subScrollView.showsVerticalScrollIndicator = NO;
        _subScrollView.showsHorizontalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            //表示只在ios11以上的版本执行
            _subScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _subScrollView;
}
- (UIImageView *)subImageView {
    if (_subImageView == nil) {
        _subImageView = [[UIImageView alloc] init];
        _subImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _subImageView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
