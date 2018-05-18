//
//  UIControl+DDYAnalyse.h
//  DDYAnalyse
//
//  Created by 马栋军 on 2018/5/15.
//  点击事件统计，扩展的属性，在按钮响应的地方传入即可，可不传。凡是需要统计的方法，都需要在plist表内相应的页面下，按格式将方法写入

#import <UIKit/UIKit.h>

@interface UIControl (DDYAnalyse)
/** 去向url，在点击事件内添加，如：sender.linkUrl = @"lingkurl";*/
@property (nonatomic ,copy) NSString *DDYLinkUrl;
/** 点击内容，在点击事件内添加，如：sender.content = @"content";*/
@property (nonatomic ,copy) NSString *DDYContent;
/** 扩展保留，在点击事件内添加，如：sender.expand = @"expand";*/
@property (nonatomic ,copy) NSString *DDYExpand;
@end
