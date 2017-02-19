//
//  C_Controller.m
//  ZWPlayerDemo
//
//  Created by 郑亚伟 on 2017/2/14.
//  Copyright © 2017年 zhengyawei. All rights reserved.
//

#import "C_Controller.h"
#import "B_Model.h"
#import "B_TableViewCell.h"
#import "ZWPlayer.h"

@interface C_Controller ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)UITableView *tableView;

//播放器
@property(nonatomic,strong)ZWPlayerView *playerView;
//离开页面时候是否在播放
@property (nonatomic, assign) BOOL isPlaying;
//是否在cell中播放
@property(nonatomic,assign)BOOL isInCell;
//是否在主界面底部播放
@property(nonatomic,assign)BOOL isBottomVideo;

//记录当前在哪一个cell上播放对应的indexPath
@property(nonatomic,strong) NSIndexPath *currentIndexPath;
//播放器在哪个cell上播放
@property(nonatomic,retain)B_TableViewCell *currentCell;
@end

@implementation C_Controller
#pragma mark - Life Cycle
- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _isInCell = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self requestData];
    [self.view addSubview:self.tableView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    if (_playerView) {
        [_playerView setNeedsLayout];
    }
    //从第三界面返回的时候
    if (self.navigationController.viewControllers.count == 2 && self.playerView && self.isPlaying) {
        self.isPlaying = NO;
        [self.playerView play];
    }
    
    //获取设备旋转方向的通知,即使关闭了自动旋转,一样可以监测到设备的旋转方向
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    //旋转屏幕通知
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceOrientationChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
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
    
    self.isPlaying = YES;
    [self.playerView pause];
    
    
    //注意调用这一句
    [self.playerView resetPlayer];
}

#pragma mark - dataSource Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier        = @"playerCell";
    B_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[B_TableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    B_Model *model = self.dataSource[indexPath.row];
    cell.model = model;
    [cell.playBtn addTarget:self action:@selector(startPlayVideo:) forControlEvents:UIControlEventTouchUpInside];
    cell.playBtn.tag = indexPath.row;
    
    //解决复用相关问题，上下滚动视频消失，这里可以不考虑
        if (_playerView && _playerView.superview) {
            if (indexPath.row== _currentIndexPath.row) {
                [cell.playBtn.superview sendSubviewToBack:cell.playBtn];
            }else{
                [cell.playBtn.superview bringSubviewToFront:cell.playBtn];
            }
            NSArray *indexpaths = [tableView indexPathsForVisibleRows];
            if (![indexpaths containsObject:_currentIndexPath]) {//复用
                if ([[UIApplication sharedApplication].keyWindow.subviews containsObject:_playerView]) {
                    _playerView.hidden = NO;
                }else{
                    _playerView.hidden = YES;
                }
            }else{
                if ([cell.picView.subviews containsObject:_playerView]) {
                    [cell.picView addSubview:_playerView];
                    [_playerView play];
                    _playerView.hidden = NO;
                }
            }
        }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


#pragma mark - cell上播放按钮点击事件
-(void)startPlayVideo:(UIButton *)sender{
    _currentIndexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    //根据cell上的播放按钮获取到当前cell
    if ([UIDevice currentDevice].systemVersion.floatValue>=8||[UIDevice currentDevice].systemVersion.floatValue<7) {
        self.currentCell = (B_TableViewCell *)sender.superview.superview.superview;
    }else{//ios7系统 UITableViewCell上多了一个层级UITableViewCellScrollView
        self.currentCell = (B_TableViewCell *)sender.superview.superview.superview.subviews;
    }
    
    //设置播放器的显示相关
    _playerView = [ZWPlayerView sharedPlayerView];
    [self.currentCell.picView addSubview:self.playerView];
    self.playerView.frame = self.currentCell.picView.bounds;
    _playerView.transform = CGAffineTransformIdentity;
    [_playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.currentCell.picView).with.offset(0);
        make.left.equalTo(self.currentCell.picView).with.offset(0);
        make.right.equalTo(self.currentCell.picView).with.offset(0);
        make.height.equalTo(@(self.currentCell.picView.frame.size.height));
    }];
    
    //    [_playerView.controlView addSubview:_playerView.controlView.activity];
    //    [_playerView.controlView.activity mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.center.equalTo(_playerView.controlView);
    //    }];
    
    [self.currentCell.picView bringSubviewToFront:self.playerView];
    [self.currentCell.playBtn.superview sendSubviewToBack:self.currentCell.playBtn];
    [self.tableView reloadData];
    
    //每次播放另外一个视频之前要调用该方法，最好放在播放参数和开始播放之前
    [self.playerView resetToPlayNewURL];
    
    //*****************设置播放器相关*****************
    //必须要设置的参数
    self.playerView.isCellVideo = YES;
    //设置播放器的videoUrl
    B_Model *model = self.dataSource[_currentIndexPath.row];
    NSURL *videoUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",model.playUrl]];
    self.playerView.videoURL = videoUrl;
    self.playerView.playerLayerGravity = ZWPlayerLayerGravityResize;
    self.playerView.placeholderImageName = @"image2.png";
    //设置自动播放
    [self.playerView autoPlayTheVideo];
    
    
    //注意：设置返回按钮图片和返回按钮回调，必选是在播放后才写这些代码，放在playerView的懒加载中无效。
    //设置返回按钮图片
    if (_isInCell) {
        [_playerView.controlView.backBtn setImage:[UIImage imageNamed:ZWPlayerSrcName(@"ZFPlayer_close")] forState:UIControlStateNormal];
    }
    //返回按钮回调事件
    __weak typeof(self) weakSelf = self;
    _playerView.goBackBlock = ^(){
        if (!weakSelf.isInCell) {
            weakSelf.isInCell = YES;
            weakSelf.playerView.controlView.fullScreenBtn.selected = NO;
        }
        [weakSelf releasePlayerView];
        //调用这句话才能更新状态栏（控制显示、隐藏以及样式）
        [weakSelf setNeedsStatusBarAppearanceUpdate];
        //为下一次播放做准备
        _isInCell = YES;
    };
    _playerView.playCompletedBlock = ^(){
        if (!weakSelf.isInCell) {
            weakSelf.isInCell = YES;
            weakSelf.playerView.controlView.fullScreenBtn.selected = NO;
        }
        [weakSelf releasePlayerView];
        //调用这句话才能更新状态栏（控制显示、隐藏以及样式）
        [weakSelf setNeedsStatusBarAppearanceUpdate];
        //为下一次播放做准备
        _isInCell = YES;
    };
    _playerView.fullScreenBtnBlock = ^(UIButton *fullScreenBtn){
        if (fullScreenBtn.selected) {//转为非全屏状态
            _isInCell = YES;
            B_TableViewCell *currentCell = (B_TableViewCell *)[weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:weakSelf.currentIndexPath.row inSection:0]];
            [currentCell.picView addSubview:weakSelf.playerView];
            [weakSelf toOrientation:UIInterfaceOrientationPortrait];
            fullScreenBtn.selected = NO;
        }else{//转为全屏状态
            _isInCell = NO;
            [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.playerView];
            [weakSelf toOrientation:UIInterfaceOrientationLandscapeRight];
            [weakSelf.playerView.controlView.backBtn setImage:[UIImage imageNamed:ZWPlayerSrcName(@"ZFPlayer_close")] forState:UIControlStateNormal];
            fullScreenBtn.selected = YES;
        }
        //调用这句话才能更新状态栏（控制显示、隐藏以及样式）
        [weakSelf setNeedsStatusBarAppearanceUpdate];
    };
    ZWPlayerControlView *controlView = self.playerView.controlView;
    [controlView.activity startAnimating];
    
    
    [self.tableView reloadData];
    
}

- (void)releasePlayerView{
    [self.playerView pause];
    [self.playerView removeFromSuperview];
    [self.playerView.playerLayer removeFromSuperlayer];
    //    self.playerView = nil;
}
#pragma mark -控制状态栏显示和隐藏
- (BOOL)prefersStatusBarHidden{
    if (_isInCell) {
        return NO;
    }else{
        return YES;
    }
    return NO;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}



#pragma mark- 屏幕旋转相关
//点击进入,退出全屏,或者监测到屏幕旋转去调用的方法
-(void)toOrientation:(UIInterfaceOrientation)orientation{
    //根据要旋转的方向,使用Masonry重新修改限制
    if (orientation ==UIInterfaceOrientationPortrait) {//
        B_TableViewCell *currentCell = (B_TableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndexPath.row inSection:0]];
        [_playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(currentCell.picView).with.offset(0);
            make.left.equalTo(currentCell.picView).with.offset(0);
            make.right.equalTo(currentCell.picView).with.offset(0);
            make.height.equalTo(@(currentCell.picView.frame.size.height));
        }];
    }else{
        [_playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@([UIScreen mainScreen].bounds.size.height));
            make.height.equalTo(@([UIScreen mainScreen].bounds.size.width));
            make.center.equalTo(_playerView.superview);
        }];
    }
    //获取旋转状态条需要的时间:
    [UIView beginAnimations:nil context:nil];
    //给你的播放视频的view视图设置旋转
    if (orientation ==UIInterfaceOrientationPortrait) {
        _playerView.transform = CGAffineTransformIdentity;
    }else{
        _playerView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }
    [UIView setAnimationDuration:1.0];
    //开始旋转
    [UIView commitAnimations];
}

#pragma mark - scrollView代理方法
//tableViewCell离开界面，视频消失
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.tableView) {
        if(_playerView == nil){
            return;
        }
        if (_playerView.superview) {//播放的cell在当前屏幕可视区
            CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:_currentIndexPath];
            CGRect rectInSuperview = [self.tableView convertRect:rectInTableView toView:[self.tableView superview]];
            
            if (rectInSuperview.origin.y<-self.currentCell.picView.frame.size.height||rectInSuperview.origin.y>[UIScreen mainScreen].bounds.size.height-64-49) {//往上拖动
                if ([[UIApplication sharedApplication].keyWindow.subviews containsObject:_playerView]&&_isBottomVideo) {
                    _isBottomVideo = YES;
                }else{
                    //放到window，在底部显示
                    [self toBottomVideo];
                }
            }else{
                if ([self.currentCell.picView.subviews containsObject:_playerView]) {
                    
                }else{
                    //回到原来的cell上
                    [self toCell];
                }
            }
        }
    }
    
}
//放到window，在底部显示
- (void)toBottomVideo{
    //放widow上
    [_playerView removeFromSuperview];
    
    
    [UIView animateWithDuration:0.5f animations:^{
        [[UIApplication sharedApplication].keyWindow addSubview:_playerView];
        _playerView.playerLayerGravity = ZWPlayerLayerGravityResizeAspectFill;
        
        _playerView.frame = CGRectMake(ScreenWidth - 100 * 16 / 9.0 - 5,ScreenHeight - 100 - 60, 100 * 16 / 9.0, 100);
        _playerView.playerLayer.frame =  _playerView.bounds;
        [self.playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(100 * 16 / 9.0);
            make.trailing.mas_equalTo(-5);
            make.bottom.mas_equalTo(-self.tableView.contentInset.bottom-60);
            make.height.equalTo(@100);
        }];
    }completion:^(BOOL finished) {
       _isBottomVideo = YES;
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:_playerView];
        //隐藏控制层的top和bottom
        _playerView.controlView.topImageView.hidden = YES;
        _playerView.controlView.bottomImageView.hidden = YES;
    }];
}
//放到cell上播放
- (void)toCell{
    B_TableViewCell *currentCell = (B_TableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndexPath.row inSection:0]];
    [UIView animateWithDuration:0.5f animations:^{
        //_playerView.transform = CGAffineTransformIdentity;
        _playerView.frame = currentCell.picView.bounds;
        _playerView.playerLayer.frame =  _playerView.bounds;
        [currentCell.picView addSubview:_playerView];
        [currentCell.picView bringSubviewToFront:_playerView];
        [_playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            //make.edges.equalTo(_playerView).with.offset(0);
             make.edges.mas_equalTo(0);
            make.width.mas_equalTo(_playerView.frame.size.width);
            make.height.mas_equalTo(_playerView.frame.size.height);
        }];
    }completion:^(BOOL finished) {
        _isBottomVideo = NO;
        _playerView.playerLayerGravity = ZWPlayerLayerGravityResize;
        //显示控制层的top和bottom
        _playerView.controlView.topImageView.hidden = NO;
        _playerView.controlView.bottomImageView.hidden = NO;
    }];

    
    
}


#pragma mark - 懒加载方法
- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64 - 49) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}



#pragma mark -初始化数据源
- (void)requestData{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"videoData" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    self.dataSource = @[].mutableCopy;
    NSArray *videoList = [rootDict objectForKey:@"videoList"];
    for (NSDictionary *dataDic in videoList) {
        B_Model *model = [[B_Model alloc]init];
        [model setValuesForKeysWithDictionary:dataDic];
        [self.dataSource addObject:model];
    }
}

@end
