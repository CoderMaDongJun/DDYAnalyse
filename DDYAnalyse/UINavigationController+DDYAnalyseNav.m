//
//  UINavigationController+DDYAnalyseNav.m
//  DDYAnalyse
//
//  Created by 马栋军 on 2018/5/14.
//

#import "UINavigationController+DDYAnalyseNav.h"
#import "DDYHookUtility.h"
#import "UIViewController+DDYAnalyse.h"
#import "DDYClick.h"
#import <objc/runtime.h>
#import "DDRoute.h"
@implementation NSObject (DDYAnalyse)
#pragma mark - 属性
- (void)setDDYLinkUrl:(NSString *)DDYLinkUrl
{
    objc_setAssociatedObject(self, @selector(DDYLinkUrl), DDYLinkUrl, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)DDYLinkUrl
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setDDYContent:(NSString *)DDYContent
{
    objc_setAssociatedObject(self, @selector(DDYContent), DDYContent, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)DDYContent
{
    return objc_getAssociatedObject(self, _cmd);
}
@end
@implementation UINavigationController (DDYAnalyseNav)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSelector1 = @selector(pushViewController:animated:);
        SEL swizzledSelector1 = @selector(DDY_swizPushViewController:animated:);
        [DDYHookUtility DDY_swizzlingInClass:[self class] originalSelector:originalSelector1 swizzledSelector:swizzledSelector1];
    });
}

#pragma mark - Method Swizzling
- (void)DDY_swizPushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count>0) {
        // 推出的新控制器
        UIViewController *sourceVc = self.viewControllers.lastObject;
        viewController.DDYTimer = [self DDY_pageTimer:viewController];
        viewController.DDYEV = [self DDY_pageEV:viewController];
        viewController.DDYPageId = [self DDY_pageID:viewController];
        viewController.DDYPrePageId = sourceVc.DDYPageId;
        if (sourceVc.DDYPid) {
            viewController.DDYPrePid = sourceVc.DDYPid;
        }
        
        NSLog(@"sourcePageId:%@ -- nowPageId:%@ -- nowPrePageId:%@ -- nowPrePid:%@",sourceVc.DDYPageId,viewController.DDYPageId,viewController.DDYPrePageId,viewController.DDYPrePid);
    }else{
        // 栈顶首个控制器
        viewController.DDYPageId = [self DDY_pageID:viewController];
        viewController.DDYTimer = [self DDY_pageTimer:viewController];
        viewController.DDYEV = [self DDY_pageEV:viewController];
    }
    
    // 判断是否需要点击事件统计
    [self judgeEvent:viewController];
    
    // 继续调用系统方法
    [self DDY_swizPushViewController:viewController animated:animated];
}

#pragma mark - private
- (void)judgeEvent:(UIViewController *)vc
{
    NSString *eventID = [self DDY_event:vc];
    if (eventID) {
        NSMutableDictionary *attr = [self DDY_buttonAttrs:vc];
        [DDYClick DDY_event:eventID attributes:attr];
    }
}

- (NSMutableDictionary *)DDY_buttonAttrs:(UIViewController *)vc
{
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    if (vc.DDYPageId) {
        [attr setValue:vc.DDYPageId forKey:DDY_pageIdKey];
    }
    if (vc.DDYPid) {
        [attr setValue:vc.DDYPid forKey:DDY_pidKey];
    }
    if (vc.DDYPrePageId) {
        [attr setValue:vc.DDYPrePageId forKey:DDY_prePageIdKey];
    }
    // 该属性在控制器内部赋值
    if (vc.DDYPrePid) {
        [attr setValue:vc.DDYPrePid forKey:DDY_prePidKey];
    }
    // 该属性在控制器内部赋值
    if (self.DDYContent) {
        [attr setValue:self.DDYContent forKey:DDY_contentKey];
        self.DDYContent = nil;
    }else if ([DDRoute route].DDYContent){
        [attr setValue:[DDRoute route].DDYContent forKey:DDY_contentKey];
        [DDRoute route].DDYContent = nil;
    }
    // 该属性在控制器内部赋值
    if (self.DDYLinkUrl) {
        [attr setValue:self.DDYLinkUrl forKey:DDY_linkurlKey];
        self.DDYLinkUrl = nil;
    }else if([DDRoute route].DDYLinkUrl){
        [attr setValue:self.DDYLinkUrl forKey:DDY_linkurlKey];
        [DDRoute route].DDYLinkUrl = nil;
    }else{
        [attr setValue:[NSString stringWithFormat:@"code://page_id:%@",vc.DDYPageId] forKey:DDY_linkurlKey];
    }
    return attr;
}

- (NSString *)DDY_event:(UIViewController *)vc
{
    NSDictionary *configDict = [self DDY_dictionaryFromUserStatisticsConfigPlist];
    NSString *selfClassName = NSStringFromClass([vc class]);
    return configDict[selfClassName][@"EventIDs"];
}

- (BOOL)DDY_pageEV:(UIViewController *)vc
{
    NSDictionary *configDict = [self DDY_dictionaryFromUserStatisticsConfigPlist];
    NSString *selfClassName = NSStringFromClass([vc class]);
    return [configDict[selfClassName][@"PageIDs"][@"EV"] boolValue];
}

- (BOOL)DDY_pageTimer:(UIViewController *)vc
{
    NSDictionary *configDict = [self DDY_dictionaryFromUserStatisticsConfigPlist];
    NSString *selfClassName = NSStringFromClass([vc class]);
    return [configDict[selfClassName][@"PageIDs"][@"Timer"] boolValue];
}

- (NSString *)DDY_pageID:(UIViewController *)vc
{
    NSDictionary *configDict = [self DDY_dictionaryFromUserStatisticsConfigPlist];
    NSString *selfClassName = NSStringFromClass([vc class]);
    return configDict[selfClassName][@"PageIDs"][@"Enter"];
}

- (NSDictionary *)DDY_dictionaryFromUserStatisticsConfigPlist
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"DDYGlobalPageIDConfig" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    return dic;
}



@end
