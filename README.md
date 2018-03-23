# DDYAnalyse SDK
简单易用的埋点SDK
初始化项目，在AppDelegate.m内
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions方法内添加以下任一发送策略的代码即可
## 初始化
### 1.发送策略：DDYDefault
``` objc
    [DDYClick DDY_startWithConfigure:DDYConfigInstance];
```
### 2.发送策略：DDYSend_Interval
``` objc
    DDYConfigInstance.ePolicy = DDYSend_Interval;
    [DDYClick DDY_setLogSendInterval:90];
    [DDYClick DDY_startWithConfigure:DDYConfigInstance];
```
### 3.发送策略：DDYSend_Count
``` objc
    DDYConfigInstance.ePolicy = DDYSend_Count;
    [DDYClick DDY_startWithConfigure:DDYConfigInstance];
```
## 页面计时事件
### 1.页面开始计时的地方
``` objc
    - (void)viewWillAppear:(BOOL)animated
    {
        [super viewWillAppear:animated];
        
        [DDYClick DDY_beginLogPageView:@"page_id_4001"];
    }
```
### 2.页面计时结束的地方
#### attributes根据自己的埋点规则可自定义，也可为nil
``` objc
    - (void)viewWillDisappear:(BOOL)animated
    {
        [super viewWillDisappear:animated];
    
        [DDYClick DDY_endLogPageView:@"page_id_4001" attributes:@{DDY_pidKey:@"pid=1"
        ,DDY_permanent_idKey:@"API_id"
        }];
    }
```
## 页面点击事件
### attributes根据自己的埋点规则可自定义，也可为nil
``` objc
    [DDYClick DDY_event:@"eventId_4002" attributes:@{DDY_pageIdKey:@"pageId_1003"
    ,DDY_pidKey:@"pid=2378"
    ,DDY_linkurlKey:@"product://pid=40082"
    ,DDY_contentKey:@"floor=xxx#tab=xxx"
    ,DDY_expandKey:@"(1002||||floor=B版主题馆1-1)(||||)(||||)"
    ,DDY_permanent_idKey:@"API_id"
    }];
```
