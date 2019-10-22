# iOS 上使用jsBridge的方法
```
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="ie=edge">
  <title>Document</title>
</head>

<body>
  <button onclick="jsFunc()">打开相册按钮</button> <button onclick="jsFunc1()">获取版本号</button>
  <script>
        function jsFunc() {
         alert('返回参数' + common("openCamera","1234567"))
      };
  function jsFunc1() {
      alert('返回参数' + common("getCode"))
  };
  function common (){
      var args = Array.prototype.slice.call(arguments);
      alert(args);
      var type = "JSbridge";
      var payload = { "type": type, "arguments": args };
      return prompt(JSON.stringify(payload));
  };


  </script>
</body>

</html>
```

iOS 代码实现 
```
#include <objc/objc.h>
#include <objc/runtime.h>
#include <objc/message.h>

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    NSError *err = nil;
    NSData *dataFromString = [prompt dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *payload = [NSJSONSerialization JSONObjectWithData:dataFromString options:NSJSONReadingMutableContainers error:&err];
    if (!err)
    {
        NSString *type = [payload objectForKey:@"type"];
        if (type && [type isEqualToString:@"JSbridge"])
        {
            NSString *returnValue = @"";
            NSArray *args = [payload objectForKey:@"arguments"];
            if (args.count < 1) {
                completionHandler(returnValue);
                return;
            }
            NSString * functionName = [args firstObject];
            NSMutableArray * newArrayArgs = [[NSMutableArray alloc]initWithArray:args];
            [newArrayArgs removeObjectAtIndex:0];
            SEL sel = newArrayArgs.count < 1 ? NSSelectorFromString(functionName) : NSSelectorFromString([NSString stringWithFormat:@"%@:",functionName]);
            if ([self respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                returnValue = [self performSelector:sel withObject:newArrayArgs];
#pragma clang diagnostic pop
                if(![returnValue isKindOfClass:[NSString class]])
                {
                    returnValue = @"";
                }
            }

            completionHandler(returnValue);
        }
    }
}



- (NSString *)getAppVersion {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return app_Version;
}



-(void)openCamera:(NSArray *)argsArray{
    if (argsArray.count > 0) {
        NSString *orderId = argsArray[0];
        // 打开相机
     }
}
```
这上面注意点
1.  var type = "JSbridge"; 是web 和 app上确定好的协议
2.  web 传递的数据是[方法名，参数1，参数2，...]
3.  通过方法名字生成方法 sel
4.  通过是否有参数来确定使用那种sel，如果有参数那么需要使用带参数的sel，否则使用没有参数的sel
5. 通过 performSelector 来执行sel，注意在func没有返回值的时候，那么performSelector返回的就是参数，需要特殊处理一下
6. 走过的弯路 
```
    Method method = class_getInstanceMethod([self class], sel);
    
    const char *types = method_getTypeEncoding(method);
    NSLog(@"--------  %@",[NSString stringWithUTF8String: types]);
//    v为 void , i 为 int , f为float
//
//    ? 为 block ( void(^)(void) )
//
//    开头带v16 v32表示无返回值，其他带什么表示返回值为什么类型；
//
//    :8 是 SEL标示
//
//    @28 返回值为 NSString, @16代表参数为 NSString，
//
//    @24 返回值为id,
// 通过types来确定返回值是什么
returnValue =  ((NSString* (*) (id,SEL))objc_msgSend)(self,sel);
((void (*) (id,SEL))objc_msgSend)(self,sel);
returnValue =  ((NSString * (*) (id,SEL,id))objc_msgSend)(self,sel,newArrayArgs);

真心的不建议用 objc_msgSend 因为如果要用这个需要更改编译器，这样编译器就不检测类型了，对app 对安全是一个重大的曲线


```
![image.png](https://upload-images.jianshu.io/upload_images/15063932-f35707914e4264de.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)



![image.png](https://upload-images.jianshu.io/upload_images/15063932-9ec4e398592f0248.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
