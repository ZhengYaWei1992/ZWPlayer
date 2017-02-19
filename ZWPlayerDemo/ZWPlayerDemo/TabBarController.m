//
//  TabBarController.m
//  iOS-rotate-demo
//
//  Created by Dvel on 16/4/20.
//  Copyright © 2016年 Dvel. All rights reserved.
//

#import "TabBarController.h"

//视频播放界面
#import "ViewController.h"
#import "ViewController2.h"

#import "A_A_ViewController.h"



@interface TabBarController ()

@end

@implementation TabBarController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.selectedIndex = 0;
}


- (BOOL)shouldAutorotate{
    UINavigationController *nav = self.viewControllers[self.selectedIndex];
    if ([nav.topViewController isKindOfClass:[ViewController2 class]]) {
       return YES;
    }else if ([nav.topViewController isKindOfClass:[A_A_ViewController class]]){
        return YES;
    }
    return NO;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    UINavigationController *nav = self.selectedViewController;
    if ([nav.topViewController isKindOfClass:[ViewController2 class]]) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }else if ([nav.topViewController isKindOfClass:[A_A_ViewController class]]){
         return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    // 其他页面
    return UIInterfaceOrientationMaskPortrait;
}




@end
