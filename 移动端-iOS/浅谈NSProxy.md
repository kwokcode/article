# 
在项目优化中突然发现了NSTimer和CADisplayLink 在runloop的驱动下会有的时候出现内存无法释放情况,所以在决绝NSTimer的时候使用的是[关于iOS中由于 NSTimer 没有办法内存释放的问题的原理](https://www.jianshu.com/p/1303231098e2),但是在CADisplayLink中是没有办法使用的,所以在项目中直接使用了NSProxy,因此在主要是简单聊一下NSProxy的使用
1.看一下相关的苹果api
```
@interface NSProxy <NSObject> {
    Class	isa;
}
```
哇!是不是要搞事情啊?
怎么如此简单呢,知道我的人应该是知道我比较喜欢刨根问底,这是搞什么竟然是和NSObject 同根同源诶,是的的你没有猜错是这样的
```
@interface NSObject <NSObject> {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-interface-ivars"
    Class isa  OBJC_ISA_AVAILABILITY;
#pragma clang diagnostic pop
}
```
将NSObject中的一些预编译可以完全去掉,可以看到庐山的真面目
```
@interface NSObject <NSObject> {
 Class	isa;
}
@interface NSProxy <NSObject> {
  Class	isa;
}
```
这两位是不是很像啊? 没有猜错是的

上面我们可以看到NSProxy是一个实现了NSObject协议的根类。
苹果的官方文档是这样描述它的：
NSProxy 是一个抽象基类，它为一些表现的像是其它对象替身或者并不存在的对象定义API。一般的，发送给代理的消息被转发给一个真实的对象或者代理本身引起加载(或者将本身转换成)一个真实的对象。NSProxy的基类可以被用来透明的转发消息或者耗费巨大的对象的lazy 初始化。

NSProxy实现了包括NSObject协议在内基类所需的基础方法，但是作为一个抽象的基类并没有提供初始化的方法。
下面主要是介绍一下这个类的几个方法
```
+ (id)alloc; // 方法的初始化,注意呦,这个类没有init 和 new 方法的
+ (id)allocWithZone:(nullable NSZone *)zone NS_AUTOMATED_REFCOUNT_UNAVAILABLE;
// 返回类
+ (Class)class;
// 进行方法的重新签名 这个方法和容易的理解就是你需要让谁进行实现
- (nullable NSMethodSignature *)methodSignatureForSelector:(SEL)sel NS_SWIFT_UNAVAILABLE("NSInvocation and related APIs not available");
//处理自己没有实现的消息
- (void)forwardInvocation:(NSInvocation *)invocation;
// 销毁
- (void)dealloc;
// 应该忽略的方法（垃圾回收）
- (void)finalize;
// 描述
@property (readonly, copy) NSString *description;
@property (readonly, copy) NSString *debugDescription;
+ (BOOL)respondsToSelector:(SEL)aSelector;
// 在赋值给__weak修饰符的变量时，如果赋值对象的allowsWeakReference方法返回NO，程序将异常终止
- (BOOL)allowsWeakReference NS_UNAVAILABLE;
- (BOOL)retainWeakReference NS_UNAVAILABLE;
```

那么问题来了,NSObject 也有上面的两个方法 
```
- (id)forwardingTargetForSelector:(SEL)aSelector;
- (void)forwardInvocation:(NSInvocation *)anInvocation ;
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector;
```
那么两者有什么不同呢 
我想大家都知道NSObject找寻一个方法的三部曲吧(转换为objc_msgSend函数的调用)
1. 消息发送
2. 动态方法解析
3. 消息转发


而NSProxy 不会去父类找寻,而是直接进行相关的转发

那么他们的区别是什么呢简单的从GNU的源码进行查找一下
![image.png](https://upload-images.jianshu.io/upload_images/15063932-b55e5ce4f29cce08.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
主要是介绍一下那个 
isKindOfClass主要是NSObject 中的实现和NSProxy
```
NSProxy 
/**
 * Calls the -forwardInvocation: method to determine if the 'real' object
 * referred to by the proxy is an instance of the specified class.
 * Returns the result.<br />
 * NB. The default operation of -forwardInvocation: is to raise an exception.
 */
- (BOOL) isKindOfClass: (Class)aClass
{
  NSMethodSignature	*sig;
  NSInvocation		*inv;
  BOOL			ret;

  sig = [self methodSignatureForSelector: _cmd];
  inv = [NSInvocation invocationWithMethodSignature: sig];
  [inv setSelector: _cmd];
  [inv setArgument: &aClass atIndex: 2];
  [self forwardInvocation: inv];
  [inv getReturnValue: &ret];
  return ret;
}

NSObject
/**
 * Returns YES if the class of the receiver is either the same as aClass
 * or is derived from (a subclass of) aClass.
 */
- (BOOL) isKindOfClass: (Class)aClass
{
  Class class = object_getClass(self);

  return GSObjCIsKindOf(class, aClass);
}
```
从上面的代码可以知道完全进行消息了转发,所以咱们真的想使用中间对象的话,那么使用NSProxy是最好的.

下面写一下使用Timer 的代码 
```
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:[XHProxy proxyWithTarget:self] selector:@selector(timerTest) userInfo:nil repeats:YES];
}

- (void)timerTest
{
    NSLog(@"%s", __func__);
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
    [self.timer invalidate];
}



#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XHProxy : NSProxy
- (instancetype)initWithTarget:(id)target;;
+(instancetype)proxyWithTarget:(id)target;
@end

NS_ASSUME_NONNULL_END
#import "XHProxy.h"

@interface XHProxy()
@property(nonatomic,weak)id target;

@end

@implementation XHProxy

- (instancetype)initWithTarget:(id)target{
    _target = target;
    return self;
}
+(instancetype)proxyWithTarget:(id)target{
    // NSProxy对象不需要调用init，因为它本来就没有init方法 并且没有new 方法
    XHProxy *proxy = [XHProxy alloc];
    proxy.target = target;
    return proxy;
}
- (void)forwardInvocation:(NSInvocation *)invocation{
    SEL sel = [invocation selector];
    if ([self.target respondsToSelector:sel]) {
        [invocation invokeWithTarget:self.target];
    }
}
- (nullable NSMethodSignature *)methodSignatureForSelector:(SEL)sel NS_SWIFT_UNAVAILABLE("NSInvocation and related APIs not available")
{
    return [self.target methodSignatureForSelector:sel];
}
- (BOOL)respondsToSelector:(SEL)aSelector{
    return [self.target respondsToSelector:aSelector];
}
- (void)dealloc{
    _target = nil;
}

@end
```

demo 地址目前还在规划中,在不久的将来将会有全套的demo
