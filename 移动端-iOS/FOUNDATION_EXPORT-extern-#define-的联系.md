# FOUNDATION_EXPORT extern #define
```
FOUNDATION_EXPORT NSRunLoopMode const NSDefaultRunLoopMode;
FOUNDATION_EXPORT NSRunLoopMode const NSRunLoopCommonModes API_AVAILABLE(macos(10.5), ios(2.0), watchos(2.0), tvos(9.0));
```

以上便是在NSRunLoop里面的定义

那么FOUNDATION_EXPORT 是一个什么一个函数呢 

进入 FOUNDATION_EXPORT 定义发现使用的是 define  
```
 #define FOUNDATION_EXPORT  FOUNDATION_EXTERN
```
而 FOUNDATION_EXTERN 是如下
```
 #define FOUNDATION_EXTERN extern
```
而 extern 在c语言中就是声明的意思

1、函数的声明extern关键词是可有可无的，因为函数本身不加修饰的话就是extern。但是引用的时候一样需要声明的。
2、全局变量在外部使用声明时，extern关键字是必须的，如果变量没有extern修饰且没有显式的初始化，同样成为变量的定义，因此此时必须加extern，而编译器在此标记存储空间在执行时加载内并初始化为0。而局部变量的声明不能有extern的修饰，且局部变量在运行时才在堆栈部分分配内存。
3、全局变量或函数本质上讲没有区别，函数名是指向函数二进制块开头处的指针。而全局变量是在函数外部声明的变量。函数名也在函数外，因此函数也是全局的。
4、谨记：声明可以多次，定义只能一次
那么上面的方法最根本的意义就是

```
ctr.h
typedef NSString * NSRunLoopModeUser; // 为  NSString * 取别名
extern  NSRunLoopModeUser const NSDefaultRunLoopModeUser;
extern  NSRunLoopModeUser const NSRunLoopCommonModesUser;

ctr.m
NSString * const NSDefaultRunLoopModeUser = @"NSDefaultRunLoopModeUser";
NSString * const NSRunLoopCommonModesUser = @"NSRunLoopCommonModesUser";
```
另一种就是常用的#define 方法定义常量了
例如
```
#define collectionCellID @"collectionCell"
```
#**那么他们有什么区别呢?**
```
[使用FOUNDATION_EXPORT方法在检测字符串的值是否相等的时候效率更快.
可以直接使用(str == NSRunLoopModeUser)来比较, 而define则使用的是([str isEqualToString:collectionCellID])
哪个效率更高,显而易见了
第一种是直接比较指针地址
第二种则是一一比较字符串的每一个字符是否相等.]
```
这是网上说法，所以本人进行了一下求真
![求真.png](https://upload-images.jianshu.io/upload_images/15063932-733869814bd8ca69.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

真的不敢恭维啊，现在在Xcode 都开始警告，那么我个人感觉两者是一样的，即使是网上的说法您敢用吗？
Direct comparison of a string literal has undefined behavior
== ：比较的是指针指向的地址，OC中的对象都是用指针表示的，但在这里并不能保证collectionCellID与"collectionCellID"相等


isEqual：NSObject方法，官方文档是这样写的
```
Returns a Boolean value that indicates whether the receiver and a given object are equal.
返回一个bool值判断两个对象是否相等
```
如果两个对象是相等的，那么他们必须有相同的哈希值

isEqualToString：NSString方法，而NSString是继承自NSObject的，所以isEqualToString应该是isEqual的衍生方法，是对isEqual的细分，它的官方文档是这样写的
```
  Returns a Boolean value that indicates whether a given string is equal to the receiver using a literal Unicode-based comparison.
  返回一个bool值判断给出的字符串是否与已有的Unicode字符相同
```

如果知道了两个对象都是字符串，isEqualToString比isEqual要快
总结：【==、isEqual、isEqualToString判断字符串相等】isEqual比较的是hash返回的值，而==只是简单的内存地址比较，大部份情况==为YES的，isEqual也为YES，如果isEqual为YES的不一定==也为YES。
