//
//  A_A_ViewController.m
//  ZWPlayerDemo
//
//  Created by 郑亚伟 on 2017/2/19.
//  Copyright © 2017年 zhengyawei. All rights reserved.
//

#import "A_A_ViewController.h"
#import "ZWPlayer.h"

@interface A_A_ViewController ()

//播放器
@property(nonatomic,strong)ZWPlayerView *playerView;
//离开页面时候是否在播放
@property (nonatomic, assign) BOOL isPlaying;

@end

@implementation A_A_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //上边用黑色的view遮挡住状态栏
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:topView];
    [topView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_offset(20);
    }];
    
    _playerView = [[ZWPlayerView alloc]init];
    //_playerView.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.width * 9 / 16.0);
    [self.view addSubview:self.playerView];
    
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.left.right.equalTo(self.view);
        // 注意此处，宽高比16：9优先级比1000低就行，在因为iPhone 4S宽高比不是16：9
        //注意这两种截然不同的写法
        make.height.equalTo(self.playerView.mas_width).multipliedBy(9.0f/16.0f).with.priority(750);
       // make.bottom.equalTo(self.view).offset(0);
    }];
    
    
    //相关参数设置
    //播放地址
    self.playerView.videoURL = self.videoUrl;
    //占位图
    self.playerView.placeholderImageName = @"image2.png";
    //视频填充模式
    self.playerView.playerLayerGravity = ZWPlayerLayerGravityResize;
    //设置自动播放
    [self.playerView autoPlayTheVideo];
    
    
    __weak typeof(self) weakSelf = self;
    //播放器返回按钮block回调
    self.playerView.goBackBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"进入下一界面" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(self.view.frame.size.width / 2 - 100, self.view.frame.size.width + 100, 200, 40);
    [self.view addSubview:btn];
    
    //    ZWPlayerControlView *c = [[ZWPlayerControlView alloc]init];
    //    c.frame = CGRectMake(0, self.view.frame.size.width, self.view.frame.size.width, 200);
    //    [self.view addSubview:c];
    
}
- (void)btnClick{
    UIViewController *vc = [[UIViewController alloc]init];
    vc.view.backgroundColor = [UIColor cyanColor];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    //设置状态栏字体颜色
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    //
    if (self.playerView) {
        [self.playerView setNeedsLayout];
    }
    //从第三界面返回的时候
    if (self.navigationController.viewControllers.count == 2 && self.playerView && self.isPlaying) {
        self.isPlaying = NO;
        [self.playerView play];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    //push到下一界面,如果当前处于播放状态，要设置为暂停
    if (self.navigationController.viewControllers.count == 3 && self.playerView && !self.playerView.isPauseByUser) {
        self.isPlaying = YES;
        [self.playerView pause];
    }
}


//屏幕方向旋转的时候调用
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        self.view.backgroundColor = [UIColor whiteColor];
        [self.playerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(20);
        }];
    }else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        self.view.backgroundColor = [UIColor blackColor];
        [self.playerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(0);
        }];
    }
}

@end
