//
//  ZWPlayerView.h
//  ZWPlayerDemo
//
//  Created by 郑亚伟 on 2017/2/9.
//  Copyright © 2017年 zhengyawei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#import "ZWPlayer.h"
#import "ZWPlayerControlView.h"

// 返回按钮回调的block
typedef void(^ZWPlayerGoBackBlock)(void);


#pragma mark -和cell上播放相关
//全屏按钮的回调  主要是配合cell使用
typedef void(^ZWPlayerFullScreenBtnBlock)(UIButton *fullScreenBtn);
//播放完成的回调  主要是配合cell使用
typedef void(^ZWPlayerPlayCompletedBlock)(void);


// playerLayer的填充模式（默认：等比例填充，直到一个维度到达区域边界）
typedef NS_ENUM(NSInteger, ZWPlayerLayerGravity) {
    ZWPlayerLayerGravityResize,           // 非均匀模式。两个维度完全填充至整个视图区域
    ZWPlayerLayerGravityResizeAspect,     // 等比例填充，直到一个维度到达区域边界
    ZWPlayerLayerGravityResizeAspectFill  // 等比例填充，直到填充满整个视图区域，其中一个维度的部分区域会被裁剪
};

@interface ZWPlayerView : UIView
/** 视频URL */
@property (nonatomic, strong) NSURL                *videoURL;
/** 返回按钮Block */
@property (nonatomic, copy  ) ZWPlayerGoBackBlock  goBackBlock;
/** 设置playerLayer的填充模式 */
@property (nonatomic, assign) ZWPlayerLayerGravity playerLayerGravity;
/** 从xx秒开始播放视频跳转 */
@property (nonatomic, assign) NSInteger            seekTime;
/** 播放前占位图片的名称，不设置就显示默认占位图（需要在设置视频URL之前设置） */
@property (nonatomic, copy) NSString               *placeholderImageName;
/** 是否被用户暂停 */
@property (nonatomic, assign, readonly) BOOL       isPauseByUser;


/** 控制层View */
@property (nonatomic, strong) ZWPlayerControlView *controlView;
/** playerLayer */
@property (nonatomic, strong) AVPlayerLayer       *playerLayer;

@property(nonatomic,strong)UIActivityIndicatorView *loadingView;

#pragma mark - cell上播放相关
/**是否在cell上播放video */
@property (nonatomic, assign) BOOL                isCellVideo;
/** 是否缩小视频在底部 */
@property (nonatomic, assign) BOOL                isBottomVideo;
/** 全屏按钮的Block */
@property (nonatomic, copy  ) ZWPlayerFullScreenBtnBlock  fullScreenBtnBlock;
/** 播放完成的Block */
@property (nonatomic, copy  )ZWPlayerPlayCompletedBlock playCompletedBlock;


/**
 *  自动播放，默认不自动播放
 */
- (void)autoPlayTheVideo;

/**
 *  取消延时隐藏controlView的方法,在ViewController的delloc方法中调用
 *  用于解决：刚打开视频播放器，就关闭该页面，maskView的延时隐藏还未执行。
 */
- (void)cancelAutoFadeOutControlBar;
/***播放*/
- (void)play;
/***暂停*/
- (void)pause;




#pragma mark - cell上播放相关
//=========tableView上播放相关=========
/***单例，用于tableViewCell上的多个视频播放*/
+ (instancetype)sharedPlayerView;
/***在当前页面，设置新的Player的URL调用此方法*/
- (void)resetToPlayNewURL;
/***重置player*/
- (void)resetPlayer;





@end
