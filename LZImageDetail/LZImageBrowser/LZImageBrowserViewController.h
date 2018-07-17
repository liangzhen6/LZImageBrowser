//
//  LZImageBrowserViewController.h
//  LZImageDetail
//
//  Created by shenzhenshihua on 2018/7/16.
//  Copyright © 2018年 shenzhenshihua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZImageBrowserViewController : UIViewController

/**
 初始化查看大图的controller

 @param imageUrls 所有大图的数组
 @param originImageViews 所有小图原始的imageView数组
 @param selectPage 选中的是第几个
 @return 大图的controller
 */
- (id)initWithUrlStr:(NSArray<NSString *>*)imageUrls originImageViews:(NSArray<UIImageView *>*)originImageViews selectPage:(NSInteger)selectPage;

@end
