//
//  ViewController.m
//  DDYAnalyse
//
//  Created by 马栋军 on 2018/3/13.
//  Copyright © 2018年 马栋军. All rights reserved.
//

#import "ViewController.h"
#import "DDYViewController.h"
#import "DDYClick.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    DDYViewController *vc = [[DDYViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
    
}

@end
