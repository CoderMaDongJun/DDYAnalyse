//
//  UIViewController+DDY_Analyse.m
//  DDYAnalyse
//
//  Created by 马栋军 on 2018/3/23.
//

#import "UIViewController+DDY_Analyse.h"
#import "DDYTool.h"
#import "DDYClick.h"

@implementation UIViewController (DDY_Analyse)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // viewWillAppear
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelector = @selector(DDY_viewWillAppear:);
        [DDYTool DDY_swizzlingInClass:[self class] originalSelector:originalSelector swizzledSelector:swizzledSelector];
        
        // viewWillDisappear
        SEL originalSelector1 = @selector(viewWillDisappear:);
        SEL swizzledSelector1 = @selector(DDY_viewWillDisappear:);
        [DDYTool DDY_swizzlingInClass:[self class] originalSelector:originalSelector1 swizzledSelector:swizzledSelector1];
    });
}
#pragma mark - Method Swizzling
- (void)DDY_viewWillAppear:(BOOL)animated
{
    [self DDY_injectViewWillAppear];
    
    [self DDY_viewWillAppear:animated];
}

- (void)DDY_viewWillDisappear:(BOOL)animated
{
    [self DDY_injectViewWillDisappear];
    
    [self DDY_viewWillDisappear:animated];
}

// 利用hook，统计页面停留时长
- (void)DDY_injectViewWillAppear
{
    NSString *pageId = [self DDY_pageEventID:YES];
    if (pageId) {
         [DDYClick DDY_beginLogPageView:pageId];
    }
}

- (void)DDY_injectViewWillDisappear
{
    NSString *pageId = [self DDY_pageEventID:NO];
    if (pageId) {
        [DDYClick DDY_endLogPageView:pageId attributes:nil];
    }
}

- (NSString *)DDY_pageEventID:(BOOL)bEnterPage
{
    NSDictionary *configDict = [self DDY_dictionaryFromUserStatisticsConfigPlist];
    NSString *selfClassName = NSStringFromClass([self class]);
    return configDict[selfClassName][@"DDY_pageEventIDs"][bEnterPage ? @"Enter" : @"Leave"];
}

- (NSDictionary *)DDY_dictionaryFromUserStatisticsConfigPlist
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"DDYAnalyseConfig" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    return dic;
}
@end
