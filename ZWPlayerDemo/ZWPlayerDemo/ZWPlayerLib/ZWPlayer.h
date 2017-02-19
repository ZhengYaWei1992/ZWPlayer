//
//  ZWPlayer.h
//  ZWPlayerDemo
//
//  Created by 郑亚伟 on 2017/2/9.
//  Copyright © 2017年 zhengyawei. All rights reserved.
//

#ifndef ZWPlayer_h
#define ZWPlayer_h


#define iPhone4s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
// 监听TableView的contentOffset
#define kZWPlayerViewContentOffset          @"contentOffset"
// player的单例
//#define ZFPlayerShared                      [ZFBrightnessView sharedBrightnessView]
// 屏幕的宽
#define ScreenWidth                         [[UIScreen mainScreen] bounds].size.width
// 屏幕的高
#define ScreenHeight                        [[UIScreen mainScreen] bounds].size.height
// 颜色值RGB
#define RGBA(r,g,b,a)                       [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
// 图片路径
#define ZWPlayerSrcName(file)               [@"ZWPlayer.bundle" stringByAppendingPathComponent:file]

#import "Masonry.h"
#import "ZWPlayerView.h"
#import "ZWPlayerControlView.h"

#endif /* ZWPlayer_h */
