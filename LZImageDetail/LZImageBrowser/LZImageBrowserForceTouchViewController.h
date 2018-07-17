//
//  LZImageBrowserForceTouchViewController.h
//  LZImageDetail
//
//  Created by shenzhenshihua on 2018/7/17.
//  Copyright © 2018年 shenzhenshihua. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ForceTouchActionBlock)(NSInteger selectIndex, NSString *title);

@interface LZImageBrowserForceTouchViewController : UIViewController
@property(nonatomic,strong)UIImage *showOriginForceImage;
@property(nonatomic,copy)NSString *showForceImageUrl;
@property(nonatomic,copy)NSArray * previewActionTitls;
@property(nonatomic,copy)ForceTouchActionBlock forceTouchActionBlock;

@end
