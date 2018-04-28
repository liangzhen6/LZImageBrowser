//
//  LZImageBrowserMainView.m
//  LZImageDetail
//
//  Created by shenzhenshihua on 2018/4/28.
//  Copyright © 2018年 shenzhenshihua. All rights reserved.
//

#import "LZImageBrowserMainView.h"
#import "LZImageBrowserHeader.h"
#import "LZImageBrowserModel.h"
#import "LZImageBrowserSubView.h"

@interface LZImageBrowserMainView ()<UIScrollViewDelegate,LZImageBrowserSubViewDelegate>
@property(nonatomic,strong)UIScrollView * mainScrollView;
@property(nonatomic,strong)UIPageControl * pageControl;
@property(nonatomic,strong)NSMutableArray * dataSource;
@property(nonatomic,copy)NSArray * imageUrls;
@property(nonatomic,copy)NSArray * originImageViews;
@property(nonatomic,assign)NSInteger selectPage;

@end

@implementation LZImageBrowserMainView

+ (id)imageBrowserMainViewUrlStr:(NSArray<NSString *>*)imageUrls originImageViews:(NSArray<UIImageView *>*)originImageViews selectPage:(NSInteger)selectPage {
    LZImageBrowserMainView * imageBrowserMainView = [[LZImageBrowserMainView alloc] initWithFrame:Screen_Frame];
    imageBrowserMainView.imageUrls = imageUrls;
    imageBrowserMainView.originImageViews = originImageViews;
    imageBrowserMainView.selectPage = selectPage;
    [imageBrowserMainView initData];
    [imageBrowserMainView initView];
    return imageBrowserMainView;
}

- (void)initData {
    for (NSInteger i = 0; i < self.imageUrls.count; i++) {
        NSString * urlStr = self.imageUrls[i];
        UIImageView * imageView = self.originImageViews[i];
        LZImageBrowserModel * imageBrowserModel = [[LZImageBrowserModel alloc] init];
        imageBrowserModel.smallImageView = imageView;
        imageBrowserModel.urlStr = urlStr;
        [self.dataSource addObject:imageBrowserModel];
    }
}

- (void)initView {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1.0];
    //1.初始化 mianScrollView
    [self addSubview:self.mainScrollView];
    //加入子视图
    for (NSInteger i = 0; i < self.dataSource.count; i++) {
        LZImageBrowserSubView * imageBrowserSubView = [[LZImageBrowserSubView alloc] initWithFrame:CGRectMake((Screen_Width + SpaceWidth)*i, 0, Screen_Width, Screen_Height) ImageBrowserModel:self.dataSource[i]];
        imageBrowserSubView.deleagte = self;
        [self.mainScrollView addSubview:imageBrowserSubView];
    }
    [self.mainScrollView setContentSize:CGSizeMake((Screen_Width + SpaceWidth)*self.dataSource.count, 0)];
    [self.mainScrollView setContentOffset:CGPointMake((Screen_Width + SpaceWidth)*_selectPage, 0)];
    //2.设置 pagecontel
    [self addSubview:self.pageControl];
    self.pageControl.numberOfPages = self.dataSource.count;
    CGSize size = [self.pageControl sizeForNumberOfPages:self.dataSource.count];
    self.pageControl.frame = CGRectMake(Screen_Width/2-size.width/2, Screen_Height-size.height-20, size.width, size.height);
    self.pageControl.currentPage = _selectPage;
    
    self.mainScrollView.hidden = YES;
    self.pageControl.hidden = YES;
}

- (void)showImageBrowserMainView {
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
    
    LZImageBrowserModel * currentModel = self.dataSource[_selectPage];
    CGRect frame = [currentModel smallImageViewframeOriginWindow];
    UIImage * image = [currentModel getCurrentImage];
    UIImageView * imageView = [self addShadowImageViewWithFrame:frame image:image];
    
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame = [currentModel imageViewframeShowWindow];
    } completion:^(BOOL finished) {
        self.mainScrollView.hidden = NO;
        self.pageControl.hidden = NO;
        [imageView removeFromSuperview];
    }];
}

- (void)dismissImageBrowserMainView {
    
    LZImageBrowserModel * currentModel = self.dataSource[_selectPage];
    CGRect frame = [currentModel bigImageViewFrameOnScrollView];
    UIImage * image = [currentModel getCurrentImage];
    UIImageView * imageView = [self addShadowImageViewWithFrame:frame image:image];

    self.mainScrollView.hidden = YES;
    self.pageControl.hidden = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame = [currentModel smallImageViewframeOriginWindow];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    } completion:^(BOOL finished) {
        [imageView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (UIImageView *)addShadowImageViewWithFrame:(CGRect)frame image:(UIImage *)image {
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.image = image;
    [self addSubview:imageView];
    return imageView;
}

#pragma mark -LZImageBrowserSubViewDelegate
- (void)imageBrowserSubViewSingleTapWithModel:(LZImageBrowserModel *)imageBrowserModel {
    [self dismissImageBrowserMainView];
}

- (void)imageBrowserSubViewTouchMoveChangeMainViewAlpha:(CGFloat)alpha {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:alpha];
}


#pragma mark -scrollView delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat currentX = scrollView.contentOffset.x;
    NSInteger currentPage = currentX / (Screen_Width + SpaceWidth);
    _selectPage = currentPage;
    [self.pageControl setCurrentPage:currentPage];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat currentX = scrollView.contentOffset.x;
    NSInteger currentPage = currentX / (Screen_Width + SpaceWidth);
    [self.pageControl setCurrentPage:currentPage];
}

#pragma mark  -lazy
- (UIScrollView *)mainScrollView {
    if (_mainScrollView == nil) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width + SpaceWidth, Screen_Height)];
        _mainScrollView.delegate = self;
        _mainScrollView.backgroundColor = [UIColor clearColor];
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _mainScrollView;
}

- (UIPageControl *)pageControl {
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] init];
        //如果只有一页就隐藏
        _pageControl.hidesForSinglePage = YES;
        //设置page的颜色
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        //设置当前page的颜色
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    }
    return _pageControl;
}

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
