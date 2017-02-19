//
//  ZWPlayerControlView.m
//  ZWPlayerDemo
//
//  Created by 郑亚伟 on 2017/2/9.
//  Copyright © 2017年 zhengyawei. All rights reserved.
//



/**
 控制层视图
*/
#import "ZWPlayerControlView.h"
#import "ZWPlayer.h"


@interface ZWPlayerControlView ()
/** 开始播放按钮 */
@property (nonatomic, strong) UIButton                *startBtn;
/** 当前播放时长label */
@property (nonatomic, strong) UILabel                 *currentTimeLabel;
/** 视频总时长label */
@property (nonatomic, strong) UILabel                 *totalTimeLabel;


//说明：带有缓冲效果的，一般情况下是通过UIProgressView和UISlider结合使用，形成的效果。
/** 缓冲进度条 */
@property (nonatomic, strong) UIProgressView          *progressView;
/** 滑杆 */
@property (nonatomic, strong) UISlider                *videoSlider;



/** 全屏按钮 */
@property (nonatomic, strong) UIButton                *fullScreenBtn;
/** 快进快退label */
@property (nonatomic, strong) UILabel                 *horizontalLabel;
/** 系统菊花 */
@property (nonatomic, strong) UIActivityIndicatorView *activity;
/** 返回按钮*/
@property (nonatomic, strong) UIButton                *backBtn;
/** 重播按钮 */
@property (nonatomic, strong) UIButton                *repeatBtn;
/** bottomView*/
@property (nonatomic, strong) UIImageView             *bottomImageView;
/** topView */
@property (nonatomic, strong) UIImageView             *topImageView;
/** 播放按钮 */
@property (nonatomic, strong) UIButton                *playeBtn;

@end

@implementation ZWPlayerControlView
- (instancetype)init{
    self = [super init];
    if (self) {
        
        [self addSubview:self.topImageView];
        [self addSubview:self.bottomImageView];
        [self.bottomImageView addSubview:self.startBtn];
        [self.bottomImageView addSubview:self.currentTimeLabel];
        [self.bottomImageView addSubview:self.progressView];
        [self.bottomImageView addSubview:self.videoSlider];
        [self.bottomImageView addSubview:self.fullScreenBtn];
        [self.bottomImageView addSubview:self.totalTimeLabel];
        
        //注意，返回按钮不是放置在top上面，而是直接放置在控制层上。因为播放完毕的时候隐藏top和bottom，但是返回按钮和播放按钮并不隐藏。
        [self addSubview:self.backBtn];
        [self addSubview:self.activity];
        [self addSubview:self.repeatBtn];
        [self addSubview:self.horizontalLabel];
        [self addSubview:self.playeBtn];
        
        // 添加子控件的约束
        [self makeSubViewsConstraints];
       
        UITapGestureRecognizer *sliderTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSliderAction:)];
        [self.videoSlider addGestureRecognizer:sliderTap];
        //显示菊花转
        [self.activity stopAnimating];
//        [self.activity startAnimating];
        // 初始化时重置controlView
        [self resetControlView];
    }
    return self;
}


#pragma mark - 布局设置约束
- (void)makeSubViewsConstraints{
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading).offset(7);
        make.top.equalTo(self.mas_top).offset(5);
        make.width.height.mas_equalTo(40);
    }];
    
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.equalTo(self);
        make.height.mas_equalTo(80);
    }];
    
    
    
    [self.bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self);
        make.height.mas_equalTo(50);
    }];
    
    [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bottomImageView.mas_leading).offset(5);
        make.bottom.equalTo(self.bottomImageView.mas_bottom).offset(-5);
        make.width.height.mas_equalTo(30);
    }];
    
    [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.startBtn.mas_trailing).offset(-3);
        make.centerY.equalTo(self.startBtn.mas_centerY);
        make.width.mas_equalTo(43);
    }];
    
    [self.fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30);
        make.trailing.equalTo(self.bottomImageView.mas_trailing).offset(-5);
        make.centerY.equalTo(self.startBtn.mas_centerY);
    }];
    
    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.fullScreenBtn.mas_leading).offset(3);
        make.centerY.equalTo(self.startBtn.mas_centerY);
        make.width.mas_equalTo(43);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.currentTimeLabel.mas_trailing).offset(4);
        make.trailing.equalTo(self.totalTimeLabel.mas_leading).offset(-4);
        make.centerY.equalTo(self.startBtn.mas_centerY);
    }];
    
    [self.videoSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.currentTimeLabel.mas_trailing).offset(4);
        make.trailing.equalTo(self.totalTimeLabel.mas_leading).offset(-4);
        make.centerY.equalTo(self.currentTimeLabel.mas_centerY).offset(-1);
        make.height.mas_equalTo(30);
    }];
    
    
    [self.horizontalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(33);
        make.center.equalTo(self);
    }];
    
    [self.activity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    [self.repeatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    [self.playeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}

#pragma mark - UISlider点击事件

/**
 *  UISlider 点击方法
 */
- (void)tapSliderAction:(UITapGestureRecognizer *)tap{
    if ([tap.view isKindOfClass:[UISlider class]] && self.tapBlock) {
        UISlider *slider = (UISlider *)tap.view;
        CGPoint point = [tap locationInView:slider];
        CGFloat length = slider.frame.size.width;
        // 视频跳转的value
        CGFloat tapValue = point.x / length;
        self.tapBlock(tapValue);
    }
}


#pragma mark -对外提供的三个方法
/** 重置ControlView，恢复到初始状态*/
- (void)resetControlView{
    self.videoSlider.value      = 0;
    self.progressView.progress  = 0;
    self.currentTimeLabel.text  = @"00:00";
    self.totalTimeLabel.text    = @"00:00";
    self.horizontalLabel.hidden = YES;
    self.repeatBtn.hidden       = YES;
    self.playeBtn.hidden        = YES;
    [self.activity startAnimating];
    self.backgroundColor        = [UIColor clearColor];
    
}
/** 显示top、bottom*/
- (void)showControlView{
    self.topImageView.alpha    = 1;
    self.bottomImageView.alpha = 1;
}
/** 隐藏top、bottom*/
- (void)hideControlView{
    self.topImageView.alpha    = 0;
    self.bottomImageView.alpha = 0;
}


#pragma mark - getter

- (UIButton *)backBtn
{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:ZWPlayerSrcName(@"ZFPlayer_back_full")] forState:UIControlStateNormal];
    }
    return _backBtn;
}

- (UIImageView *)topImageView
{
    if (!_topImageView) {
        _topImageView                        = [[UIImageView alloc] init];
        _topImageView.userInteractionEnabled = YES;
        _topImageView.image                  = [UIImage imageNamed:ZWPlayerSrcName(@"ZFPlayer_top_shadow")];
    }
    return _topImageView;
}

- (UIImageView *)bottomImageView
{
    if (!_bottomImageView) {
        _bottomImageView                        = [[UIImageView alloc] init];
        _bottomImageView.userInteractionEnabled = YES;
        _bottomImageView.image                  = [UIImage imageNamed:ZWPlayerSrcName(@"ZFPlayer_bottom_shadow")];
    }
    return _bottomImageView;
}


- (UIButton *)startBtn
{
    if (!_startBtn) {
        _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startBtn setImage:[UIImage imageNamed:ZWPlayerSrcName(@"ZFPlayer_play")] forState:UIControlStateNormal];
        [_startBtn setImage:[UIImage imageNamed:ZWPlayerSrcName(@"ZFPlayer_pause")] forState:UIControlStateSelected];
    }
    return _startBtn;
}

- (UILabel *)currentTimeLabel
{
    if (!_currentTimeLabel) {
        _currentTimeLabel               = [[UILabel alloc] init];
        _currentTimeLabel.textColor     = [UIColor whiteColor];
        _currentTimeLabel.font          = [UIFont systemFontOfSize:12.0f];
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _currentTimeLabel;
}

- (UIProgressView *)progressView{
    if (!_progressView) {
        _progressView                   = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.progressTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        _progressView.trackTintColor    = [UIColor clearColor];
    }
    return _progressView;
}

- (UISlider *)videoSlider
{
    if (!_videoSlider) {
        _videoSlider                       = [[UISlider alloc] init];
        // 设置slider
        [_videoSlider setThumbImage:[UIImage imageNamed:ZWPlayerSrcName(@"ZFPlayer_slider")] forState:UIControlStateNormal];
        _videoSlider.maximumValue          = 1;
        _videoSlider.minimumTrackTintColor = [UIColor whiteColor];
        _videoSlider.maximumTrackTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
    }
    return _videoSlider;
}

- (UILabel *)totalTimeLabel
{
    if (!_totalTimeLabel) {
        _totalTimeLabel               = [[UILabel alloc] init];
        _totalTimeLabel.textColor     = [UIColor whiteColor];
        _totalTimeLabel.font          = [UIFont systemFontOfSize:12.0f];
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _totalTimeLabel;
}

- (UIButton *)fullScreenBtn
{
    if (!_fullScreenBtn) {
        _fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenBtn setImage:[UIImage imageNamed:ZWPlayerSrcName(@"ZFPlayer_fullscreen")] forState:UIControlStateNormal];
        [_fullScreenBtn setImage:[UIImage imageNamed:ZWPlayerSrcName(@"ZFPlayer_shrinkscreen")] forState:UIControlStateSelected];
    }
    return _fullScreenBtn;
}

- (UILabel *)horizontalLabel
{
    if (!_horizontalLabel) {
        _horizontalLabel                 = [[UILabel alloc] init];
        _horizontalLabel.textColor       = [UIColor whiteColor];
        _horizontalLabel.textAlignment   = NSTextAlignmentCenter;
        _horizontalLabel.font            = [UIFont systemFontOfSize:15.0];
        _horizontalLabel.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
        _horizontalLabel.layer.cornerRadius = 10;
        _horizontalLabel.clipsToBounds = YES;
        //_horizontalLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:ZWPlayerSrcName(@"ZFPlayer_management_mask")]];
    }
    return _horizontalLabel;
}

- (UIActivityIndicatorView *)activity{
    if (!_activity) {
        _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activity.frame = CGRectMake(0, 0, 100, 100);
        }
    return _activity;
}

- (UIButton *)repeatBtn
{
    if (!_repeatBtn) {
        _repeatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_repeatBtn setImage:[UIImage imageNamed:ZWPlayerSrcName(@"ZFPlayer_repeat_video")] forState:UIControlStateNormal];
    }
    return _repeatBtn;
}


- (UIButton *)playeBtn{
    if (!_playeBtn) {
        _playeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playeBtn setImage:[UIImage imageNamed:ZWPlayerSrcName(@"ZFPlayer_play_btn")] forState:UIControlStateNormal];
    }
    return _playeBtn;
}


@end
