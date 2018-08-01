//
//  DDYViewController.m
//  DDYAnalyse
//
//  Created by 马栋军 on 2018/3/14.
//  Copyright © 2018年 DangDangWang. All rights reserved.
//

#import "DDYViewController.h"
#import "DDYClick.h"
#import "DDYViewController1.h"
//#import "UIControl+DDYAnalyse.h"

@interface DDYViewController ()

@end

@implementation DDYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    // write
    UIButton *click = [UIButton buttonWithType:UIButtonTypeCustom];
    click.frame = CGRectMake(80, 200, 100, 80);
    [click setTitle:@"writeClick" forState:UIControlStateNormal];
    click.backgroundColor = [UIColor greenColor];
    [click setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [click addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:click];
    
    // read
    UIButton *click1 = [UIButton buttonWithType:UIButtonTypeCustom];
    click1.frame = CGRectMake(80, 300, 100, 80);
    [click1 setTitle:@"readData" forState:UIControlStateNormal];
    click1.backgroundColor = [UIColor yellowColor];
    [click1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [click1 addTarget:self action:@selector(click1:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:click1];
    
    // delete
    UIButton *click2 = [UIButton buttonWithType:UIButtonTypeCustom];
    click2.frame = CGRectMake(200, 300, 100, 80);
    [click2 setTitle:@"deleteData" forState:UIControlStateNormal];
    click2.backgroundColor = [UIColor cyanColor];
    [click2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [click2 addTarget:self action:@selector(click2:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:click2];
    
    // delleteTable
    UIButton *click3 = [UIButton buttonWithType:UIButtonTypeCustom];
    click3.frame = CGRectMake(200, 200, 100, 80);
    [click3 setTitle:@"delleteTable" forState:UIControlStateNormal];
    click3.backgroundColor = [UIColor cyanColor];
    [click3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [click3 addTarget:self action:@selector(click3:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:click3];
    
    UIScrollView *scr = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 400, 200, 100)];
    scr.backgroundColor = [UIColor redColor];
    scr.contentSize = CGSizeMake(300, 120);
    [self.view addSubview:scr];
}

- (void)click:(UIButton *)sender
{
    NSLog(@"%s",__func__);
//    sender.DDYLinkUrl = @"lingkurl";
//    sender.DDYContent = @"content";
//    sender.DDYExpand = @"expand";
    // 触发搜索动作
//    [DDYClick DDY_event:@"eventId_4002" attributes:@{DDY_pageIdKey:@"pageId_1003"
//                    ,DDY_pidKey:@"pid=2378"
//                    ,DDY_linkurlKey:@"product://pid=40082"
//                    ,DDY_contentKey:@"floor=xxx#tab=xxx"
//                    ,DDY_expandKey:@"(1002||||floor=B版主题馆1-1)(||||)(||||)"
//                                                 }];
}

- (void)click1:(UIButton *)sender
{
    [DDYClick DDY_getBuryNodeFromSql];
}

- (void)click2:(UIButton *)sender
{
    NSLog(@"%s",__func__);
    [DDYClick DDY_deleteWithRowids:@[@2,@5,@11,@12,@18,@23,@25]];
}

- (void)click3:(UIButton *)sender
{
    NSLog(@"%s",__func__);
    [DDYClick DDY_clearTableDataWithTableName:nil];
}
#if 1
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [self presentViewController:[NSClassFromString(@"DDYViewController1") new] animated:YES completion:nil];
    DDYViewController1 *vc = [[DDYViewController1 alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [DDYClick DDY_beginLogPageView:@"page_id_4000"];
//    
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    // 页面
//    [DDYClick DDY_endLogPageView:@"page_id_4000" attributes:@{DDY_pidKey:@"pid=0"
//                     ,DDY_permanent_idKey:@"API_id"
//                                                              }];
//}

#endif
@end
