# DDYAnalyse SDK
简单易用的埋点SDK
初始化项目，在AppDelegate.m内
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions方法内添加以下任一发送策略的代码即可
## 初始化
### 1.发送策略：DDYDefault
``` objc
    DDYConfigInstance.udId = @"UDID";
    [DDYClick DDY_startWithConfigure:DDYConfigInstance];
```
### 2.发送策略：DDYSend_Interval
``` objc
    DDYConfigInstance.udId = @"UDID";
    DDYConfigInstance.ePolicy = DDYSend_Interval;
    [DDYClick DDY_setLogSendInterval:90];
    [DDYClick DDY_startWithConfigure:DDYConfigInstance];
```
### 3.发送策略：DDYSend_Count
``` objc
    DDYConfigInstance.udId = @"UDID";
    DDYConfigInstance.ePolicy = DDYSend_Count;
    [DDYClick DDY_startWithConfigure:DDYConfigInstance];
```
## 页面计时事件
### 1.页面开始计时的地方
``` objc
    - (void)viewWillAppear:(BOOL)animated
    {
        [super viewWillAppear:animated];
        
        [DDYClick DDY_beginLogPageView:@"pageId"];
    }
```
### 2.页面计时结束的地方
#### attributes根据自己的埋点规则可自定义，也可为nil
``` objc
    - (void)viewWillDisappear:(BOOL)animated
    {
        [super viewWillDisappear:animated];
    
        [DDYClick DDY_endLogPageView:@"pageId" attributes:@{DDY_pidKey:@"pid=1"
        ,DDY_permanent_idKey:@"API_id"
        }];
    }
```
## 页面点击事件
#### attributes根据自己的埋点规则可自定义，也可为nil
``` objc
[DDYClick DDY_event:@"eventId_4002" attributes:@{
DDY_pageIdKey:@"pageId_1003",
DDY_pidKey:@"pid=2378",
DDY_linkurlKey:@"product://pid=40082",
DDY_contentKey:@"floor=xxx#tab=xxx",
DDY_expandKey:@"(1002||||floor=B版主题馆1-1)(||||)(||||)"
}];
```

## 使用情况举例
### DDYGlobalPageIDConfig.plist 内的数据结构解析:
1、name:页面名称
2、EventIDs:进入该页面的点击事件统称，如有n个按钮点击都进入目标页面，那么n个按钮的点击事件都为该值
3、PageIDs 下有3个字段，Enter代表目标页面pageId，EV代表目标页面是否需要曝光，Timer代表目标页面是否需要曝光计时

### 点击事件解析
##### 情况1 单个按钮点击有push操作触发：若push到B页面，将B页面的名称按格式写入DDYGlobalPageIDConfig.plist即可完成该点击事件统计
##### 情况2 多个按钮点击有push操作触发：若push到B页面，将B页面的名称按格式写入DDYGlobalPageIDConfig.plist即可完成多个点击事件统计，此时统计不能区分来源是哪个按钮点击。要想区分来源，在该按钮点击处加入```DDYAdditionInstance.DDYContent=@"点击来源说明" ```，即可完成来源区分。
##### 情况3 按钮点击无push操作触发：只是文字、颜色、enable等的改变，那么在点击处调用``` + (void)DDY_event:(nonnull NSString *)eventId attributes:(nullable NSDictionary *)attributes```完成参数(参数见方法注释)传入， 即可完成该点击事件统计

### 曝光事件解析
##### 情况1 页面曝光：将需要曝光统计的页面的名称，按格式写入DDYGlobalPageIDConfig.plist即可完成统计
##### 情况2 模块曝光：在触发模块曝光的位置调用```+ (void)DDY_exposureFromPage:(nonnull NSString *)pageId attributes:(nullable NSDictionary *)attributes;``` ，完成参数(参数见方法注释)传入，即可完成模块曝光统计

### 页面计时事件解析
##### 情况1 页面计时：将需要计时统计的页面的名称，按格式写入DDYGlobalPageIDConfig.plist即可完成统计
##### 情况2 模块计时：在触发模块的位置先调用```+ (void)DDY_beginLogPageView:(nonnull NSString *)pageId;``` ，在模块退出的位置调用```+ (void)DDY_endLogPageView:(nonnull NSString *)pageId attributes:(nullable NSDictionary *)attributes;```，完成参数(参数见方法注释)传入，即可完成模块计时统计

### 常见问题
1、页面用pageId即可完成唯一标识.
2、事件用eventId即可完成唯一标识.
3、content 用于补充前两者的标识.
4、expand 保留字段.
5、标识用 Excel 记录,传给大数据同事.
如：
页面        埋点           埋点类型        PageId        EventId        备注
单品页    单品页        曝光              1138            8001138       floor = "按钮1点击"
单品页    购买按钮    点击               1139            8001139

