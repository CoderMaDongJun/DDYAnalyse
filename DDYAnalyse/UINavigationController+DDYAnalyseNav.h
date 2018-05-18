//
//  UINavigationController+DDYAnalyseNav.h
//  DDYAnalyse
//
//  Created by 马栋军 on 2018/5/14.
//  使用方式：[DDRoute route].DDYContent = @"xxx"、self.navigationController.DDYContent = @"xxx"

#import <UIKit/UIKit.h>

@interface NSObject (DDYAnalyse)
/** optional，若需要，去该页面将属性赋值即可 */
@property (nonatomic ,copy) NSString *DDYContent;
/** optional，若需要，去该页面将属性赋值即可 */
@property (nonatomic ,copy) NSString *DDYLinkUrl;
@end

@interface UINavigationController (DDYAnalyseNav)
@end
