前言：大家都知道在安卓上的window 有相关的level，那么iOS上是不是也有相关的level呢？其实是有的只不过iOS的开发不常用而已
先简单说一下UIWindow的几个方法
1. 新建window 方法

    ```
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window = [UIWindow new]; // 如果支持iOS9之前不能使用这个
    ```
这样建立的window 的windowLevel 是 0 hidden 是 YES
2. **makeKeyAndVisible:**

 显示一个UIWindow，同时设置为keyWindow，并将其显示在**_同一windowLevel_**的其它任何UIWindow之上,此时其Hidden会自动变成NO
官方解释 // convenience. most apps call this to show the main window and also make it key. otherwise use view hidden property
``` Objective-C
 [self.window makeKeyAndVisible];
 (lldb) po self.window.windowLevel
    0
 (lldb) po self.window.isKeyWindow
    YES
 (lldb) po self.window.isHidden
    NO
```
3. **keyWindow:**

 设置keyWindow与否并不当前影响视图层级显示，仅来接收键盘及其它非触摸事件。如果没有专门设置过keyWindow的hiden为NO，而且也没有其它非隐藏的UIWindow，那么APP会黑屏
 如果想解除keywindow
 resignKeyWindow
 [[UIApplication sharedApplication] keyWindow]获取正在显示的UIWindow是极其不准确的，下面会有例子解释这个概念
4. **UIWindowLevel:**

    UIWindowLevel（float） 苹果的几个level 注意 在TVOS 上 UIWindowLevelStatusBar 是禁止的
    UIKIT_EXTERN const UIWindowLevel UIWindowLevelNormal;
    UIKIT_EXTERN const UIWindowLevel UIWindowLevelAlert;
    UIKIT_EXTERN const UIWindowLevel UIWindowLevelStatusBar __TVOS_PROHIBITED;
    新的window默认的level是UIWindowLevelNormal 0.0
5. **销毁:**
```
self.window.hidden = YES;
self.window = nil;
```
6. **注意启动app时不要更换window:**
-------注意不要在 - (BOOL)application: didFinishLaunchingWithOptions: 更换window，否则会出现以下错误
*** Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'Application windows are expected to have a root view controller at the end of application launch'
#实战
1. 在view 上建立按钮
  ```
     - (void)viewDidLoad {
        [super viewDidLoad];
        self.view.backgroundColor = [UIColor orangeColor];
        
        NSLog(@"windows%@",[UIApplication sharedApplication].windows);
        for (UIWindow * wind in [UIApplication sharedApplication].windows) {
            NSLog(@"%s windows =  %@ ---windowLevel= %f",__FUNCTION__,wind,wind.windowLevel);
        }
        // 创建测试按钮
        UIButton *tempBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        tempBtn.frame = CGRectMake(44,44,200,100);
        [tempBtn setTitle:@"创建一个NormalWindow" forState:UIControlStateNormal];
        [tempBtn addTarget:self action:@selector(NormalWindow) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:tempBtn];
        // 显示window 的信息
        
        UILabel * label = [[UILabel alloc]init];
        label.text = [NSString stringWithFormat:@"%s windows =  %@ ---windowLevel= %f",__FUNCTION__,[UIApplication sharedApplication].keyWindow,[UIApplication sharedApplication].keyWindow.windowLevel];
        label.numberOfLines = 0;//表示label可以多行显示
        label.textColor = [UIColor blackColor];
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
        CGSize labelSize = [label.text boundingRectWithSize:CGSizeMake(200, 5000) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        label.font = [UIFont systemFontOfSize:14];
        label.frame = (CGRect){{50,200},labelSize};
        [self.view addSubview:label]; 
}
```
   ![log1.png](https://upload-images.jianshu.io/upload_images/15063932-c8e5c60d64652ffa.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
![png1.PNG](https://upload-images.jianshu.io/upload_images/15063932-3eeed9186793aacf.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

2. 创建一个window 默认使用UIWindowLevelNormal 0.0 系统默认的keyWindow 的windowLevel 是 Normal 那么 要优先显示创建的windowLevel 必须大于等于Normal 才会展示在上层。
创建 window 不用添加到任何的控件上面，直接创建完毕 即自动添加到window 上
``` Objective-C
     - (void)NormalWindow
    {
        UIWindow * testWindows  =  [UIWindow new]; // 以后 默认了 window的大小
        _myWindow1 = testWindows;
        testWindows.hidden = NO;
        self.myWindow1.backgroundColor = [UIColor yellowColor];
        UIButton *windowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [windowBtn setTitle:@"创建一个StatusBarwindow" forState:UIControlStateNormal];
        windowBtn.backgroundColor = [UIColor redColor];
        windowBtn.frame = CGRectMake(44,44,200,100);;
        [windowBtn addTarget:self action:@selector(StatusBarwindow) forControlEvents:UIControlEventTouchUpInside];
        [self.myWindow1 addSubview:windowBtn];
        
        
        
        UILabel * label = [[UILabel alloc]init];
        label.text = [NSString stringWithFormat:@"%s windows =  %@ ---windowLevel= %f",__FUNCTION__,testWindows,testWindows.windowLevel];
        label.numberOfLines = 0;//表示label可以多行显示
        label.textColor = [UIColor blackColor];
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
        CGSize labelSize = [label.text boundingRectWithSize:CGSizeMake(200, 5000) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        label.font = [UIFont systemFontOfSize:14];
        label.frame = (CGRect){{50,200},labelSize};
        [testWindows addSubview:label];
        
        for (UIWindow * wind in [UIApplication sharedApplication].windows) {
            NSLog(@"%s windows =  %@ ---windowLevel= %f",__FUNCTION__,wind,wind.windowLevel);
        }
    }
```

![log2.png](https://upload-images.jianshu.io/upload_images/15063932-97a69a452c47cbda.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


通过log 可以发现新的window 追加在了数组后面 **0x10060be90** level 0.0 (新建的normal window)
![pn2.PNG](https://upload-images.jianshu.io/upload_images/15063932-d3fc347180dc7e59.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)



在normal上新建一个statusBar 的window
```
- (void)StatusBarwindow
{
    //window 销毁
    //    self.myWindow1.hidden = YES; //可有可无 看 UI效果
    //    self.myWindow1 = nil; // 这个方法是真正移除 UIWindow
    UIWindow * testWindows = [UIWindow new];
    //    [testWindows makeKeyAndVisible];
    testWindows.backgroundColor = [UIColor blueColor];
    // 设置 window 的 windowLevel
    testWindows.windowLevel = UIWindowLevelStatusBar; //TODO: Normal，StatusBar，Alert 分别 为 0，1000，2000 可以修改这里体验 层级变化 对 展示 window的影响
    testWindows.hidden = NO;
    self.myWindow2 = testWindows;
    UIButton *windowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [windowBtn setTitle:@"StatusBarNewNorWindow" forState:UIControlStateNormal];
    windowBtn.backgroundColor = [UIColor redColor];
    windowBtn.frame = CGRectMake(15, 90, self.view.frame.size.width - 15 * 2, 64);
    [windowBtn addTarget:self action:@selector(StatusBarNewNorWindow) forControlEvents:UIControlEventTouchUpInside];
    [testWindows addSubview:windowBtn];
    // 显示window 的信息
    
    UILabel * label = [[UILabel alloc]init];
    label.text = [NSString stringWithFormat:@"%s windows =  %@ ---windowLevel= %f",__FUNCTION__,testWindows,testWindows.windowLevel];
    label.numberOfLines = 0;//表示label可以多行显示
    label.textColor = [UIColor blackColor];
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    CGSize labelSize = [label.text boundingRectWithSize:CGSizeMake(200, 5000) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    label.font = [UIFont systemFontOfSize:14];
    label.frame = (CGRect){{50,200},labelSize};
    [testWindows addSubview:label];
    
    
    for (UIWindow * wind in [UIApplication sharedApplication].windows) {
        NSLog(@"%s windows =  %@ ---windowLevel= %f",__FUNCTION__,wind,wind.windowLevel);
    }
    
}
```
![log3.png](https://upload-images.jianshu.io/upload_images/15063932-43a8243d0f7eaf1c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


通过log 可以发现新的window 追加在了数组后面 **0x100320be0**（level 1000.0） 现在数组中是4个数据 
![pn3.PNG](https://upload-images.jianshu.io/upload_images/15063932-b6157a28b3fb4803.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


那么如果接下来增加一个 level 是normal的window 如何

```
- (void)StatusBarNewNorWindow
{
    //window 销毁
    //    self.myWindow1.hidden = YES; //可有可无 看 UI效果
    //    self.myWindow1 = nil; // 这个方法是真正移除 UIWindow
    UIWindow * testWindows = [UIWindow new];
    //    [testWindows makeKeyAndVisible];
    testWindows.backgroundColor = [UIColor blueColor];
    // 设置 window 的 windowLevel
    testWindows.windowLevel = UIWindowLevelNormal; //TODO: Normal，StatusBar，Alert 分别 为 0，1000，2000 可以修改这里体验 层级变化 对 展示 window的影响
    testWindows.hidden = NO;
    self.myWindow3 = testWindows;
    UIButton *windowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [windowBtn setTitle:@"UIWindowLevelAlert" forState:UIControlStateNormal];
    windowBtn.backgroundColor = [UIColor redColor];
    windowBtn.frame = CGRectMake(15, 90, self.view.frame.size.width - 15 * 2, 64);
    [windowBtn addTarget:self action:@selector(UIWindowLevelAlert) forControlEvents:UIControlEventTouchUpInside];
    [testWindows addSubview:windowBtn];
    // 显示window 的信息
    
    UILabel * label = [[UILabel alloc]init];
    label.text = [NSString stringWithFormat:@"%s windows =  %@ ---windowLevel= %f",__FUNCTION__,testWindows,testWindows.windowLevel];
    label.numberOfLines = 0;//表示label可以多行显示
    label.textColor = [UIColor blackColor];
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    CGSize labelSize = [label.text boundingRectWithSize:CGSizeMake(200, 5000) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    label.font = [UIFont systemFontOfSize:14];
    label.frame = (CGRect){{50,200},labelSize};
    [testWindows addSubview:label];
    
    
    for (UIWindow * wind in [UIApplication sharedApplication].windows) {
        NSLog(@"%s windows =  %@ ---windowLevel= %f",__FUNCTION__,wind,wind.windowLevel);
    }
    
}
```
![log4.png](https://upload-images.jianshu.io/upload_images/15063932-20e00e0b64665b42.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

通过log 可以发现新的window 追加在了数组多了一个**0x10031fd10**（level 0.0） 并且是追加在了**0x10060be90** level 0.0  后面 但是最后打印的依旧是 **0x100320be0** ，由此可见，要优先显示创建的windowLevel 必须大于等于当前的level才会展示在上层。

**注意**
以上的keyWindow都是 **0x1003093f0 **如下图
![keyWindow.png](https://upload-images.jianshu.io/upload_images/15063932-648b62b1675ce831.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


**结论**
  1. 创建 window 不用添加到任何的控件上面，直接创建完毕 即自动添加到window 上

  2.创建一个window 默认使用UIWindowLevelNormal 0.0 系统默认的keyWindow 的windowLevel 是 Normal 那么 要优先显示创建的windowLevel 必须大于等于当前的window level 才会展示在上层。
