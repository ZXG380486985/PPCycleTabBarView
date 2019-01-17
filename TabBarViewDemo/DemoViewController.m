//
//  DemoViewController.m
//  TabBarViewDemo
//
//  Created by super on 2019/1/17.
//  Copyright © 2019年 zxg. All rights reserved.
//

#import "DemoViewController.h"

#import "PPCycleTabBarView.h"

@interface DemoViewController ()

@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"demo";
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (self.index == 0) {
        [PPCycleTabBarView showCycleTabBarViewToView:self.view
                                          withHeight:100
                                           withTitle:@[@"推荐",@"热点",@"科技",@"财经",@"体育"]
                                           tapHandle:^(NSInteger index) {
                                           }];
    } else {
       PPCycleTabBarView *tabBarView = [PPCycleTabBarView showCycleTabBarViewToView:self.view
                                          withHeight:50
                                           withTitle:@[@"推荐",@"热点",@"科技",@"财经",@"体育"]
                                           tapHandle:^(NSInteger index) {
                                           }];
        [tabBarView configNumberOfPointLabelByData:@[[NSNumber numberWithInteger:1],
                                                     [NSNumber numberWithInteger:2],
                                                     [NSNumber numberWithInteger:3],
                                                     [NSNumber numberWithInteger:4],
                                                     [NSNumber numberWithInteger:5],]];
    }
    
}

@end
