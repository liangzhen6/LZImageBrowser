//
//  LZImageBrowserManger.h
//  LZImageDetail
//
//  Created by shenzhenshihua on 2018/7/16.
//  Copyright © 2018年 shenzhenshihua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LZImageBrowserManger : NSObject
@property(nonatomic,assign)NSInteger selectPage; ///< 选中哪一个imageView

/**
 初始化 Manger

 @param imageUrls 各个图片大图的url
 @param originImageViews 原始的小图
 @param controller 小图所有的视图控制器
 @param forceTouchCapability 是否开启3Dtouch
 @return manger
 */
+ (id)imageBrowserMangerWithUrlStr:(NSArray<NSString *>*)imageUrls originImageViews:(NSArray<UIImageView *>*)originImageViews originController:(UIViewController *)controller forceTouch:(BOOL)forceTouchCapability;

/**
 用户点击小图，进入图片查看大图。
 */
- (void)showImageBrowser;

@end
