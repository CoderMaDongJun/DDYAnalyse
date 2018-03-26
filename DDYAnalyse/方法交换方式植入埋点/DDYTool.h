//
//  DDYTool.h
//  DDYAnalyse
//
//  Created by 马栋军 on 2018/3/23.
//

#import <Foundation/Foundation.h>

@interface DDYTool : NSObject
+ (void)DDY_swizzlingInClass:(Class)cls originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector;
@end
