//
//  ViewController.m
//  TabBarViewDemo
//
//  Created by super on 2019/1/17.
//  Copyright © 2019年 zxg. All rights reserved.
//

#import "ViewController.h"
#import "DemoViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)tapTopButtonAction:(id)sender {
    DemoViewController *demoVC = [[DemoViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:demoVC];
    demoVC.index = 0;
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)tapBottomButtonAction:(id)sender {
    DemoViewController *demoVC = [[DemoViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:demoVC];
    demoVC.index = 1;
    [self presentViewController:nav animated:YES completion:nil];
}


@end
