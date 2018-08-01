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

@interface UINavigationController(DDYAnalyseNav)
@property (nonatomic, strong) NSDictionary *configurePlist;
@end
@implementation UINavigationController (DDYAnalyseNav)
- (void)setConfigurePlist:(NSDictionary *)configurePlist
{
    objc_setAssociatedObject(self, @selector(configurePlist), configurePlist, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSDictionary *)configurePlist
{
    return objc_getAssociatedObject(self, _cmd);
}

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
    NSString *clickContent = DDYAdditionInstance.DDYContent;
    if (clickContent) {
        [attr setValue:clickContent forKey:DDY_contentKey];
        DDYAdditionInstance.DDYContent = nil;
    }
    
    // 该属性在控制器内部赋值
    NSString *DDYLinkUrl = DDYAdditionInstance.DDYLinkUrl;
    if (DDYLinkUrl) {
        [attr setValue:DDYLinkUrl forKey:DDY_linkurlKey];
        DDYAdditionInstance.DDYLinkUrl = nil;
    }else{
        [attr setValue:[NSString stringWithFormat:@"code://page_id:%@",vc.DDYPageId] forKey:DDY_linkurlKey];
    }
    
    // 该属性在控制器内部赋值
    NSString *DDYExpand = DDYAdditionInstance.DDY_expand;
    if (DDYExpand) {
        [attr setValue:DDYExpand forKey:DDY_linkurlKey];
        DDYAdditionInstance.DDY_expand = nil;
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
    if (!self.configurePlist) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"DDYGlobalPageIDConfig" ofType:@"plist"];
        self.configurePlist = [NSDictionary dictionaryWithContentsOfFile:filePath];
    }
    return self.configurePlist;
}



@end
