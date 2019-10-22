# 关于iOS weakify 和 strongify 的解释


``` Objective-C
//强弱类型转换
#ifndef    weakify
#if __has_feature(objc_arc)

#define weakify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
autoreleasepool{} __weak __typeof__(x) __weak_##x##__ = x; \
_Pragma("clang diagnostic pop")

#else

#define weakify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
autoreleasepool{} __block __typeof__(x) __block_##x##__ = x; \
_Pragma("clang diagnostic pop")

#endif
#endif

#ifndef    strongify
#if __has_feature(objc_arc)

#define strongify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
try{} @finally{} __typeof__(x) x = __weak_##x##__; \
_Pragma("clang diagnostic pop")

#else

#define strongify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
try{} @finally{} __typeof__(x) x = __block_##x##__; \
_Pragma("clang diagnostic pop")

#endif
#endif
```

进行相关的解释说明
__has_feature：某些特性验证 
例如
```Objective-C
#if !__has_feature(objc_arc)
#error This library requires automatic reference counting
#endif
```
__has_feature(objc_arc) 如果使用的arc（区别于MRC）
_Pragma 与  #pragma
//#pragma 预处理指令

在C/C++标准中，#pragma是一条预处理的指令（preprocessor directive）。简单地说，#pragma是用来向编译器传达语言标准以外的一些信息。

iOS 中常用这用来进行屏蔽警告 ⚠️

例如 1. 屏蔽方法废弃警告
``` Objective-C 
#pragma clang diagnostic push  
#pragma clang diagnostic ignored "-Wdeprecated-declarations"      
[TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];  
#pragma clang diagnostic pop
```
2. 屏蔽空指针的相关操作
``` Objective-C 
#pragma clang diagnostic push   
#pragma clang diagnostic ignored "-Wincompatible-pointer-types"  
   //  进行代码的编写 
#pragma clang diagnostic pop
```
3. 屏蔽循环引用的相关操作
```Objective-C 
// completionBlock is manually nilled out in AFURLConnectionOperation to break the retain cycle.  
#pragma clang diagnostic push  
#pragma clang diagnostic ignored "-Warc-retain-cycles" 
    self.completionBlock = ^ {  
        ...  
    };  
#pragma clang diagnostic pop
```
4. 屏蔽未使用变量警告
```Objective-C 
#pragma clang diagnostic push   
#pragma clang diagnostic ignored "-Wunused-variable"  
    int a;   
#pragma clang diagnostic pop
```

_Pragma操作符

_Pragma操作符，该操作符具有与 #pragma 指令相同的功能

_Pragma(token-string)

相比预处理指令#pragma,_Pragma操作符可用于宏定义中的内联。 #pragma 指令不能用于宏定义中，因为编译器会将指令中的数字符号（“#”）解释为字符串化运算符 (#)。，由于_Pragma是一个操作符，因此可以用在一些宏中,我们可以看看下面这个例子：

在适配不同版本系统的适合，为了避免废弃API的警告,一般我们都使用#pragma clang diagnostic ignored "-Wunused-variable"来屏蔽警告：

``` Objective-C 
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
//code
#pragma clang diagnostic pop

```

消除警告
```Objective-C
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"")
```

```Objective-C
autoreleasepool{} __weak __typeof__(x) __weak_##x##__ = x; 
```
目的为了加@符号，如果不加@符号则会报如下错误
![Screen Shot 2018-11-28 at 10.11.32 PM.png](https://upload-images.jianshu.io/upload_images/10160974-b19b49456771cd66.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
``` Objective-C
try{} @finally{} __typeof__(x) x = __block_##x##__;
```
目的同上为了加@符号，如果不加@符号则会报如下错误

![Screen Shot 2018-11-28 at 10.12.03 PM.png](https://upload-images.jianshu.io/upload_images/10160974-38da5908255c40f4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


