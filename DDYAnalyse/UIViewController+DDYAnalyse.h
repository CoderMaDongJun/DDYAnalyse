//
//  UIViewController+DDYAnalyse.h
//  DDYAnalyse
//
//  Created by 马栋军 on 2018/5/14.
//  页面曝光统次数、时长统计，DDYPageId、DDYTimer、DDYEV需要plist配置，DDYPid需要页面的Viewdidload内配置

#import <UIKit/UIKit.h>

@interface UIViewController (DDYAnalyse)
/** required，DDYGlobalPageIDConfig.plist内配置后，内部自动赋值 */
@property (nonatomic ,copy) NSString *DDYPageId;
/** required,计时,DDYGlobalPageIDConfig.plist内配置后，内部自动赋值 */
@property (nonatomic ,assign) BOOL DDYTimer;
/** required,曝光,DDYGlobalPageIDConfig.plist内配置后，内部自动赋值 */
@property (nonatomic ,assign) BOOL DDYEV;
/** optional，若需要，去该页面将属性赋值即可,如：self.DDYPid = @"xxx" */
@property (nonatomic ,copy) NSString *DDYPid;
/** optional，内部自动赋值 */
@property (nonatomic ,copy) NSString *DDYPrePageId;
/** optional，内部自动赋值 */
@property (nonatomic ,copy) NSString *DDYPrePid;
@end
