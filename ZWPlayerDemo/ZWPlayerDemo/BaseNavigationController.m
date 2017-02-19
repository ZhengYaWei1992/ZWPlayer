//
//  BaseNavigationController.m
//  iOS-rotate-demo
//
//  Created by 郑亚伟 on 16/10/14.
//  Copyright © 2016年 Dvel. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count == 0){
        return [super pushViewController:viewController animated:animated];
    }else if (self.viewControllers.count>=1) {
        viewController.hidesBottomBarWhenPushed = YES;//隐藏二级页面的tabbar
    }
    [super pushViewController:viewController animated:animated];
}




@end
