//
//  UIViewController+DDYViewController.m
//  DDYanalyseDemo
//
//  Created by 马栋军 on 2018/3/23.
//  Copyright © 2018年 马栋军. All rights reserved.
//

#import "UIViewController+DDYViewController.h"
#import <objc/runtime.h>

@implementation UIViewController (DDYViewController)

+(void)load
{
    [UIViewController swizzleInstanceMethod:@selector(viewDidLoad) withOverrideMethod:@selector(DDY_viewDidLoad)];
    
}

-(void)DDY_viewDidLoad
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, 260, 40)];
    label.text = @"Touch me to jump next page!";
    label.textColor = [UIColor whiteColor];
    [self.view addSubview:label];
    
     [self DDY_viewDidLoad];
}

+ (void)swizzleInstanceMethod:(SEL)originalSelector
           withOverrideMethod:(SEL)overrideSelector
{
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    
    NSAssert( originalMethod != NULL,
             @"Original method -[%@ %@] does not exist.",
             NSStringFromClass(self),
             NSStringFromSelector(originalSelector) );
    
    Method overrideMethod = class_getInstanceMethod(self, overrideSelector);
    NSAssert( overrideMethod != NULL,
             @"Override method -[%@ %@] does not exist.",
             NSStringFromClass(self),
             NSStringFromSelector(overrideSelector) );
    
    if (originalMethod == overrideMethod) return;
    
    class_addMethod( self,
                    originalSelector,
                    class_getMethodImplementation(self, originalSelector),
                    method_getTypeEncoding(originalMethod) );
    class_addMethod( self,
                    overrideSelector,
                    class_getMethodImplementation(self, overrideSelector),
                    method_getTypeEncoding(overrideMethod) );
    
    method_exchangeImplementations( class_getInstanceMethod(self, originalSelector),
                                   class_getInstanceMethod(self, overrideSelector) );
} 

@end
