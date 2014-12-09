//
//  ViewController.m
//  Ribbit
//
//  Created by Tung Nguyen on 06/12/14.
//  Copyright (c) 2014 Tung Nguyen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSArray *tabBarItems = self.tabBarController.tabBar.items;
    UITabBarItem *tab = tabBarItems[2];
    tab.badgeValue = @"3";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
