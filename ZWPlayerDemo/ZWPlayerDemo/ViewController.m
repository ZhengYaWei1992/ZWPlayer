//
//  ViewController.m
//  ZWPlayerDemo
//
//  Created by 郑亚伟 on 2017/2/9.
//  Copyright © 2017年 zhengyawei. All rights reserved.
//

#import "ViewController.h"
#import "ViewController2.h"

//使用播放器的时候，只要导入这个头文件即可
#import "ZWPlayer.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightTextColor];
    [self.view addSubview:self.tableView];
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = @[@"http://wvideo.spriteapp.cn/video/2016/0328/56f8ec01d9bfe_wpd.mp4",
                        @"http://baobab.wdjcdn.com/1456117847747a_x264.mp4",
                        @"http://baobab.wdjcdn.com/14525705791193.mp4",
                        @"http://baobab.wdjcdn.com/1456459181808howtoloseweight_x264.mp4",
                        @"http://baobab.wdjcdn.com/1455968234865481297704.mp4",
                        @"http://baobab.wdjcdn.com/1455782903700jy.mp4",
                        @"http://baobab.wdjcdn.com/14564977406580.mp4",
                        @"http://baobab.wdjcdn.com/1456316686552The.mp4",
                        @"http://baobab.wdjcdn.com/1456480115661mtl.mp4",
                        @"http://baobab.wdjcdn.com/1456665467509qingshu.mp4",
                        @"http://baobab.wdjcdn.com/1455614108256t(2).mp4",
                        @"http://baobab.wdjcdn.com/1456317490140jiyiyuetai_x264.mp4",
                        @"http://baobab.wdjcdn.com/1455888619273255747085_x264.mp4",
                        @"http://baobab.wdjcdn.com/1456734464766B(13).mp4",
                        @"http://baobab.wdjcdn.com/1456653443902B.mp4",
                        @"http://baobab.wdjcdn.com/1456231710844S(24).mp4"];}
    return _dataSource;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //这里没有复用cell，但也没事
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"netListCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"netListCell"];
    }
    cell.textLabel.text   = [NSString stringWithFormat:@"视频%zd",indexPath.row+1];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ViewController2 *movieVC = [[ViewController2 alloc]init];
    movieVC.videoUrl = [NSURL URLWithString:self.dataSource[indexPath.row]];
    [self.navigationController pushViewController:movieVC animated:YES];
}







@end
