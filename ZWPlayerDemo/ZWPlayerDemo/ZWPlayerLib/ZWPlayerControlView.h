//
//  ZWPlayerControlView.h
//  ZWPlayerDemo
//
//  Created by 郑亚伟 on 2017/2/9.
//  Copyright © 2017年 zhengyawei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SliderTapBlock)(CGFloat value);

@interface ZWPlayerControlView : UIView

/** 左下角的开始播放按钮 */
@property (nonatomic, strong, readonly) UIButton                *startBtn;
/** 当前播放时长label */
@property (nonatomic, strong, readonly) UILabel                 *currentTimeLabel;
/** 视频总时长label */
@property (nonatomic, strong, readonly) UILabel                 *totalTimeLabel;
/** 缓冲进度条 */
@property (nonatomic, strong, readonly) UIProgressView          *progressView;
/** 滑杆 */
@property (nonatomic, strong, readonly) UISlider                *videoSlider;
/** 全屏按钮 */
@property (nonatomic, strong, readonly) UIButton                *fullScreenBtn;

/** 快进快退label */
@property (nonatomic, strong, readonly) UILabel                 *horizontalLabel;
/** 系统菊花 */
@property (nonatomic, strong, readonly) UIActivityIndicatorView *activity;

/** 返回按钮*/
@property (nonatomic, strong, readonly) UIButton                *backBtn;
/** 重播按钮 */
@property (nonatomic, strong, readonly) UIButton                *repeatBtn;
/** bottomView*/
@property (nonatomic, strong, readonly) UIImageView             *bottomImageView;
/** topView */
@property (nonatomic, strong, readonly) UIImageView             *topImageView;

/** 中间的播放按钮 */
@property (nonatomic, strong, readonly) UIButton                *playeBtn;

/** slidertap事件Block */
@property (nonatomic, copy  ) SliderTapBlock                    tapBlock;

/** 重置ControlView */
- (void)resetControlView;
/** 显示top、bottom*/
- (void)showControlView;
/** 隐藏top、bottom*/
- (void)hideControlView;

@end
