//
//  LZImageBrowserModel.m
//  LZImageDetail
//
//  Created by shenzhenshihua on 2018/4/28.
//  Copyright © 2018年 shenzhenshihua. All rights reserved.
//

#import "LZImageBrowserModel.h"
#import <SDWebImage/SDImageCache.h>
#import "LZImageBrowserHeader.h"

@implementation LZImageBrowserModel

- (CGRect)smallImageViewframeOriginWindow {
    return [self.smallImageView convertRect:self.smallImageView.bounds toView:self.smallImageView.window];
}

- (CGSize)smallImageSize {
    return self.smallImageView.image.size;
}

- (CGSize)bigImageSize {
    return self.bigImageView.image.size;
}

- (BOOL)isCacheImageKey:(NSString *)key {
    if ([[SDImageCache sharedImageCache] imageFromCacheForKey:key]) {
        return YES;
    }
    return NO;
}

- (UIImage *)getCurrentImage {
    if ([self isCacheImageKey:self.urlStr]) {
        return [[SDImageCache sharedImageCache] imageFromCacheForKey:self.urlStr];
    } else {
        return _smallImageView.image;
    }
}

- (CGRect)imageViewframeShowWindow {
    CGFloat imageW = self.smallImageSize.width;
    CGFloat imageH = self.smallImageSize.height;
    CGRect frame;
    CGFloat H = Screen_Width * imageH/imageW;
    if (imageH/imageW > Screen_Height/Screen_Width) {
        //长图 指图片宽度方大为屏幕宽度时，高度超过屏幕高度
        frame = CGRectMake(0, 0, Screen_Width, H);
    } else {
        //非 长图
        frame = CGRectMake(0, Screen_Height/2 - H/2, Screen_Width, H);
    }
    return frame;
}

- (CGRect)bigImageViewFrameOnScrollView {
    CGRect scrollViewFrame = _bigScrollView.frame;
    CGFloat H = scrollViewFrame.size.width * self.bigImageSize.height/self.bigImageSize.width;
    CGPoint center = _bigScrollView.center;
    return CGRectMake(center.x - scrollViewFrame.size.width/2, center.y - H/2, scrollViewFrame.size.width, H);
}

@end
