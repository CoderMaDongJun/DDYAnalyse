//
//  UIControl+DDYAnalyse.m
//  DDYAnalyse
//
//  Created by 马栋军 on 2018/5/15.
//

#import "UIControl+DDYAnalyse.h"
#import <objc/runtime.h>
#import "DDYHookUtility.h"
#import "DDYClick.h"

@implementation UIControl (DDYAnalyse)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSelector = @selector(sendAction:to:forEvent:);
        SEL swizzledSelector = @selector(DDYSwiz_sendAction:to:forEvent:);
        [DDYHookUtility DDY_swizzlingInClass:[self class] originalSelector:originalSelector swizzledSelector:swizzledSelector];
    });
}

#pragma mark - Method Swizzling
- (void)DDYSwiz_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event;
{
    [self DDYSwiz_sendAction:action to:target forEvent:event];
    //插入埋点代码
    [self DDY_performUserStastisticsAction:action to:target forEvent:event];
}

- (void)DDY_performUserStastisticsAction:(SEL)action to:(id)target forEvent:(UIEvent *)event;
{
    NSLog(@"\n***hook success.\n[1]action:%@\n[2]target:%@ \n[3]event:%ld", NSStringFromSelector(action), target, (long)event);
    NSString *actionString = NSStringFromSelector(action);
    NSDictionary *configDict = [self DDY_dictionaryFromUserStatisticsConfigPlist];
    NSString *eventID = configDict[actionString][@"EventId"];
    self.DDYLinkUrl = configDict[actionString][@"LinkUrl"];
    self.DDYContent = configDict[actionString][@"Content"];
    
    if (eventID) {
        NSMutableDictionary *attr = [NSMutableDictionary dictionary];
        if ([target isKindOfClass:[UIViewController class]]) {
            UIViewController *vc = target;
            attr = [self DDY_buttonAttrs:vc];
            
        }else if([target isKindOfClass:[UIView class]]){
            UIViewController *vc = [self findMineSuperViewController];
            attr = [self DDY_buttonAttrs:vc];
        }
        NSLog(@"button attr:%@",attr);
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
    if (vc.DDYPrePid) {
        [attr setValue:vc.DDYPrePid forKey:DDY_prePidKey];
    }
    if (self.DDYLinkUrl) {
        [attr setValue:self.DDYLinkUrl forKey:DDY_linkurlKey];
    }
    if (self.DDYContent) {
        [attr setValue:self.DDYContent forKey:DDY_contentKey];
    }
    if (self.DDYExpand) {
        [attr setValue:self.DDYExpand forKey:DDY_expandKey];
    }
    if (self.DDYLinkUrl) {
        [attr setValue:self.DDYLinkUrl forKey:DDY_linkurlKey];
    }
    if (self.DDYContent) {
        [attr setValue:self.DDYContent forKey:DDY_contentKey];
    }
    if (self.DDYExpand) {
        [attr setValue:self.DDYExpand forKey:DDY_expandKey];
    }
    return attr;
}

- (NSDictionary *)DDY_dictionaryFromUserStatisticsConfigPlist
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"DDYGlobalEventIDConfig" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    return dic;
}

- (UIViewController*)findMineSuperViewController
{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

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

- (void)setDDYExpand:(NSString *)DDYExpand
{
   objc_setAssociatedObject(self, @selector(DDYExpand), DDYExpand, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)DDYExpand
{
   return objc_getAssociatedObject(self, _cmd);
}
@end
