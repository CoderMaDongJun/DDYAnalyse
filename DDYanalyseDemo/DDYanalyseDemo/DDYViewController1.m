//
//  DDYViewController1.m
//  DDYAnalyse
//
//  Created by 马栋军 on 2018/3/15.
//  Copyright © 2018年 DangDangWang. All rights reserved.
//

#import "DDYViewController1.h"
#import "DDYClick.h"
#import "DDYViewController2.h"

@interface DDYViewController1 ()

@end

@implementation DDYViewController1
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor purpleColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [self presentViewController:[NSClassFromString(@"DDYViewController2") new] animated:YES completion:nil];
    DDYViewController1 *vc = [[DDYViewController2 alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [DDYClick DDY_beginLogPageView:@"page_id_4001"];
//    
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    // 页面
//    [DDYClick DDY_endLogPageView:@"page_id_4001" attributes:@{DDY_pidKey:@"pid=1"
//                  ,DDY_permanent_idKey:@"API_id"
//                                                              }];
//    
//}

@end
