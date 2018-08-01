//
//  DDYViewController2.m
//  DDYAnalyse
//
//  Created by 马栋军 on 2018/3/15.
//  Copyright © 2018年 DangDangWang. All rights reserved.
//

#import "DDYViewController2.h"
#import "DDYClick.h"

@interface DDYViewController2 ()

@end

@implementation DDYViewController2
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor orangeColor];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [DDYClick DDY_getBuryNodeFromSql];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [DDYClick DDY_beginLogPageView:@"page_id_4002"];
//
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    // 页面
//    [DDYClick DDY_endLogPageView:@"page_id_4002" attributes:@{DDY_pidKey:@"pid=2"
//                    ,DDY_permanent_idKey:@"API_id"
//                                                              }];
//
//}

@end
