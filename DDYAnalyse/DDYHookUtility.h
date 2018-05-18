//
//  DDYHookUtility.h
//  DDYAnalyse
//
//  Created by 马栋军 on 2018/5/14.
//

#import <Foundation/Foundation.h>

@interface DDYHookUtility : NSObject
+ (void)DDY_swizzlingInClass:(Class)cls originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector;
@end
