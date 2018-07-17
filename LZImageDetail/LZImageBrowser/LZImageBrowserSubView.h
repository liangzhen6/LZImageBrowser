//
//  LZImageBrowserSubView.h
//  LZImageDetail
//
//  Created by shenzhenshihua on 2018/4/28.
//  Copyright © 2018年 shenzhenshihua. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LZImageBrowserModel;

@protocol LZImageBrowserSubViewDelegate <NSObject>
/* 单击 后的操作 */
- (void)imageBrowserSubViewSingleTapWithModel:(LZImageBrowserModel *)imageBrowserModel;
/* 改变主视图 的 透明度 */
- (void)imageBrowserSubViewTouchMoveChangeMainViewAlpha:(CGFloat)alpha;

@end

@interface LZImageBrowserSubView : UIView

@property(nonatomic,weak)id<LZImageBrowserSubViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame ImageBrowserModel:(LZImageBrowserModel *)imageBrowserModel;

@end
