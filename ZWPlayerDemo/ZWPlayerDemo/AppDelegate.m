//
//  AppDelegate.m
//  ZWPlayerDemo
//
//  Created by 郑亚伟 on 2017/2/9.
//  Copyright © 2017年 zhengyawei. All rights reserved.
//

#import "AppDelegate.h"

#import "TabBarController.h"
#import "BaseNavigationController.h"

#import "ViewController.h"
#import "A_Controller.h"
#import "B_Controller.h"
#import "C_Controller.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    _window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [_window makeKeyAndVisible];
    
    ViewController *vc1 = [ViewController new];
    BaseNavigationController *navC1 = [[BaseNavigationController alloc] initWithRootViewController:vc1];
    vc1.tabBarItem.image = [UIImage imageNamed:@"tabbar_account"];
    vc1.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_account_press"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc1.tabBarItem.title = @"一";
    [vc1.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
    
     A_Controller *vc2 = [A_Controller new];
    BaseNavigationController *navC2 = [[BaseNavigationController alloc] initWithRootViewController:vc2];
    vc2.tabBarItem.image = [UIImage imageNamed:@"tabbar_account"];
    vc2.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_account_press"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc2.tabBarItem.title = @"二";
     [vc2.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
    
    
    B_Controller *vc3 = [B_Controller new];
    BaseNavigationController *navC3 = [[BaseNavigationController alloc] initWithRootViewController:vc3];
    vc3.tabBarItem.image = [UIImage imageNamed:@"tabbar_account"];
    vc3.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_account_press"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc3.tabBarItem.title = @"三";
    [vc3.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
    
    C_Controller *vc4 = [C_Controller new];
    BaseNavigationController *navC4 = [[BaseNavigationController alloc] initWithRootViewController:vc4];
    vc4.tabBarItem.image = [UIImage imageNamed:@"tabbar_account"];
    vc4.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_account_press"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc4.tabBarItem.title = @"四";
    [vc4.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
    
    TabBarController *tabbarC = [TabBarController new];
    [tabbarC addChildViewController:navC1];
    [tabbarC addChildViewController:navC2];
    [tabbarC addChildViewController:navC3];
     [tabbarC addChildViewController:navC4];
    
    self.window.rootViewController = tabbarC;
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
