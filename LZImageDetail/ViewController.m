//
//  ViewController.m
//  LZImageDetail
//
//  Created by shenzhenshihua on 2018/4/24.
//  Copyright © 2018年 shenzhenshihua. All rights reserved.
//

#import "ViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LZImageBrowserManger.h"
#import "LZImageBrowserHeader.h"

@interface ViewController ()
@property(nonatomic,strong)LZImageBrowserManger *imageBrowserManger;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)initView {
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:Screen_Frame];
    [self.view addSubview:scrollView];
    
    [scrollView setContentSize:CGSizeMake(0, 1200)];
    
    CGFloat W = (Screen_Width-20-10)/3;
#warning 有时候图片的链接地址会无效，更换为有效的链接地址即可
    NSArray * images = @[@"http://img01.cztv.com/201508/19/9008d57f59984e7b188ab69fbb458915.jpg",@"http://img2.100bt.com/upload/ttq/20140315/1394865797382_middle.jpeg",@"http://img.pconline.com.cn/images/upload/upc/tx/wallpaper/1301/23/c0/17652199_1358923371562.jpg",@"https://b-ssl.duitang.com/uploads/item/201508/25/20150825230502_2nPUC.thumb.700_0.jpeg"];
    NSInteger count = (images.count)%3?(images.count/3+1):images.count/3;
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(10, 200, Screen_Width-20, count*W + (count-1)*5)];
    [scrollView addSubview:backView];
    backView.backgroundColor = [UIColor grayColor];
    NSMutableArray * originImageViews = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < images.count; i++) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake((i%3)*(W+5), i/3*(W+5), W, W)];
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        [imageView sd_setImageWithURL:[NSURL URLWithString:images[i]]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [backView addSubview:imageView];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTouchAction:)];
        [imageView addGestureRecognizer:tap];
        [originImageViews addObject:imageView];
    }
    
#warning 有时候图片的链接地址会无效，更换为有效的链接地址即可
    NSArray * bigImages = @[@"http://img01.cztv.com/201508/19/9008d57f59984e7b188ab69fbb458915.jpg",@"http://img2.100bt.com/upload/ttq/20140315/1394865797382_middle.jpeg",@"http://img.pconline.com.cn/images/upload/upc/tx/wallpaper/1301/23/c0/17652199_1358923371562.jpg",@"https://b-ssl.duitang.com/uploads/item/201508/25/20150825230502_2nPUC.thumb.700_0.jpeg"];
    //初始化 manger
    LZImageBrowserManger *imageBrowserManger = [LZImageBrowserManger imageBrowserMangerWithUrlStr:bigImages originImageViews:originImageViews originController:self forceTouch:YES forceTouchActionTitles:@[@"赞", @"评论", @"收藏"] forceTouchActionComplete:^(NSInteger selectIndex, NSString *title) {
        NSLog(@"当前选中%ld--标题%@",(long)selectIndex, title);
    }];

    _imageBrowserManger = imageBrowserManger;
}

- (void)imageTouchAction:(UIGestureRecognizer *)ges {
    //点击了的某一个 imageView
    _imageBrowserManger.selectPage = ges.view.tag;
    [_imageBrowserManger showImageBrowser];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
