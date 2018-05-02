//
//  LZImageBrowserMainView.h
//  LZImageDetail
//
//  Created by shenzhenshihua on 2018/4/28.
//  Copyright © 2018年 shenzhenshihua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZImageBrowserMainView : UIView

/**
 初始化主视图

 @param imageUrls 大图的下载地址
 @param originImageViews 原始的小图的 iamgeView
 @param selectPage 当前选中的是哪一个iamgeView
 @return 主视图
 */
+ (id)imageBrowserMainViewUrlStr:(NSArray<NSString *>*)imageUrls originImageViews:(NSArray<UIImageView *>*)originImageViews selectPage:(NSInteger)selectPage;

/**
 展示主视图的方法
 */
- (void)showImageBrowserMainView;

/**
 移除主视图的方法
 */
- (void)dismissImageBrowserMainView;

@end
