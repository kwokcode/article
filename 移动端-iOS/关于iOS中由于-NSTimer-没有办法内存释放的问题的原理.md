# 关于iOS中由于 NSTimer 没有办法内存释放的问题的原理
先看一下相关的倒计时代码
```
#import "AViewController.h"

@interface AViewController ()
@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, assign) int timeCount;
@end

@implementation AViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdown) userInfo:nil repeats:YES];
    // Do any additional setup after loading the view.
}
// 倒计时
-(void)countdown
{
    _timeCount ++;
    NSLog(@"-----%d-----",_timeCount);
    if (_timeCount >10) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
-(void)dealloc
{
    NSLog(@"%s",__func__);
}


@end
```
看到如上的代码，这是从公司的工程中看到，这样的代码看着本没有问题，在ctr退出的时候发现内存中还有AViewController这个控制器
![AViewController.png](https://upload-images.jianshu.io/upload_images/15063932-05eacf5b34375c20.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

在下面的的持有中有Time 但是不是实线，所以当时我没有在意
然后将断点打在了dealloc 过了很久然后看到执行
![dealloc.png](https://upload-images.jianshu.io/upload_images/15063932-f7582317ec010ddb.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)



如上图当时看到了timeRelease所以我怀疑是NSTimer 的问题
废话不多说了
其实其中有一个重要的原因是就是NSTimer 加入了到了系统的runLoop中 
![持有.png](https://upload-images.jianshu.io/upload_images/15063932-e0d1d7f3212e4a02.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
那么有人会想到使用weak 修饰一下ctr，想法很好但是其实是没有任何作用的，因为这个控制即使是弱引用还是引用，弱引用是为了防止循环引用，但是目前如上图没有循环引用
解决方案
使用NSTimer 新的api 
```
/// Creates and returns a new NSTimer object initialized with the specified block object. This timer needs to be scheduled on a run loop (via -[NSRunLoop addTimer:]) before it will fire.
/// - parameter:  timeInterval  The number of seconds between firings of the timer. If seconds is less than or equal to 0.0, this method chooses the nonnegative value of 0.1 milliseconds instead
/// - parameter:  repeats  If YES, the timer will repeatedly reschedule itself until invalidated. If NO, the timer will be invalidated after it fires.
/// - parameter:  block  The execution body of the timer; the timer itself is passed as the parameter to this block when executed to aid in avoiding cyclical references
///创建并返回使用指定块对象初始化的新NSTimer对象。 这个计时器需要在运行循环（通过 -  [NSRunLoop addTimer：]）之前安排，然后才能触发。
///  - 参数：timeInterval计时器触发之间的秒数。 如果seconds小于或等于0.0，则此方法选择非负值0.1毫秒
///  - 参数：重复如果是，则计时器将反复重新安排自己，直到无效。 如果为NO，计时器将在其触发后失效。
///  -  parameter：block计时器的执行体; 定时器本身在执行时作为参数传递给该块，以帮助避免循环引用
+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block API_AVAILABLE(macosx(10.12), ios(10.0), watchos(3.0), tvos(10.0));
```
其实新版的api 已经再次说明了无法释放的原因，但是这个只能在iOS10以后才能使用，那么iOS10之前呢？
我为NSTimer 添加了一个Category
```
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (Category)

/**
 香哈私有Timer 使用

 @param seconds 间隔时间
 @param block 回调
 @param repeats 是否重复
 @return NSTimer
 */
+ (NSTimer *)skScheduledTimerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats;

/**
 香哈私有Timer 使用

 @param seconds 间隔时间
 @param block 回调
 @param repeats 是否重复
 @return NSTimer
 */
+ (NSTimer *)skTimerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats;

@end

NS_ASSUME_NONNULL_END


#import "NSTimer+Category.h"

@implementation NSTimer (Category)
+ (void)skExecBlock:(NSTimer *)timer {
    if ([timer userInfo]) {
        void (^block)(NSTimer *timer) = (void (^)(NSTimer *timer))[timer userInfo];
        block(timer);
    }
}

+ (NSTimer *)skScheduledTimerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats {
    return [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(skExecBlock:) userInfo:[block copy] repeats:repeats];
}

+ (NSTimer *)skTimerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats {
    return [NSTimer timerWithTimeInterval:seconds target:self selector:@selector(skExecBlock:) userInfo:[block copy] repeats:repeats];
}

@end

```

这个方案其实是很简单的就是将NSTimer 加入 runLoop 那么 NSTimer 和 ctr 就是弱引用，不会有影响其生命周期

![block.png](https://upload-images.jianshu.io/upload_images/15063932-0db117466709414d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


希望对你有帮助
