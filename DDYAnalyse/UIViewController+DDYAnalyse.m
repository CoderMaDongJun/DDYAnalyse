//
//  UIViewController+DDYAnalyse.m
//  DDYAnalyse
//
//  Created by 马栋军 on 2018/5/14.
//

#import "UIViewController+DDYAnalyse.h"
#import <objc/runtime.h>
#import "DDYHookUtility.h"
#import "DDYClick.h"

@implementation UIViewController (DDYAnalyse)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSelector1 = @selector(viewWillAppear:);
        SEL swizzledSelector1 = @selector(DDY_swizViewWillAppear:);
        [DDYHookUtility DDY_swizzlingInClass:[self class] originalSelector:originalSelector1 swizzledSelector:swizzledSelector1];
        
        SEL originalSelector2 = @selector(viewWillDisappear:);
        SEL swizzledSelector2 = @selector(DDY_swizViewWillDisappear:);
        [DDYHookUtility DDY_swizzlingInClass:[self class] originalSelector:originalSelector2 swizzledSelector:swizzledSelector2];
    });
}

#pragma mark - Method Swizzling
- (void)DDY_swizViewWillAppear:(BOOL)animated
{
    [self DDY_injectViewWillAppear];
    
    [self DDY_swizViewWillAppear:animated];
}

- (void)DDY_swizViewWillDisappear:(BOOL)animated
{
    [self DDY_injectViewWillDisappear];
    
    [self DDY_swizViewWillDisappear:animated];
}

#pragma mark - 利用hook统计所有页面的时长
- (void)DDY_injectViewWillAppear
{
    // 是否需要计时
    if (self.DDYTimer) {
        NSString *pageId = self.DDYPageId;
        [DDYClick DDY_beginLogPageView:pageId];
    }
    
    // 是否需要统计曝光
    if (self.DDYEV) {
        [DDYClick DDY_exposureFromPage:self.DDYPageId attributes:[self DDY_attributes]];
    }
}

- (void)DDY_injectViewWillDisappear
{
    // 是否需要计时
    if (self.DDYTimer) {
        [DDYClick DDY_endLogPageView:self.DDYPageId attributes:[self DDY_attributes]];
    }
}

- (NSMutableDictionary *)DDY_attributes
{
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    if (self.DDYPid) {
        [attr setValue:[NSString stringWithFormat:@"pid=%@",self.DDYPid] forKey:DDY_pidKey];
    }
    
    if (self.DDYPrePageId) {
        [attr setValue:self.DDYPrePageId forKey:DDY_prePageIdKey];
    }
    
    if (self.DDYPrePid) {
        [attr setValue:self.DDYPrePid forKey:DDY_prePidKey];
    }
    return attr;
}

#pragma mark - 属性
- (void)setDDYPageId:(NSString *)DDYPageId
{
    objc_setAssociatedObject(self, @selector(DDYPageId), DDYPageId, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)DDYPageId
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setDDYPid:(NSString *)DDYPid
{
    objc_setAssociatedObject(self, @selector(DDYPid), DDYPid, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)DDYPid
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setDDYPrePageId:(NSString *)DDYPrePageId
{
    objc_setAssociatedObject(self, @selector(DDYPrePageId), DDYPrePageId, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)DDYPrePageId
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setDDYPrePid:(NSString *)DDYPrePid
{
    objc_setAssociatedObject(self, @selector(DDYPrePid), DDYPrePid, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)DDYPrePid
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setDDYTimer:(BOOL)DDYTimer
{
    objc_setAssociatedObject(self, @selector(DDYTimer), [NSNumber numberWithBool:DDYTimer], OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)DDYTimer
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setDDYEV:(BOOL)DDYEV
{
    objc_setAssociatedObject(self, @selector(DDYEV), [NSNumber numberWithBool:DDYEV], OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)DDYEV
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
@end

